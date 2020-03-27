//
//  HasActions.swift
//  ViewState
//
//  Created by Chris Ballinger on 11/13/19.
//

import Foundation

public protocol ActionsProtocol: class {}

public protocol HasActions: class {
    associatedtype Actions: ActionsProtocol
    var actions: Actions { get }
}
