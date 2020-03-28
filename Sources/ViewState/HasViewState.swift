//
//  HasViewState.swift
//  ViewState
//
//  Created by Chris Ballinger on 8/20/19.
//

import UIKit

public protocol ViewStateProtocol: HasBuilder, HasEmptyInit, Equatable {}

public protocol HasViewState: AnyObject {
    associatedtype ViewState: ViewStateProtocol
    var state: ViewState { get set }
    /// `animated` is set to false if the view is off screen or zero size
    func render(state: ViewState, oldState: ViewState?, animated: Bool)

    /// skips render pass if state and oldState are equal. calls `render` with `animated` set to false if the view is off screen or zero size
    func renderIfNeeded(state: ViewState, oldState: ViewState?)
}

extension HasViewState where Self: NSObject {
    public init(state: ViewState) {
        self.init()
        self.state = state
        render(state: state, oldState: nil, animated: false)
    }
}

extension HasViewState where Self: UIView {
    public func renderIfNeeded(state: ViewState, oldState: ViewState?) {
        guard state != oldState else { return }
        let animated = window != nil && !frame.isEmpty
        render(state: state, oldState: oldState, animated: animated)
    }
}

extension HasViewState where Self: UIViewController {
    public func renderIfNeeded(state: ViewState, oldState: ViewState?) {
        guard state != oldState else { return }
        let animated = viewIfLoaded?.window != nil
        render(state: state, oldState: oldState, animated: animated)
    }
}

