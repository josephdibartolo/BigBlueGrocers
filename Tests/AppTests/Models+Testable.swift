
@testable import App
import FluentPostgreSQL

extension GroceryItem {
    
    static func create(name: String = "Apples", size: String = "Small",
                       on connection: PostgreSQLConnection) throws -> GroceryItem {
        let item = GroceryItem(name: name, size: size)
        return try item.save(on: connection).wait()
    }
    
}
