//
//  DeleteContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol DeleteContentController: IdentifiableContentController where Model: DeleteContentRepresentable {

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model>
    func delete(_: Request) throws -> EventLoopFuture<HTTPStatus>
    func afterDelete(req: Request) -> EventLoopFuture<Void>
    func setupDeleteRoute(on: RoutesBuilder)
}

public extension DeleteContentController {

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }

    func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try find(req)
            .flatMap { beforeDelete(req: req, model: $0) }
            .flatMap { $0.delete(on: req.db) }
            .flatMap { afterDelete(req: req) }
            .transform(to: .ok)
    }

    func afterDelete(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }
    
    func setupDeleteRoute(on builder: RoutesBuilder) {
        builder.delete(idPathComponent, use: delete)
    }
}
