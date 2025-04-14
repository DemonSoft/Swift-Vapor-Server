import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: ProfileController())
    try app.register(collection: ProductController())
    try app.register(collection: UserController())
    try app.register(collection: ImageController())
    try app.register(collection: ResetPassController())
    try app.register(collection: PushController())
    try app.register(collection: PaymentController())
    
    app.routes.defaultMaxBodySize = "1Mb"
}
