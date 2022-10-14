//
//  BooksDataClass.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 14/10/2022.
//

import Foundation

struct BooksDataClass: Codable{
    var url: String?
    var name: String?
    var isbn: String?
    var authors: [String]
    var numberOfPages: Int?
    var publisher: String?
    var country: String?
    var mediaType: String?
    var released: String?
    var characters: [String?]
    var povCharacters: [String?]
}
