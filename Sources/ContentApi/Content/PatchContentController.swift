//
//  PatchContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol PatchContentController: IdentifiableContentController where Model: PatchContentRepresentable {
    
    func beforePatch(req: Request, model: Model, content: Model.PatchContent) -> EventLoopFuture<Model>
    func patch(_: Request) throws -> EventLoopFuture<Model.GetContent>
    func afterPatch(req: Request, model: Model) -> EventLoopFuture<Void>
    func setupPatchRoute(on: RoutesBuilder)
}

public extension PatchContentController {

    func beforePatch(req: Request, model: Model, content: Model.PatchContent) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    func patch(_ req: Request) throws -> EventLoopFuture<Model.GetContent> {
        try Model.PatchContent.validate(content: req)
        let patch = try req.content.decode(Model.PatchContent.self)
        return try find(req)
            .flatMap { beforePatch(req: req, model: $0, content: patch) }
            .flatMapThrowing { model -> Model in
                try model.patch(patch)
                return model
            }
            .flatMap { model -> EventLoopFuture<Model.GetContent> in
                return model.update(on: req.db)
                    .flatMap { afterPatch(req: req, model: model) }
                    .transform(to: model.getContent)
            }
    }

    func afterPatch(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    func setupPatchRoute(on builder: RoutesBuilder) {
        builder.patch(idPathComponent, use: patch)
    }
}
