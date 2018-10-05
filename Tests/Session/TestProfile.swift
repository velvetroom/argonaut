import XCTest
@testable import Argonaut

class TestProfile:XCTestCase {
    private var session:Session!
    
    override func setUp() {
        Factory.storage = MockStorage.self
        session = Session()
    }
    
    override func tearDown() {
        (session.storage as! MockStorage).onSaveProfile = nil
        (session.storage as! MockStorage).onSaveProject = nil
    }
    
    func testCacheProfile() {
        XCTAssertTrue(session.profile() === session.profile())
    }
    
    func testCreateOnFirstTime() {
        let expect = expectation(description:String())
        let storage = session.storage as! MockStorage
        storage.error = NSError()
        storage.onSaveProfile = { expect.fulfill() }
        let _ = session.profile()
        waitForExpectations(timeout:1)
    }
    
    func testSaveProfile() {
        let expect = expectation(description:String())
        let storage = session.storage as! MockStorage
        let _ = session.profile()
        storage.onSaveProfile = { expect.fulfill() }
        session.save()
        waitForExpectations(timeout:1)
    }
}
