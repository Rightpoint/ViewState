//
//  Representable+HasViewState.swift
//  ViewState
//
//  Created by Zev Eisenberg on 10/16/19.
//

import SwiftUI

@available(iOS 13.0, *)
public extension UIViewRepresentable where UIViewType: HasViewState, Self == UIViewType.ViewState {

    @available(iOS 13.0, *)
    func makeUIView(context: Context) -> UIViewType {
        UIViewType(state: self)
    }

    @available(iOS 13.0, *)
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.state = self
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

}

@available(iOS 13.0, *)
public extension UIViewControllerRepresentable where UIViewControllerType: HasViewState, Self == UIViewControllerType.ViewState {

    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> UIViewControllerType {
        UIViewControllerType(state: self)
    }

    @available(iOS 13.0, *)
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.state = self
    }
}
