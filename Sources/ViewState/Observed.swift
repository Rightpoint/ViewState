
/// You can use this to annotate your `state` in a `UIView` or `UIViewController`
/// that conforms to `HasViewState` to automatically render when the state is updated.
///
/// For example:
/// ```
/// @Observed
/// var state: ViewState
/// ```
///
/// - note: Unfortunately referencing the enclosing self in property wrapper
/// is still [not a public API][1] in Swift, so this might break at any moment.
///
///
/// If this is a concern, you can instead manually call `renderIfNeeded` in a `didSet`:
/// ```
/// var state = ViewState() {
///     didSet {
///         renderIfNeeded(state: state, oldState: oldValue)
///     }
/// }
/// ```
///
/// [1]: https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#referencing-the-enclosing-self-in-a-wrapper-type
@propertyWrapper
public struct Observed<Value: ViewStateProtocol> {

    public init() {
        wrappedValue = Value()
    }

    public var wrappedValue: Value

    public static subscript<Instance: HasViewState>(
        _enclosingInstance instance: Instance,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Instance, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<Instance, Self>
    ) -> Value where Instance.ViewState == Value {
        get { instance[keyPath: storageKeyPath].wrappedValue }
        set {
            let oldValue = instance[keyPath: storageKeyPath].wrappedValue
            instance[keyPath: storageKeyPath].wrappedValue = newValue
            instance.renderIfNeeded(state: newValue, oldState: oldValue)
        }
    }
}
