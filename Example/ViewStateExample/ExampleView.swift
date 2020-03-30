//
//  ExampleView.swift
//  ViewStateExample
//
//  Created by Chris Ballinger on 3/30/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import ViewState
import UIKit
import SwiftUI

final class ExampleView: UIView {

    struct ViewState: ViewStateProtocol {
        var topLabelText: String = ""
        var bottomLabelText: String = ""
    }

    @Observed
    var state: ViewState

    private let topLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .black

        let stack = UIStackView(arrangedSubviews: [topLabel, bottomLabel])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.spacing = 10
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExampleView: HasViewState {
    func render(state: ViewState, oldState: ViewState?, animated: Bool) {
        topLabel.text = state.topLabelText
        bottomLabel.text = state.bottomLabelText
    }
}

@available(iOS 13.0, *)
extension ExampleView.ViewState: UIViewRepresentable {
    typealias UIViewType = ExampleView
}

#if DEBUG

@available(iOS 13.0, *)
struct ExampleView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ExampleView.ViewState(
                topLabelText: "Heading",
                bottomLabelText: "Subheading"
            )
                .previewDevice("iPhone 11 Pro Max")
                .previewLayout(.sizeThatFits)

            ExampleView.ViewState(
                topLabelText: "Heading",
                bottomLabelText: "Subheading"
            )
                .previewDevice("iPhone SE")
                .previewLayout(.sizeThatFits)
        }
    }
}

#endif
