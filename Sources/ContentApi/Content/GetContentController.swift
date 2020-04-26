//
//  GetContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

import Vapor
import Fluent

public protocol GetContentController: IdentifiableContentController where Model: GetContentRepresentable {
    func get(_: Request) throws -> EventLoopFuture<Model.GetContent>
    func setupGetRoute(routes: RoutesBuilder)
}

public extension GetContentController {
    func get(_ req: Request) throws -> EventLoopFuture<Model.GetContent> {
        try self.find(req).map(\.getContent)
    }

    func setupGetRoute(routes: RoutesBuilder) {
        routes.get(self.idPathComponent, use: self.get)
    }
}

