import XCTest
import MapKit
@testable import Argonaut

class TestMap:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        map = Map()
    }
    
    override func tearDown() {
//        try! FileManager.default.removeItem(at:map.directory)
    }
    
    func testCreateMap() {
        let expect = expectation(description:String())
        DispatchQueue.global(qos:.background).async {
            self.map.create(rect:MKMapRect(), success: { image in
                XCTAssertEqual(Thread.main, Thread.current)
                expect.fulfill()
            }, fail: { _ in } )
        }
        waitForExpectations(timeout:1)
    }
    
    func testCropImage() {
        UIGraphicsBeginImageContext(CGSize(width:100, height:100))
        UIGraphicsGetCurrentContext()!.setFillColor(UIColor.black.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x:0, y:0, width:100, height:100))
        let image = UIImage(cgImage:UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
        let result = map.crop(image:image, rect:CGRect(x:0, y:0, width:1, height:1))
        XCTAssertEqual(510, image.pngData()!.count)
        XCTAssertEqual(83, map.crop(image:image, rect:CGRect(x:0, y:0, width:1, height:1)).pngData()!.count)
        XCTAssertEqual(83, result.pngData()!.count)
        XCTAssertEqual(1, result.size.width)
        XCTAssertEqual(1, result.size.height)
    }
}
