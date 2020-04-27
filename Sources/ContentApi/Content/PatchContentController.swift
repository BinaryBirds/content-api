//
//  PatchContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

import Vapor
import Fluent

public protocol PatchContentController: IdentifiableContentController where Model: PatchContentRepresentable {
    
    func beforePatch(req: Request, model: Model, content: Model.PatchContent) -> EventLoopFuture<Model>
    func patch(_ req: Request) throws -> EventLoopFuture<Model.GetContent>
    func afterPatch(req: Request, model: Model) -> EventLoopFuture<Void>
    func setupPatchRoute(routes: RoutesBuilder)
}

public extension PatchContentController {

    func beforePatch(req: Request, model: Model, content: Model.PatchContent) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    func patch(_ req: Request) throws -> EventLoopFuture<Model.GetContent> {
        try Model.PatchContent.validate(req)
        let patch = try req.content.decode(Model.PatchContent.self)
        return try self.find(req)
        .flatMap { model in
            self.beforePatch(req: req, model: model, content: patch)
        }
        .flatMapThrowing { model -> Model in
            try model.patch(patch)
            return model
        }
        .flatMap { model -> EventLoopFuture<Model.GetContent> in
            return model.update(on: req.db)
                .flatMap { self.afterPatch(req: req, model: model) }
                .transform(to: model.getContent)
        }
    }

    func afterPatch(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    func setupPatchRoute(routes: RoutesBuilder) {
        routes.patch(self.idPathComponent, use: self.patch)
    }
}
