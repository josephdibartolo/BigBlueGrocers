//
//  GroceryServiceTests.swift
//  AppTests
//
//  Created by Joseph Tyler DiBartolo on 1/25/20.
//

@testable import App
import XCTest
import Vapor
import FluentPostgreSQL

class GroceryServiceTests: XCTestCase {
    
    let itemName = "Apples"
    let itemSize = "Small"
    let itemsURI = "/api/items/"
    var app: Application!
    var conn: PostgreSQLConnection!

    override func setUp() {
        try! Application.reset()
        app = try! Application.testable()
        conn = try! app.newConnection(to: .psql).wait()
    }

    override func tearDown() {
        conn.close()
        try? app.syncShutdownGracefully()
    }

    func test_ItemsCanBeRetrievedFromAPI() throws {
        let item = try GroceryItem.create(name: itemName, size: itemSize, on: conn)
        _ = try GroceryItem.create(on: conn)

        let items = try app.getResponse(to: itemsURI, decodeTo: [GroceryItem].self)

        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].name, itemName)
        XCTAssertEqual(items[0].size, itemSize)
        XCTAssertEqual(items[0].id, item.id)
    }
    
    func test_ItemCanBeSavedWithAPI() throws {
        let item = GroceryItem(name: itemName, size: itemSize, comment: nil)
        
        let receivedItem = try app.getResponse(to: itemsURI,
                                               method: .POST,
                                               headers: ["Content-Type": "application/json"],
                                               data: item,
                                               decodeTo: GroceryItem.self)
        
        XCTAssertEqual(receivedItem.name, itemName)
        XCTAssertEqual(receivedItem.size, itemSize)
        XCTAssertNotNil(receivedItem.id)

        let items = try app.getResponse(to: itemsURI, decodeTo: [GroceryItem].self)

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].name, itemName)
        XCTAssertEqual(items[0].size, itemSize)
        XCTAssertEqual(items[0].id, receivedItem.id)
    }
    
    func testGettingASingleUserFromTheAPI() throws {
        let item = try GroceryItem.create(name: itemName, size: itemSize, on: conn)

        let receivedItem = try app.getResponse(to: "\(itemsURI)\(item.id!)",
                                                decodeTo: GroceryItem.self)

        XCTAssertEqual(receivedItem.name, itemName)
        XCTAssertEqual(receivedItem.size, itemSize)
        XCTAssertEqual(receivedItem.id, item.id)
    }

}
