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
        var labelText: String = ""
        var labelColor: UIColor = .black
    }

    @Observed
    var state: ViewState

    private let exampleView = ExampleView()

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let stack = UIStackView(arrangedSubviews: [exampleView,
                                                   UIView(),
                                                   label])
        stack.axis = .vertical
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

        exampleView.state.update {
            $0.topLabelText = "Heading"
            $0.bottomLabelText = "Subheading"
        }
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
struct ViewController_Previews: PreviewProvider {

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
