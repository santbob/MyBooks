//
//  DetailsViewController.swift
//  MyBooks
//
//  Created by srao13  on 2/5/20.
//  Copyright © 2020 Santbob Inc. All rights reserved.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController, WKNavigationDelegate{
    
    var bookModel:BookModel? = nil
    
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var authorView: UILabel!
    @IBOutlet weak var yearView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    func updateUI()  {
        if bookModel != nil {
            self.title = bookModel?.title
            titleView.text = bookModel?.title
            authorView.text = bookModel?.author
            yearView.text = "\(1999)"
            imageView.image = UIImage(named: bookModel?.imageLink ?? "beloved")
            if let link = bookModel?.link {
                let url = URL(string: link.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
                spinner.startAnimating()
                webView.navigationDelegate = self;
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
    }
}
