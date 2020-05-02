//
//  CreateContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol CreateContentController: ContentController where Model: CreateContentRepresentable {

    func beforeCreate(req: Request, model: Model, content: Model.CreateContent) -> EventLoopFuture<Model>
    func create(_ req: Request) throws -> EventLoopFuture<Model.GetContent>
    func afterCreate(req: Request, model: Model) -> EventLoopFuture<Void>
    func setupCreateRoute(routes: RoutesBuilder)
}

public extension CreateContentController {

    func beforeCreate(req: Request, model: Model, content: Model.CreateContent) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Model.GetContent> {
        try Model.CreateContent.validate(req)
        let input = try req.content.decode(Model.CreateContent.self)
        let model = Model()
        return self.beforeCreate(req: req, model: model, content: input)
        .flatMap { model in
            do {
                try model.create(input)
                return model.create(on: req.db)
                    .flatMap { self.afterCreate(req: req, model: model) }
                    .transform(to: model.getContent)
            }
            catch {
                return req.eventLoop.future(error: error)
            }
        }
    }
    
    func afterCreate(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    func setupCreateRoute(routes: RoutesBuilder) {
        routes.post(use: self.create)
    }
}
