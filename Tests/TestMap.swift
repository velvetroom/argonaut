import XCTest
@testable import Argonaut

class TestMap:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        map = Map()
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at:map.directory)
    }
    
    func testCreateMap() {
        let expect = expectation(description:String())
        let rect = Rect(x:0, y:0, width:1, height:1)
        map.create(rect:rect, success: { location in
            XCTAssertTrue(FileManager.default.fileExists(atPath:location.path))
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        }, fail: { _ in } )
        waitForExpectations(timeout:1)
    }
}
