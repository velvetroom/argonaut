import XCTest
import MapKit
@testable import Argonaut

class TestMap:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        map = Map()
        map.shooterType = MockShooter.self
        map.zooms = [Zoom(level:10)]
    }
    
    override func tearDown() {
        MockShooter.image = nil
        MockShooter.error = nil
        try? FileManager.default.removeItem(at:map.path)
    }
    
    func testCreateMap() {
        let expect = expectation(description:String())
        map.onSuccess = { url in
            XCTAssertEqual(Thread.main, Thread.current)
            XCTAssertTrue(FileManager.default.fileExists(atPath:url.path))
            expect.fulfill()
        }
        DispatchQueue.global(qos:.background).async { self.map.makeMap(rect:MKMapRect()) }
        waitForExpectations(timeout:1)
    }
    
    func testGetError() {
        MockShooter.error = Exception.mapUnknownError
        let expect = expectation(description:String())
        map.onFail = { error in
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        }
        DispatchQueue.global(qos:.background).async { self.map.makeMap(rect:MKMapRect(x:0, y:0, width:1, height:1)) }
        waitForExpectations(timeout:1)
    }
    
    func testCreteUrl() {
        let url = map.makeUrl()
        XCTAssertTrue(FileManager.default.fileExists(atPath:url.path))
        XCTAssertTrue(url.path.contains(map.path.path))
    }
}
