//
//  BookModel.swift
//  MyBooks
//
//  Created by srao13  on 2/5/20.
//  Copyright © 2020 Santbob Inc. All rights reserved.
//

import Foundation


struct BookModel : Codable {
    var author: String
    var imageLink: String
    var link: String
    var pages: Int
    var title: String
    var year: Int
}
