import XCTest
import MapKit
@testable import Argonaut

class TestShooter:XCTestCase {
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
    
    func testHappyPath() {
        let expect = expectation(description:String())
        MockShooter.image = makeImage(width:1, height:1)
        map.onSuccess = { url in expect.fulfill() }
        map.makeMap(rect:MKMapRect(x:0, y:0, width:1, height:1))
        waitForExpectations(timeout:1)
    }
    
    private func makeImage(width:Double, height:Double) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width:width, height:height))
        let image = UIImage(cgImage:UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
        return image
    }
}
