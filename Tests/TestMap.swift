import XCTest
import MapKit
@testable import Argonaut

class TestMap:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        map = Map()
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at:map.path)
    }
    
    func testCreateMap() {
        let expect = expectation(description:String())
        map.success = { _ in
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        }
        DispatchQueue.global(qos:.background).async { self.map.makeMap(rect:MKMapRect()) }
        waitForExpectations(timeout:1)
    }
    
    func testCreteUrl() {
        let url = map.makeUrl()
        XCTAssertTrue(FileManager.default.fileExists(atPath:url.path))
        XCTAssertTrue(url.path.contains(map.path.path))
    }
}
