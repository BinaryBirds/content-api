//
//  ApiController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor
import Fluent

public protocol ApiController:
    ListContentController,
    GetContentController,
    CreateContentController,
    UpdateContentController,
    PatchContentController,
    DeleteContentController
{
    func setupRoutes(routes: RoutesBuilder, on pathComponent: PathComponent)
}

public extension ApiController {

    func setupRoutes(routes: RoutesBuilder, on pathComponent: PathComponent) {
        let modelRoutes = routes.grouped(pathComponent)
        self.setupListRoute(routes: modelRoutes)
        self.setupGetRoute(routes: modelRoutes)
        self.setupCreateRoute(routes: modelRoutes)
        self.setupUpdateRoute(routes: modelRoutes)
        self.setupPatchRoute(routes: modelRoutes)
        self.setupDeleteRoute(routes: modelRoutes)
    }
}
