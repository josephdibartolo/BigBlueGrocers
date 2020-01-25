import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentSQLiteProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    
//    let databaseName: String
//    let databasePort: Int
//    // 1
//    if (env == .testing) {
//      databaseName = "vapor-test"
//      databasePort = 5433
//    } else {
//      databaseName = "vapor"
//      databasePort = 5432
//    }
    
//    let databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost",
//                                                  port: databasePort,
//                                                  username: "vapor",
//                                                  database: databaseName,
//                                                  password: "password")
    
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: GroceryItem.self, database: .sqlite)
    services.register(migrations)
    
    // Configure command-line handler
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
}
