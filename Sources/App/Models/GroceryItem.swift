//
//  GroceryItem.swift
//  App
//
//  Created by Joseph Tyler DiBartolo on 1/24/20.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct GroceryItem: Codable, Equatable {
    var id: UUID?
    let name: String
    let size: String?
    let comment: String?
    
    init(name: String,
         size: String? = nil,
         comment: String? = nil) {
        self.name = name
        self.size = size
        self.comment = comment
    }
    
    public static func ==(lhs: GroceryItem,
                          rhs: GroceryItem) -> Bool {
        if lhs.name.lowercased() != rhs.name.lowercased() {
            return false
        }
        return true
    }
}

// Allows saving to DB.
extension GroceryItem: PostgreSQLUUIDModel {}

// Creates in-memory DB and writes a GroceryItem table when testing.
extension GroceryItem: Migration {}

// Allows decoding from JSON body.
extension GroceryItem: Content {}

// Allows fetching a single instance by \.id when passed as a request parameter.
extension GroceryItem: Parameter {}
