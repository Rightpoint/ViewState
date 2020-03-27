//
//  HasEmptyInit.swift
//  ViewState
//
//  Created by Zev Eisenberg on 12/6/19.
//

public protocol HasEmptyInit {
    init()
    static var empty: Self { get }
}

public extension HasEmptyInit {
    static var empty: Self { .init() }
}
