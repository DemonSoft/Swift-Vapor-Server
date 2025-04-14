import Fluent
import FluentPostgresDriver
import Vapor
import Smtp
import APNS
import JWTKit

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST")      ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME")  ?? "hermes_username",
        password: Environment.get("DATABASE_PASSWORD")  ?? "hermes_password",
        database: Environment.get("DATABASE_NAME")      ?? "hermes_database"
    ), as: .psql)

    app.migrations.add(Profile.Migration())
    app.migrations.add(User.Migration())
    app.migrations.add(Product.Migration())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(Confirmation.Migration())
    app.migrations.add(Image.Migration())
    app.migrations.add(PushToken.Migration())
    app.migrations.add(Push.Migration())
    try app.autoMigrate().wait()
    
    // SMTP
    let smtp_host = Environment.get("SMTP_HOST")        ?? "smtp.gmail.com"
    let smtp_port = Int(Environment.get("SMTP_PORT")    ?? "") ?? 465
    let smtp_auth = Environment.get("SMTP_AUTH")        ?? "<YOUR email on mail server>"
    let smtp_pass = Environment.get("SMTP_PASS")        ?? "<YOUR password to your mail server>"
    app.smtp.configuration.hostname     = smtp_host
    app.smtp.configuration.port         = smtp_port
    app.smtp.configuration.secure       = .ssl
    app.smtp.configuration.signInMethod = .credentials(username: smtp_auth, password: smtp_pass)
                                                        
    
    // ONLY FOR PRODUCT - It restricts using API
    // app.middleware.use(CerberusMiddleware())

    // register routes
    try routes(app)
    
    
    
    // THIS IS TEMPORARY CODE ---------------------------
    //    let fileMngr = FileManager.default
    //    let current = "\(fileMngr.currentDirectoryPath)"
    //    print("[ PATH: ] \(current)")
    //    let files = try fileMngr.contentsOfDirectory(atPath:current)
    //    print("[ FILES: ] \(files)")
    // THIS IS TEMPORARY CODE ---------------------------

    // Configure APNS using JWT authentication.
    app.apns.configuration = try .init(
        authenticationMethod: .jwt(
            key: .private(filePath: Constants.apnCertPath),
            keyIdentifier: JWKIdentifier(string: Constants.keyIdentifier),
            teamIdentifier: Constants.teamIdentifier
        ),
        topic: Constants.apnTopic,
        environment: .sandbox
    )
    
    //app.lifecycle.use(Storage())
}
