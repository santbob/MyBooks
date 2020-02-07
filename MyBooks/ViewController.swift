//
//  ViewController.swift
//  MyBooks
//
//  Created by srao13  on 2/5/20.
//  Copyright © 2020 Santbob Inc. All rights reserved.
//

import UIKit


class BooksTableViewCell: UITableViewCell {
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellSubTitle: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellAddlText1: UILabel!
    @IBOutlet weak var cellAddlText2: UILabel!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchActive = false;
    var tableData: Array<BookModel> = Array()
    var filteredData: Array<BookModel> = Array()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadTableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filteredData.count : tableData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BooksTableViewCell
        let dataToUse = searchActive ? filteredData : tableData
        
        guard indexPath.row < dataToUse.count else {
            return cell;
        }
        
        let data:BookModel = dataToUse[indexPath.row]
        
        cell.cellTitle?.text = "\(data.title)"
        cell.cellSubTitle?.text = "\(data.author)"
        cell.cellImage?.image = UIImage(named: data.imageLink)
        cell.cellAddlText1.text = "year: \(data.year)"
        cell.cellAddlText2.text = "pages: \(data.pages)"
        return cell
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = tableData.filter({ (book) -> Bool in
            let bookModel: BookModel = book
            return bookModel.title.contains(searchText) || bookModel.author.contains(searchText)
        })
        
        if(filteredData.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }
    
    func loadTableData() {
        guard let mainUrl = Bundle.main.url(forResource: "testData", withExtension: "json") else { return }
        
        do{
            let jsonData = try Data(contentsOf: mainUrl)
            let decoder = JSONDecoder()
            tableData = try decoder.decode([BookModel].self, from: jsonData)
        } catch {}
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            let vc = segue.destination as? DetailsViewController
            vc?.bookModel = getBookForIndex(index: tableView.indexPathForSelectedRow?.row ?? 0)
        }
    }
    
    
    func getBookForIndex(index: Int) -> BookModel? {
        let dataToUse = searchActive ? filteredData : tableData
        guard index >= 0, index < dataToUse.count else { return nil}
        return dataToUse[index]
    }
}

