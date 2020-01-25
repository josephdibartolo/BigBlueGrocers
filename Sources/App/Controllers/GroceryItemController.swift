//
//  GroceryItemController.swift
//  App
//
//  Created by Joseph Tyler DiBartolo on 1/25/20.
//

import Vapor

final class GroceryItemController: RouteCollection {
    
    func createHandler(_ req: Request) throws -> Future<GroceryItem> {
        return try req.content.decode(GroceryItem.self).flatMap { item in
            return item.save(on: req)
        }
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[GroceryItem]> {
        return GroceryItem.query(on: req).decode(GroceryItem.self).all()
    }
    
    func getOneHandler(_ req: Request) throws -> Future<GroceryItem> {
        return try req.parameters.next(GroceryItem.self)
    }
    
//    // Currently not implementing update functionality; here for reference.
//    func updateHandler(_ req: Request) throws -> Future<GroceryItem> {
//        return try flatMap(to: GroceryItem.self, req.parameters.next(GroceryItem.self), req.content.decode(GroceryItem.self)) { (item, updatedItem) in
//            item.name = updatedItem.name
//            item.size = updatedItem.username
//            item.comment = updatedItem.comment
//            return item.save(on: req)
//        }
//    }
    
//    // Currently not implementing delete functionality; here for reference.
//    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
//        return try req.parameters.next(GroceryItem.self).flatMap { item in
//            return item.delete(on: req).transform(to: HTTPStatus.noContent)
//        }
//    }
    
    func boot(router: Router) throws {
        let itemsRoute = router.grouped("api", "items")
        itemsRoute.get(use: getAllHandler)
        itemsRoute.get(GroceryItem.parameter, use: getOneHandler)
        itemsRoute.post(use: createHandler)
    }
    
}
