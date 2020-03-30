//
//  ViewStateTests.swift
//  ViewStateTests
//
//  Created by Chris Ballinger on 3/30/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import XCTest
import UIKit
import SwiftUI
@testable import ViewState

final class TestViewController: UIViewController {
    struct ViewState: ViewStateProtocol {
        var labelText = ""
    }

    @Observed
    var state: ViewState

    let label = UILabel()

    var renderClosure: ((_ state: ViewState, _ oldState: ViewState?, _ animated: Bool) -> Void)?
}

extension TestViewController: HasViewState {
    func render(state: ViewState, oldState: ViewState?, animated: Bool) {
        label.text = state.labelText
        renderClosure?(state, oldState, animated)
    }
}

extension TestViewController.ViewState: UIViewControllerRepresentable {
    typealias UIViewControllerType = TestViewController
}


final class TestView: UIView {
    struct ViewState: ViewStateProtocol {
        var labelText = ""
    }

    @Observed
    var state: ViewState

    let label = UILabel()

    var renderClosure: ((_ state: ViewState, _ oldState: ViewState?, _ animated: Bool) -> Void)?
}

extension TestView: HasViewState {
    func render(state: ViewState, oldState: ViewState?, animated: Bool) {
        label.text = state.labelText
        renderClosure?(state, oldState, animated)
    }
}

extension TestView.ViewState: UIViewRepresentable {
    typealias UIViewType = TestView
}

final class ViewStateTests: XCTestCase {
    func testVCStateUpdate() throws {
        let initialText = "Initial"
        let updatedText = "Updated"
        let testVC = TestViewController(state: .init(labelText: initialText))
        XCTAssertEqual(testVC.label.text, initialText)
        testVC.renderClosure = { (state, oldState, animated) in
            XCTAssertEqual(state.labelText, updatedText)
            XCTAssertEqual(oldState?.labelText, initialText)
            XCTAssertFalse(animated)
        }
        testVC.state.update {
            $0.labelText = updatedText
        }
        XCTAssertEqual(testVC.label.text, updatedText)

        testVC.renderClosure = { (state, oldState, animated) in
            XCTFail("Render update should be skipped when state == oldState")
        }
        testVC.state.update {
            $0.labelText = updatedText
        }
    }

    func testViewStateUpdate() throws {
        let initialText = "Initial"
        let updatedText = "Updated"
        let testVC = TestView(state: .init(labelText: initialText))
        XCTAssertEqual(testVC.label.text, initialText)
        testVC.renderClosure = { (state, oldState, animated) in
            XCTAssertEqual(state.labelText, updatedText)
            XCTAssertEqual(oldState?.labelText, initialText)
            XCTAssertFalse(animated)
        }
        testVC.state.update {
            $0.labelText = updatedText
        }
        XCTAssertEqual(testVC.label.text, updatedText)
        testVC.state.update {
            $0.labelText = updatedText
        }

        testVC.renderClosure = { (state, oldState, animated) in
            XCTFail("Render update should be skipped when state == oldState")
        }
        testVC.state.update {
            $0.labelText = updatedText
        }
    }

    /// This doesn't seem to trigger the extension that I'd expect
    func testSwiftUI() throws {
        let parentVC = UIViewController()
        let testVC = UIHostingController(rootView: TestViewController.ViewState())
        parentVC.addChild(testVC)
        testVC.didMove(toParent: parentVC)
        let testViewVC = UIHostingController(rootView: TestView.ViewState())
        parentVC.addChild(testViewVC)
        testViewVC.didMove(toParent: parentVC)

        let window = UIWindow()
        window.rootViewController = parentVC
        window.makeKeyAndVisible()

        let _ = parentVC.view
    }
}
