//
//  ListContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol ListContentController: ContentController where Model: ListContentRepresentable {
    func list(_: Request) throws -> EventLoopFuture<Page<Model.ListItem>>
    func setupListRoute(on: RoutesBuilder)
}

public extension ListContentController {

    func list(_ req: Request) throws -> EventLoopFuture<Page<Model.ListItem>> {
        Model.query(on: req.db).paginate(for: req).map { $0.map(\.listContent) }
    }
    
    func setupListRoute(on builder: RoutesBuilder) {
        builder.get(use: list)
    }

}
