import XCTest
import MapKit
@testable import Argonaut

class TestShots:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        map = Map()
    }
    
    func testCreate1Shot() {
        let shots = map.shots(rect:MKMapRect(x:0, y:0, width:1024, height:1024))
        XCTAssertEqual(10, shots[0].tileZ)
        XCTAssertEqual(0, shots[0].tileX)
        XCTAssertEqual(0, shots[0].tileY)
        XCTAssertEqual(0, shots[0].mapX)
        XCTAssertEqual(0, shots[0].mapY)
    }
    
    func testCreate2Shots() {
        let shots = map.shots(rect:MKMapRect(x:0, y:0, width:2048, height:1024))
        XCTAssertEqual(10, shots[1].tileZ)
        XCTAssertEqual(1, shots[1].tileX)
        XCTAssertEqual(0, shots[1].tileY)
        XCTAssertEqual(1024, shots[1].mapX)
        XCTAssertEqual(0, shots[1].mapY)
    }
}
