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
            MockShooter.image = UIImage()
            self.map.retry()
        }
        map.onSuccess = { project in
            XCTAssertFalse(id.isEmpty)
            XCTAssertEqual(id, project.id)
            expect.fulfill()
        }
        map.makeMap(points:[MKPointAnnotation()], route:nil)
        waitForExpectations(timeout:2)
    }
}
