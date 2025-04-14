//
//  PaymentController.swift
//  
//
//  Created by Dmitriy Soloshenko on 02.05.2023.
//

import Fluent
import Vapor
import StripeKit

struct PaymentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let payments = routes.root.grouped("payments")
        
        let protected = payments.grouped(UserToken.authenticator())
//        protected.post(use: createPayment)
        
        protected.group("intent") { item in
            item.get(":id", use: intent)
        }

    }
    
//    func createPayment(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
//
//        struct DTO : Content {
//            let amount: Int // Cents
//            let currency: StripeCurrency
//            let description: String
//            let stripeToken: String
//        }
//
//        guard let dto = try? req.content.decode(DTO.self) else {
//            throw Abort(.badRequest, reason: "Cannot decodable input params")
//        }
//
//        // Инициализируем клиент Stripe API с помощью нашего секретного ключа
//        let stripe = StripeClient(httpClient: req.application.http.client.shared,
//                                  eventLoop: req.eventLoop,
//                                  apiKey: Constants.stipePrivateKey)
//
//        return stripe.charges.create(amount: dto.amount,
//                                     currency: dto.currency,
//                                     description: dto.description,
//                                     source: dto.stripeToken)
//            .map { _ in
//                return .ok
//            }
//            .flatMapErrorThrowing { error in
//                // Обработка ошибки при оплате
//                throw Abort(.badRequest, reason: error.localizedDescription)
//            }
//    }
    
    func intent(_ req: Request) async throws -> Response {
        struct DTO : Content {
            let customerId: String
            let paymentIntent: String?
            let ephemeralKeySecret: String?
            let pubKey:String
            let productId:UUID?
        }

        try await Profile.auth(req)
        
        let profile = try await req.me()
        let user = try req.user()
        
        guard let product = try await Product.find(req.parameters.get("id"), on: req.db) else {
            return Response.fail(Mistakes.idNotFound)
        }

        let httpClient = HTTPClient(eventLoopGroupProvider: .shared(req.eventLoop))
        defer {
            try? httpClient.syncShutdown()
        }
        let apiKey = Constants.stipePrivateKey
        let stripe = StripeClient(httpClient: httpClient, eventLoop: req.eventLoop, apiKey: apiKey)
        
        let customer = try await stripe.customers.create(email:user.email, name: profile.fullName).get()
        let customerID = customer.id

        let ephemeralKey = try await stripe.ephemeralKeys.create(customer: customerID).get()
        let ephemeralKeySecr = ephemeralKey.secret
        
        let paymentIntent = stripe.paymentIntents.create(amount: product.price, // cents
                                                         currency: product.currency,
                                                         description: product.name,
                                                         paymentMethodTypes: ["card"])

        let intent = try await paymentIntent.get()
        let clientSecret = intent.clientSecret

        let dto = DTO(customerId: customerID,
                      paymentIntent: clientSecret,
                      ephemeralKeySecret: ephemeralKeySecr,
                      pubKey: Constants.stipePublicKey,
                      productId: product.id
        )
        return Response.success(dto)
    }
}
