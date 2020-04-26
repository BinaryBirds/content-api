//
//  ApiRepresentable.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

import Vapor

public protocol ApiRepresentable: ListContentRepresentable,
    // silence redundant conformance warning
    //GetContentRepresentable,
    CreateContentRepresentable,
    UpdateContentRepresentable,
    PatchContentRepresentable,
    DeleteContentRepresentable
{
    
}
