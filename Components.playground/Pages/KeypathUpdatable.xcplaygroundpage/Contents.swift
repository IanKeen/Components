/*:
 # KeypathUpdatable

 - A simpler alternative to lenses
 - Outside of the models file all properties still appear as immutable
 */

// User.swift
private struct User {
    private(set) var name: String
    private(set) var pet: Pet
}
extension User: KeypathUpdatable { }

// Pet.swift
private struct Pet {
    private(set) var name: String
}
extension Pet: KeypathUpdatable { }

class KeypathUpdatableTests: XCTestCase {
    func testUpdates() {
        let user = User(name: "John", pet: Pet(name: "Fido"))
        XCTAssertEqual(user.name, "John")
        XCTAssertEqual(user.pet.name, "Fido")

        let newName = user.update(\.name, to: "Jane")
        XCTAssertEqual(newName.name, "Jane")
        XCTAssertEqual(newName.pet.name, "Fido")

        let newPetName = newName.update(\.pet.name, to: "Tabby")
        XCTAssertEqual(newPetName.name, "Jane")
        XCTAssertEqual(newPetName.pet.name, "Tabby")
    }
}

KeypathUpdatableTests.run()
