import XCTest
import MapKit
@testable import Argonaut

class TestMap:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        map = Map()
        map.path = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("test")
        map.shooterType = MockShooter.self
        map.zooms = [Zoom(level:2)]
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
        DispatchQueue.global(qos:.background).async { self.map.makeMap(points:[]) }
        waitForExpectations(timeout:1)
    }
    
    func testGetError() {
        MockShooter.error = Exception.mapUnknownError
        let expect = expectation(description:String())
        map.onFail = { error in
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        }
        DispatchQueue.global(qos:.background).async { self.map.makeMap(points:[MKPointAnnotation()]) }
        waitForExpectations(timeout:1)
    }
    
    func testCreateUrl() {
        let url = map.makeUrl()
        XCTAssertTrue(FileManager.default.fileExists(atPath:url.path))
        XCTAssertTrue(url.path.contains(map.path.path))
    }
    
    func testMakeZeroRect() {
        let rect = map.makeRect(points:[])
        XCTAssertEqual(-1, rect.minX)
        XCTAssertEqual(-1, rect.minY)
        XCTAssertEqual(1, rect.maxX)
        XCTAssertEqual(1, rect.maxY)
        XCTAssertEqual(2, rect.width)
        XCTAssertEqual(2, rect.height)
    }
}
