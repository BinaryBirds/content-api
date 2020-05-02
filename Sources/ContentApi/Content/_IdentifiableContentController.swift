//
//  _IdentifiableContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol IdentifiableContentController: ContentController {

    var idParamKey: String { get }
    var idPathComponent: PathComponent { get }
    func find(_ req: Request) throws -> EventLoopFuture<Model>
}

public extension IdentifiableContentController {

    var idParamKey: String { "id" }
    var idPathComponent: PathComponent { .init(stringLiteral: ":" + self.idParamKey) }
}

public extension IdentifiableContentController where Model.IDValue == UUID {

    func find(_ req: Request) throws -> EventLoopFuture<Model> {
        guard
            let rawValue = req.parameters.get(self.idParamKey),
            let id = UUID(uuidString: rawValue)
        else {
            throw Abort(.badRequest)
        }
        return Model.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }
}
