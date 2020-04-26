//
//  ListContentRepresentable.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

import Vapor

public protocol ListContentRepresentable {
    associatedtype ListItem: Content

    var listContent: ListItem { get }
}

