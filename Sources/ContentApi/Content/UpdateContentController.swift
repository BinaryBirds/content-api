//
//  UpdateContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

import Vapor
import Fluent

public protocol UpdateContentController: IdentifiableContentController where Model: UpdateContentRepresentable {

    func beforeUpdate(req: Request, model: Model, content: Model.UpdateContent) -> EventLoopFuture<Model>
    func update(_ req: Request) throws -> EventLoopFuture<Model.GetContent>
    func afterUpdate(req: Request, model: Model) -> EventLoopFuture<Void>
    func setupUpdateRoute(routes: RoutesBuilder)
}

public extension UpdateContentController {

    func beforeUpdate(req: Request, model: Model, content: Model.UpdateContent) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    func update(_ req: Request) throws -> EventLoopFuture<Model.GetContent> {
        let input = try req.content.decode(Model.UpdateContent.self)
        return try self.find(req)
        .flatMap { model in
            self.beforeUpdate(req: req, model: model, content: input)
        }
        .flatMapThrowing { model -> Model in
            try model.update(input)
            return model
        }
        .flatMap { model -> EventLoopFuture<Model.GetContent> in
             return model.update(on: req.db)
                .flatMap { self.afterUpdate(req: req, model: model) }
                .transform(to: model.getContent)
        }
    }
    
    func afterUpdate(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }
    
    func setupUpdateRoute(routes: RoutesBuilder) {
        routes.put(self.idPathComponent, use: self.update)
    }
}
