import XCTest
import MapKit
@testable import Argonaut

class TestShots:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        map = Map()
    }
    
    func testCreate1() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:0, width:1, height:1), zoom:Zoom(level:2))
        XCTAssertEqual(0, shots[0].tileX)
        XCTAssertEqual(0, shots[0].tileY)
        XCTAssertEqual(0, shots[0].options().mapRect.minX)
        XCTAssertEqual(0, shots[0].options().mapRect.minY)
        XCTAssertEqual(671088640, shots[0].options().mapRect.maxX)
        XCTAssertEqual(671088640, shots[0].options().mapRect.maxY)
    }
    
    func testCreate2() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:0, width:671088641, height:1), zoom:Zoom(level:2))
        XCTAssertEqual(10, shots[1].tileX)
        XCTAssertEqual(0, shots[1].tileY)
        XCTAssertEqual(671088640, shots[1].options().mapRect.minX)
        XCTAssertEqual(0, shots[1].options().mapRect.minY)
    }
    
    func testCreate4() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:0, width:671088641, height:671088641), zoom:Zoom(level:2))
        XCTAssertEqual(10, shots[3].tileX)
        XCTAssertEqual(10, shots[3].tileY)
        XCTAssertEqual(671088640, shots[3].options().mapRect.minX)
        XCTAssertEqual(671088640, shots[3].options().mapRect.minY)
    }
    
    func testCreateDisplacedHorizontal() {
        let shots = map.makeShots(rect:MKMapRect(x:335544320, y:0, width:1, height:1), zoom:Zoom(level:2))
        XCTAssertEqual(1, shots[0].tileX)
        XCTAssertEqual(0, shots[0].tileY)
        XCTAssertEqual(67108864, shots[0].options().mapRect.minX)
        XCTAssertEqual(0, shots[0].options().mapRect.minY)
    }
    
    func testCreateDisplacedVertical() {
        let shots = map.makeShots(rect:MKMapRect(x:0, y:335544320, width:1, height:1), zoom:Zoom(level:2))
        XCTAssertEqual(0, shots[0].tileX)
        XCTAssertEqual(1, shots[0].tileY)
        XCTAssertEqual(0, shots[0].options().mapRect.minX)
        XCTAssertEqual(67108864, shots[0].options().mapRect.minY)
    }
    
    func testCenterShot() {
        let shots = map.makeShots(rect:MKMapRect(x:335544319, y:335544319, width:1, height:1), zoom:Zoom(level:2))
        XCTAssertEqual(0, shots[0].tileX)
        XCTAssertEqual(0, shots[0].tileY)
        XCTAssertEqual(0, shots[0].options().mapRect.minX)
        XCTAssertEqual(0, shots[0].options().mapRect.minY)
        XCTAssertEqual(671088640, shots[0].options().mapRect.maxX)
        XCTAssertEqual(671088640, shots[0].options().mapRect.maxY)
    }
}
