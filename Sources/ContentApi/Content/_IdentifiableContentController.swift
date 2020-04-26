//
//  _IdentifiableContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

import Vapor
import Fluent

public protocol IdentifiableContentController: ContentController/*, Identifiable*/ {
    var idParamKey: String { get }
    func modelIdentifier(_ rawValue: String) throws -> Model.IDValue
}

public extension IdentifiableContentController {

    var idParamKey: String { "id" }
    var idPathComponent: PathComponent { .init(stringLiteral: ":\(self.idParamKey)") }
    
    func find(_ req: Request) throws -> EventLoopFuture<Model> {
        guard let rawValue = req.parameters.get(self.idParamKey) else {
            throw Abort(.badRequest)
        }
        let id = try self.modelIdentifier(rawValue)
        return Model.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }
}

public extension IdentifiableContentController where Model.IDValue == UUID {

    func modelIdentifier(_ rawValue: String) throws -> Model.IDValue {
        guard let id = UUID(uuidString: rawValue) else {
            throw Abort(.badRequest)
        }
        return id
    }
}
