//
//  CharactersDataClass.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 13/10/2022.
//

import Foundation

struct CharactersDataClass: Codable{
    var url: String?
    var name: String?
    var gender: String?
    var culture: String?
    var born: String?
    var died: String?
    var titles: [String]?
    var aliases: [String]?
    var father: String?
    var mother: String?
    var spouse: String?
    var allegiances: [String]?
    var books: [String]?
    var povBooks: [String]?
    var tvSeries: [String]?
    var playedBy: [String]?
}
