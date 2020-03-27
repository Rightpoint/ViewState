//
//  ViewController.swift
//  ViewStateExample
//
//  Created by Chris Ballinger on 3/26/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import UIKit
import ViewState
import SwiftUI

final class ViewController: UIViewController {

    struct ViewState: ViewStateProtocol {
        var labelText: String = "Example"
        var labelColor: UIColor = .black
    }

    var state = ViewState() {
        didSet {
            renderIfNeeded(state: state, oldState: oldValue)
        }
    }

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let stack = UIStackView(arrangedSubviews: [label])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ViewController: HasViewState {
    func render(state: ViewState, oldState: ViewState?, animated: Bool) {
        label.text = state.labelText
        label.textColor = state.labelColor
    }
}

@available(iOS 13.0, *)
extension ViewController.ViewState: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
}

#if DEBUG

@available(iOS 13.0, *)
struct OnboardingPageViewController_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ViewController.ViewState(
                labelText: "Test 1"
            ).previewDevice("iPhone 11 Pro Max")

            ViewController.ViewState(
                labelText: "Test 2",
                labelColor: .blue
            ).previewDevice("iPhone SE")
        }
    }
}

#endif
