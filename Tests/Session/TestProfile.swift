import XCTest
@testable import Argonaut

class TestProfile:XCTestCase {
    private var session:Session!
    
    override func setUp() {
        Factory.storage = MockStorage.self
        session = Session()
    }
    
    func testCache() {
        XCTAssertTrue(session.profile() === session.profile())
    }
    
    func testCreateOnFirstTime() {
        let expect = expectation(description:String())
        let storage = session.storage as! MockStorage
        storage.error = Exception.mapUnknownError
        storage.onSaveProfile = { expect.fulfill() }
        let _ = session.profile()
        waitForExpectations(timeout:1)
    }
    
    func testSave() {
        let expect = expectation(description:String())
        let storage = session.storage as! MockStorage
        let _ = session.profile()
        storage.onSaveProfile = { expect.fulfill() }
        session.save()
        waitForExpectations(timeout:1)
    }
    
    func testLoadWithHQ() {
        let original = Profile()
        original.highQuality = false
        let data = try! JSONEncoder().encode(original)
        let profile = try! JSONDecoder().decode(Profile.self, from:data)
        XCTAssertFalse(profile.highQuality)
    }
    
    func testLoadWithProjects() {
        let original = Profile()
        original.projects = ["hello world"]
        let data = try! JSONEncoder().encode(original)
        let profile = try! JSONDecoder().decode(Profile.self, from:data)
        XCTAssertEqual(1, profile.projects.count)
    }
    
    func testLoadWithRates() {
        let original = Profile()
        original.rates = [Date()]
        let data = try! JSONEncoder().encode(original)
        let profile = try! JSONDecoder().decode(Profile.self, from:data)
        XCTAssertEqual(1, profile.rates.count)
    }
    
    func testLoadWithPlaned() {
        let original = Profile()
        original.planed = 99
        let data = try! JSONEncoder().encode(original)
        let profile = try! JSONDecoder().decode(Profile.self, from:data)
        XCTAssertEqual(99, profile.planed)
    }
}
