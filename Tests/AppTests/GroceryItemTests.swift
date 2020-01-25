//
//  GroceryItemTests.swift
//  AppTests
//
//  Created by Joseph Tyler DiBartolo on 1/25/20.
//

@testable import App
import XCTest

class GroceryItemTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Init_WithName_SetsName() {
        let item = GroceryItem(name: "Apples")
        XCTAssertEqual("Apples", item.name)
    }
    
    func test_Init_WithSize_SetsSize() {
        let item = GroceryItem(name: "Apples", size: "Small")
        XCTAssertEqual("Small", item.size)
    }
    
    func test_Init_WithComment_SetsComment() {
        let comment = "Soft is alright, for baking."
        let item = GroceryItem(name: "Apples", comment: comment)
        XCTAssertEqual(comment, item.comment)
    }
    
    func test_ItemsWithSameNamesDisregardingCase_AreEqual() {
        let item1 = GroceryItem(name: "Apples")
        let item2 = GroceryItem(name: "applEs")
        XCTAssertEqual(item1, item2)
    }

}
