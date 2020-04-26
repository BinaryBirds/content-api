//
//  ContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

import Vapor
import Fluent

public protocol ContentController {
    
    associatedtype Model: Fluent.Model
}
