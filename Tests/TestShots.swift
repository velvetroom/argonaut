import XCTest
import MapKit
@testable import Argonaut

class TestShots:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        map = Map()
    }
    
    func testCreate1() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:0, width:1, height:1))
        XCTAssertEqual(10, shots[0].zoom.level)
        XCTAssertEqual(0, shots[0].tileX)
        XCTAssertEqual(0, shots[0].tileY)
        XCTAssertEqual(0, shots[0].options().mapRect.minX)
        XCTAssertEqual(0, shots[0].options().mapRect.minY)
        XCTAssertEqual(2621440, shots[0].options().mapRect.maxX)
        XCTAssertEqual(2621440, shots[0].options().mapRect.maxY)
    }
    
    func testCreate2() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:0, width:2621441, height:1))
        XCTAssertEqual(10, shots[1].zoom.level)
        XCTAssertEqual(10, shots[1].tileX)
        XCTAssertEqual(0, shots[1].tileY)
        XCTAssertEqual(2621440, shots[1].options().mapRect.minX)
        XCTAssertEqual(0, shots[1].options().mapRect.minY)
    }
    
    func testCreate4() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:0, width:2621441, height:2621441))
        XCTAssertEqual(10, shots[3].zoom.level)
        XCTAssertEqual(10, shots[3].tileX)
        XCTAssertEqual(10, shots[3].tileY)
        XCTAssertEqual(2621440, shots[3].options().mapRect.minX)
        XCTAssertEqual(2621440, shots[3].options().mapRect.minY)
    }
    
    func testCreateDisplacedHorizontal() {
        let shots = map.makeShots(rect:MKMapRect(x:262145, y:0, width:1, height:1))
        XCTAssertEqual(10, shots[0].zoom.level)
        XCTAssertEqual(1, shots[0].tileX)
        XCTAssertEqual(0, shots[0].tileY)
        XCTAssertEqual(262144, shots[0].options().mapRect.minX)
        XCTAssertEqual(0, shots[0].options().mapRect.minY)
    }
    
    func testCreateDisplacedVertical() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:262145, width:1, height:1))
        XCTAssertEqual(10, shots[0].zoom.level)
        XCTAssertEqual(0, shots[0].tileX)
        XCTAssertEqual(1, shots[0].tileY)
        XCTAssertEqual(0, shots[0].options().mapRect.minX)
        XCTAssertEqual(262144, shots[0].options().mapRect.minY)
    }
}
