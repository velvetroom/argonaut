import XCTest
import MapKit
@testable import Argonaut

class TestShots:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        map = Map()
    }
    
    func testCreate1() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:0, width:1024, height:1024))
        XCTAssertEqual(10, shots[0].zoom.level)
        XCTAssertEqual(0, shots[0].tileX)
        XCTAssertEqual(0, shots[0].tileY)
        XCTAssertEqual(0, shots[0].options().mapRect.minX)
        XCTAssertEqual(0, shots[0].options().mapRect.minY)
        XCTAssertEqual(1024, shots[0].options().mapRect.maxX)
        XCTAssertEqual(1024, shots[0].options().mapRect.maxY)
    }
    
    func testCreate2() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:0, width:20480, height:1024))
        XCTAssertEqual(10, shots[1].zoom.level)
        XCTAssertEqual(10, shots[1].tileX)
        XCTAssertEqual(0, shots[1].tileY)
        XCTAssertEqual(10240, shots[1].options().mapRect.minX)
        XCTAssertEqual(0, shots[1].options().mapRect.minY)
    }
    
    func testCreate4() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:0, width:20480, height:20480))
        XCTAssertEqual(10, shots[3].zoom.level)
        XCTAssertEqual(10, shots[3].tileX)
        XCTAssertEqual(10, shots[3].tileY)
        XCTAssertEqual(10240, shots[3].options().mapRect.minX)
        XCTAssertEqual(10240, shots[3].options().mapRect.minY)
    }
    
    func testCreateDisplacedHorizontal() {
        let shots = map.makeShots(rect:MKMapRect(x:1025, y:0, width:1024, height:1024))
        XCTAssertEqual(10, shots[0].zoom.level)
        XCTAssertEqual(1, shots[0].tileX)
        XCTAssertEqual(0, shots[0].tileY)
        XCTAssertEqual(1024, shots[0].options().mapRect.minX)
        XCTAssertEqual(0, shots[0].options().mapRect.minY)
    }
    
    func testCreateDisplacedVertical() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:1025, width:1024, height:1024))
        XCTAssertEqual(10, shots[0].zoom.level)
        XCTAssertEqual(0, shots[0].tileX)
        XCTAssertEqual(1, shots[0].tileY)
        XCTAssertEqual(0, shots[0].options().mapRect.minX)
        XCTAssertEqual(1024, shots[0].options().mapRect.minY)
    }
    
    func testCreateSmall() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:0, width:50, height:50))
        XCTAssertEqual(10, shots[0].zoom.level)
        XCTAssertEqual(0, shots[0].tileX)
        XCTAssertEqual(0, shots[0].tileY)
        XCTAssertEqual(0, shots[0].options().mapRect.minX)
        XCTAssertEqual(0, shots[0].options().mapRect.minY)
    }
    
    func testCreateBig() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:0, width:10241, height:10241))
        XCTAssertEqual(10, shots[3].zoom.level)
        XCTAssertEqual(10, shots[3].tileX)
        XCTAssertEqual(10, shots[3].tileY)
        XCTAssertEqual(10240, shots[3].options().mapRect.minX)
        XCTAssertEqual(10240, shots[3].options().mapRect.minY)
    }
}
