//
//  UpdateContentRepresentable.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 25..
//

import Vapor

public protocol UpdateContentRepresentable: GetContentRepresentable {
    associatedtype UpdateContent: ValidatableContent
    func update(_: UpdateContent) throws
}

public extension UpdateContentRepresentable {
    func update(_: UpdateContent) throws {}
}
