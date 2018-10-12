import XCTest
import MapKit
@testable import Argonaut

class TestShooter:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        Factory.storage = MockStorage.self
        map = Map()
        map.shooterType = MockShooter.self
        map.path = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("test")
        map.zooms = [Zoom(2)]
        map.builder = Builder()
    }
    
    override func tearDown() {
        MockShooter.image = nil
        try? FileManager.default.removeItem(at:map.path)
        map = nil
    }
    
    func testHappyPath() {
        let expect = expectation(description:String())
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude:0, longitude:0)
        MockShooter.image = makeImage(width:1, height:1)
        map.onSuccess = { url in expect.fulfill() }
        map.makeMap(points:[annotation], route:nil)
        waitForExpectations(timeout:2)
    }
    
    func testMultipleZoom() {
        let expect = expectation(description:String())
        map.zooms = [Zoom(2), Zoom(3)]
        MockShooter.image = makeImage(width:256, height:256)
        map.onSuccess = { _ in
            XCTAssertTrue(FileManager.default.fileExists(atPath:
                self.map.builder.url.appendingPathComponent("2_0_0.png").path))
            XCTAssertTrue(FileManager.default.fileExists(atPath:
                self.map.builder.url.appendingPathComponent("3_0_0.png").path))
            expect.fulfill()
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude:0, longitude:0)
        map.makeMap(points:[annotation], route:nil)
        waitForExpectations(timeout:3)
    }
    
    func testUpdateProgress() {
        let expect = expectation(description:String())
        MockShooter.image = makeImage(width:1, height:1)
        map.onProgress = { progress in
            XCTAssertEqual(Thread.main, Thread.current)
            XCTAssertGreaterThanOrEqual(progress, 0)
            XCTAssertLessThanOrEqual(progress, 1)
            if progress == 1 {
                expect.fulfill()
            }
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude:0, longitude:0)
        DispatchQueue.global(qos:.background).async { self.map.makeMap(points:[annotation], route:nil) }
        waitForExpectations(timeout:3)
    }
    
    private func makeImage(width:Double, height:Double) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width:width, height:height))
        let image = UIImage(cgImage:UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
        return image
    }
}
