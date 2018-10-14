import XCTest
import MapKit
@testable import Argonaut

class TestTimer:XCTestCase {
    private var map:Map!
    private var shooter:MapShooter!
    
    override func setUp() {
        shooter = MapShooter(shot:Shot(tileX:0, tileY:0, zoom:Zoom(2)))
        Factory.storage = MockStorage.self
        map = Map()
        map.shooterType = MockShooter.self
        map.path = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("test")
    }
    
    override func tearDown() {
        Factory.session = nil
        MockShooter.image = nil
        MockShooter.error = nil
        try? FileManager.default.removeItem(at:map.path)
        map = nil
    }
    
    func testFailsIfTimeout() {
        let expect = expectation(description:String())
        shooter.timeout = 0.1
        shooter.make(queue:DispatchQueue.global(qos:.background), success: { _ in }) { _ in
            expect.fulfill()
        }
        waitForExpectations(timeout:1)
    }
    
    func testContinueAfterFail() {
        let expect = expectation(description:String())
        var id = String()
        MockShooter.error = Exception.mapTimeout
        map.onFail = { _ in
            id = self.map.builder.project.id
            MockShooter.error = nil
            MockShooter.image = self.makeImage(width:2, height:2)
            self.map.retry()
        }
        map.onSuccess = { project in
            XCTAssertFalse(id.isEmpty)
            XCTAssertEqual(id, project.id)
            MockShooter.image = nil
            expect.fulfill()
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude:0, longitude:0)
        map.makeMap(points:[annotation], route:nil)
        waitForExpectations(timeout:2)
    }
    
    private func makeImage(width:Double, height:Double) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width:width, height:height))
        let image = UIImage(cgImage:UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
        return image
    }
}
