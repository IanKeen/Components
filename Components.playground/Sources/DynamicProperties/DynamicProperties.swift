import ObjectiveC

public protocol DynamicProperties: AnyObject {
    subscript<T>(dynamic key: String) -> T? { get set }
}

private extension String {
    var unsafePointer: UnsafeRawPointer {
        return UnsafeRawPointer(bitPattern: hashValue)!
    }
}
extension DynamicProperties {
    public subscript<T>(dynamic key: String) -> T? {
        get { return objc_getAssociatedObject(self, key.unsafePointer) as? T }
        set { objc_setAssociatedObject(self, key.unsafePointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public subscript<T>(dynamic key: String, or `default`: @autoclosure () -> T) -> T {
        if let existing: T = self[dynamic: key] {
            return existing
        } else {
            let value = `default`()
            self[dynamic: key] = value
            return value
        }
    }
}

extension NSObject: DynamicProperties { }
