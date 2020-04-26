//
//  DeleteContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

import Vapor
import Fluent

public protocol DeleteContentController: IdentifiableContentController where Model: DeleteContentRepresentable {

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model>
    func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus>
    func afterDelete(req: Request) -> EventLoopFuture<Void>
    func setupDeleteRoute(routes: RoutesBuilder)
}

public extension DeleteContentController {

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }

    func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try self.find(req)
            .flatMap { self.beforeDelete(req: req, model: $0) }
            .flatMap { $0.delete(on: req.db) }
            .flatMap { self.afterDelete(req: req) }
            .transform(to: .ok)
    }

    func afterDelete(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }
    
    func setupDeleteRoute(routes: RoutesBuilder) {
        routes.delete(self.idPathComponent, use: self.delete)
    }
}
