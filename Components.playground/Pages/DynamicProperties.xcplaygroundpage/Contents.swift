/*:
 # DynamicProperties

 - A wrapper around associated objects
 - Provides a simpler way to add dynamic properties to objects
 - Handy for adding stored properties in extensions (especially useful in UIKit for example)
 */
private class Object: NSObject { }
extension Object {
    var value: Int? {
        get { return self[dynamic: #function] }
        set { self[dynamic: #function] = newValue }
    }
}

class DynamicPropertiesTests: XCTestCase {
    func testDynamicProperties() {
        let (a, b) = (Object(), Object())

        XCTAssertNil(a.value)
        XCTAssertNil(b.value)

        a.value = 1
        b.value = 2

        XCTAssertEqual(a.value, 1)
        XCTAssertEqual(b.value, 2)
    }
}

DynamicPropertiesTests.run()
