//
//  GroceryServiceTests.swift
//  AppTests
//
//  Created by Joseph Tyler DiBartolo on 1/25/20.
//

@testable import App
import XCTest
import Vapor
import FluentSQLite

class GroceryServiceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // SEE: https://www.raywenderlich.com/1002044-testing-in-vapor
    func testItemsCanBeRetrievedFromAPI() throws {
        
//        // Adding reversion on DB; only necessary when using external persistent store.
//        // 1
//        let revertEnvironmentArgs = ["vapor", "revert", "--all", "-y"]
//        // 2
//        var revertConfig = Config.default()
//        var revertServices = Services.default()
//        var revertEnv = Environment.testing
//        // 3
//        revertEnv.arguments = revertEnvironmentArgs
//        // 4
//        try App.configure(&revertConfig, &revertEnv, &revertServices)
//        let revertApp = try Application(config: revertConfig, environment: revertEnv,
//                                        services: revertServices)
//        try App.boot(revertApp)
//        // 5
//        try revertApp.asyncRun().wait()
//
//        // 6
//        let migrateEnvironmentArgs = ["vapor", "migrate", "-y"]
//        var migrateConfig = Config.default()
//        var migrateServices = Services.default()
//        var migrateEnv = Environment.testing
//        migrateEnv.arguments = migrateEnvironmentArgs
//        try App.configure(&migrateConfig, &migrateEnv, &migrateServices)
//        let migrateApp = try Application(config: migrateConfig, environment: migrateEnv,
//                                         services: migrateServices)
//        try App.boot(migrateApp)
//        try migrateApp.asyncRun().wait()
        
        // Original test method.
        // 1
        let expectedName = "Apples"
        let expectedSize = "Small"
        let expectedComment = "For baking."

        // 2
        var config = Config.default()
        var services = Services.default()
        var env = Environment.testing
        try App.configure(&config, &env, &services)
        let app = try Application(config: config, environment: env, services: services)
        try App.boot(app)

        // 3
        let conn = try app.newConnection(to: .sqlite).wait()

        // 4
        let item = GroceryItem(name: expectedName, size: expectedSize, comment: expectedComment)
        let savedItem = try item.save(on: conn).wait()
        _ = try GroceryItem(name: "Bananas", size: "Bunch").save(on: conn).wait()

        // 5
        let responder = try app.make(Responder.self)

        // 6
        let request = HTTPRequest(method: .GET, url: URL(string: "/api/items")!)
        let wrappedRequest = Request(http: request, using: app)

        // 7
        let response = try responder.respond(to: wrappedRequest).wait()

        // 8
        let data = response.http.body.data
        let items = try JSONDecoder().decode([GroceryItem].self, from: data!)

        // 9
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].name, expectedName)
        XCTAssertEqual(items[0].comment, expectedComment)
        XCTAssertEqual(items[0].size, expectedSize)
        XCTAssertEqual(items[0].id, savedItem.id)

        // 10
        conn.close()
    }

}
