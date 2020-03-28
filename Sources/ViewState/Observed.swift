
/// Unfortunately referencing the enclosing self in property wrapper
/// is still not a public API in Swift, so this might break at any moment.
/// https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#referencing-the-enclosing-self-in-a-wrapper-type
///
/// Instead you can manually call `renderIfNeeded` in a `willSet`
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
            instance.renderIfNeeded(state: newValue, oldState: oldValue)
            instance[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }
}
