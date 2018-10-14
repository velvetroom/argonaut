import XCTest
@testable import Argonaut

class TestZoom:XCTestCase {
    func testWithHQ() {
        let zooms = Zoom.zooms(profile:Session().profile())
        XCTAssertEqual(6, zooms.count)
        XCTAssertEqual(15, zooms[0].level)
        XCTAssertEqual(16, zooms[1].level)
        XCTAssertEqual(17, zooms[2].level)
        XCTAssertEqual(18, zooms[3].level)
        XCTAssertEqual(19, zooms[4].level)
        XCTAssertEqual(20, zooms[5].level)
    }
    
    func testWithoutHQ() {
        let session = Session()
        session.profile().highQuality = false
        let zooms = Zoom.zooms(profile:session.profile())
        XCTAssertEqual(3, zooms.count)
        XCTAssertEqual(16, zooms[0].level)
        XCTAssertEqual(17, zooms[1].level)
        XCTAssertEqual(18, zooms[2].level)
    }
}
