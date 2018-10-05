import XCTest
@testable import Argonaut

class TestProfile:XCTestCase {
    private var session:Session!
    
    override func setUp() {
        Factory.storage = MockStorage.self
        session = Session()
        (session.storage as! MockStorage).onSaveProfile = nil
        (session.storage as! MockStorage).onSaveProject = nil
    }
    
    func testCacheProfile() {
        let profile = Profile()
        session.profile = profile
        XCTAssertTrue(profile === session.getProfile())
    }
    
    func testCreateOnFirstTime() {
        let expect = expectation(description:String())
        let storage = session.storage as! MockStorage
        storage.error = NSError()
        storage.onSaveProfile = { expect.fulfill() }
        let _ = session.getProfile()
        waitForExpectations(timeout:1)
    }
    
    func testSaveProfile() {
        let expect = expectation(description:String())
        let storage = session.storage as! MockStorage
        let _ = session.getProfile()
        storage.onSaveProfile = { expect.fulfill() }
        session.save()
        waitForExpectations(timeout:1)
    }
}
