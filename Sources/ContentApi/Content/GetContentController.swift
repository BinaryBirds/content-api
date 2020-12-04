//
//  GetContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol GetContentController: IdentifiableContentController where Model: GetContentRepresentable {
    func get(_: Request) throws -> EventLoopFuture<Model.GetContent>
    func setupGetRoute(on: RoutesBuilder)
}

public extension GetContentController {

    func get(_ req: Request) throws -> EventLoopFuture<Model.GetContent> {
        try find(req).map(\.getContent)
    }

    func setupGetRoute(on builder: RoutesBuilder) {
        builder.get(idPathComponent, use: get)
    }
}

