import XCTest
@testable import Argonaut

class TestProject:XCTestCase {
    private var session:Session!
    
    override func setUp() {
        Factory.storage = MockStorage.self
        session = Session()
    }
    
    func testLoadProject() {
        let expect = expectation(description:String())
        DispatchQueue.global(qos:.background).async {
            self.session.load(project:String()) { _ in
                XCTAssertEqual(Thread.main, Thread.current)
                expect.fulfill()
            }
        }
        waitForExpectations(timeout:1)
    }
}
