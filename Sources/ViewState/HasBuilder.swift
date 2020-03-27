//
//  HasBuilder.swift
//  ViewState
//
//  Created by Chris Ballinger on 11/13/19.
//

import Foundation

public protocol HasBuilder {
    mutating func update(_ builder: (inout Self) -> Void)
}

public extension HasBuilder {
    mutating func update(_ builder: (inout Self) -> Void) {
        var newState = self
        builder(&newState)
        self = newState
    }
}
