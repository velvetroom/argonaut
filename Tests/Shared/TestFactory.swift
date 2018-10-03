import XCTest
@testable import Argonaut

class TestFactory:XCTestCase {
    override func setUp() {
        Factory.storage = MockStorage.self
    }
    
    func testOnlyOneSession() {
        XCTAssertTrue(Factory.makeSession() === Factory.makeSession())
    }
}
