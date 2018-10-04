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
        map.zooms = [Zoom(level:2)]
        let _ = map.session.getProfile()
        (map.session.storage as! MockStorage).onSaveProfile = nil
        (map.session.storage as! MockStorage).onSaveProject = nil
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
        map.makeMap(points:[MKPointAnnotation()], route:nil)
        waitForExpectations(timeout:1)
    }
    
    func testMultipleZoom() {
        let expect = expectation(description:String())
        map.zooms = [Zoom(level:2), Zoom(level:3)]
        MockShooter.image = makeImage(width:256, height:256)
        map.onSuccess = { project in
            let url = self.map.path.appendingPathComponent(project.id)
            XCTAssertTrue(FileManager.default.fileExists(atPath:url.appendingPathComponent("2_0_0.png").path))
            XCTAssertTrue(FileManager.default.fileExists(atPath:url.appendingPathComponent("3_0_0.png").path))
            expect.fulfill()
        }
        map.makeMap(points:[MKPointAnnotation()], route:nil)
        waitForExpectations(timeout:2)
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
        DispatchQueue.global(qos:.background).async { self.map.makeMap(points:[MKPointAnnotation()], route:nil) }
        waitForExpectations(timeout:2)
    }
    
    private func makeImage(width:Double, height:Double) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width:width, height:height))
        let image = UIImage(cgImage:UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
        return image
    }
}
