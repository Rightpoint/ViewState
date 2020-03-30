# ViewState

[![Swift 5.2](https://img.shields.io/badge/Swift-5.2-orange.svg?style=flat)](https://swift.org)
[![CircleCI](https://img.shields.io/circleci/project/github/Rightpoint/ViewState/master.svg)](https://circleci.com/gh/Rightpoint/ViewState)

Small library for lightweight `UIView` and `UIViewController` state management on iOS.

# Installation

### Requirements

* Xcode 11.4
* Swift 5.2
* iOS 12

### Swift Package Manager

Installation supported by Swift Package Manager in Xcode 11 or higher:

```
https://github.com/Rightpoint/ViewState.git
```

# Usage

```swift
import ViewState

final class ViewController: UIViewController {
    struct ViewState: ViewStateProtocol {
        var labelText: String = ""
        var labelColor: UIColor = .black
    }
    
    @Observed
    var state: ViewState
    
    private let label = UILabel()
}

extension ViewController: HasViewState {
    func render(state: ViewState, oldState: ViewState?, animated: Bool) {
        label.text = state.labelText
        label.textColor = state.labelColor
    }
}
```

### `ViewState`

For any `UIView` or `UIViewController` subclass, make a nested `struct` called `ViewState` and conform it to `ViewStateProtocol`. It must support an empty initializer, so provide some sane default values. All properties must be `Equatable`.

```swift
final class ViewController: UIViewController {
    struct ViewState: ViewStateProtocol {
        var labelText: String = ""
        var labelColor: UIColor = .black
    }
```

To keep things minimal, only add properties here that are intended to be dynamic.

### `HasViewState`

Then conform the parent type to `HasViewState`. The `render` function should be the only place that updates the dynamic values of your subviews.

```swift
final class ViewController: UIViewController {
    @Observed
    var state: ViewState
}

extension ViewController: HasViewState {
    func render(state: ViewState, oldState: ViewState?, animated: Bool) {
        label.text = state.labelText
        label.textColor = state.labelColor
    }
}
```

### `@Observed`

You can use `@Observed` to annotate your `state` in a `UIView` or `UIViewController`
that conforms to `HasViewState` to automatically `render` when the `state` is updated.

For example:

```swift
@Observed
var state: ViewState
```

Unfortunately referencing the enclosing self in property wrapper
is still [not a public API][SE-0258] in Swift, so this might break in the future. If this is a concern, you can instead manually call `renderIfNeeded` in a `didSet`:

```swift
var state = ViewState() {
    didSet {
        renderIfNeeded(state: state, oldState: oldValue)
    }
}
```

[SE-0258]: https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#referencing-the-enclosing-self-in-a-wrapper-type

### SwiftUI

To add easy SwiftUI support to your views, simply conform your `ViewState` to `UIViewControllerRepresentable` or `UIViewRepresentable`. 

```swift
@available(iOS 13.0, *)
extension ViewController.ViewState: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
}
```

The main caveat here is that your `UIView` or `UIViewController` subclasses cannot have a non-empty designated initializer or you'll get a crash at runtime.

### Xcode Previews

When your ViewStates are bridged to SwiftUI, it makes it easy to iterate by utilitizing [Xcode Previews](https://nshipster.com/swiftui-previews/).

```swift
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
```

If you have a custom non-empty designated initializer, you might want to use something like [`UIViewControllerPreview`](https://gist.github.com/mattt/ff6b58af8576c798485b449269d43607) in your project instead of conforming to `UIViewControllerRepresentable`.

# Contributing

Issues and pull requests are welcome! Please ensure that you have the latest [SwiftLint](https://github.com/realm/SwiftLint) installed before committing and that there are no style warnings generated when building.

Contributors are expected to abide by the [Contributor Covenant Code of Conduct](https://github.com/Rightpoint/ViewState/blob/master/CONTRIBUTING.md).

# Author

Chris Ballinger: [cballinger@rightpoint.com](mailto:cballinger@rightpoint.com)

# License

ViewState is available under the MIT license. See the LICENSE file for more info.
