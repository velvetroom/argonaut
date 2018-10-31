import XCTest
import MapKit
@testable import Argonaut

class TestMap:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        Factory.storage = MockStorage.self
        map = Map()
        map.path = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("test")
        map.shooterType = MockShooter.self
        map.zooms = [Zoom(2)]
    }
    
    override func tearDown() {
        Factory.session = nil
        MockShooter.error = nil
        try? FileManager.default.removeItem(at:map.path)
    }
    
    func testSessionIsMonostate() {
        XCTAssertTrue(map.session === Factory.makeSession())
    }
    
    func testRefreshBuilder() {
        let expect = expectation(description:String())
        MockShooter.error = Exception.mapUnknownError
        map.onFail = { error in
            self.map.builder.project.id = "hello world"
            MockShooter.error = nil
            self.map.makeMap(points:[], route:nil)
        }
        map.onSuccess = { project in
            XCTAssertNotEqual("hello world", self.map.builder.project.id)
            expect.fulfill()
        }
        map.makeMap(points:[], route:nil)
        waitForExpectations(timeout:2)
    }
    
    func testCreateMap() {
        let expect = expectation(description:String())
        map.onSuccess = { project in
            let url = self.map.path.appendingPathComponent(project.id)
            XCTAssertEqual(Thread.main, Thread.current)
            XCTAssertTrue(FileManager.default.fileExists(atPath:url.path))
            expect.fulfill()
        }
        DispatchQueue.global(qos:.background).async { self.map.makeMap(points:[], route:nil) }
        waitForExpectations(timeout:1)
    }
    
    func testGetError() {
        let expect = expectation(description:String())
        MockShooter.error = Exception.mapUnknownError
        map.onFail = { error in
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude:0, longitude:0)
        DispatchQueue.global(qos:.background).async { self.map.makeMap(points:[annotation], route:nil) }
        waitForExpectations(timeout:1)
    }
    
    func testCreateUrl() {
        map.builder = Builder()
        map.builder.project.id = "hello world"
        map.makeUrl()
        XCTAssertTrue(FileManager.default.fileExists(atPath:map.builder.url.path))
        XCTAssertTrue(map.builder.url.path.contains(map.path.path))
        XCTAssertTrue(map.builder.url.path.contains(map.builder.project.id))
    }
    
    func testMakeZeroRect() {
        let rect = map.makeRect(coordinates:[])
        XCTAssertEqual(0, rect.minX)
        XCTAssertEqual(0, rect.minY)
        XCTAssertEqual(0, rect.maxX)
        XCTAssertEqual(0, rect.maxY)
        XCTAssertEqual(0, rect.width)
        XCTAssertEqual(0, rect.height)
    }
    
    func testMakeRectOnePoint() {
        let rect = map.makeRect(coordinates:[(CLLocationCoordinate2D(
            latitude:51.487404, longitude:-0.127049))])
        XCTAssertEqual(134122247.74526292, rect.minX)
        XCTAssertEqual(89284392.8402991, rect.minY)
        XCTAssertEqual(1491.30808891356, rect.width)
        XCTAssertEqual(2394.957460165024, rect.height)
    }
    
    func testMakeRectTwoPoints() {
        let rect = map.makeRect(coordinates:[CLLocationCoordinate2D(latitude:51.487404, longitude:-0.127049),
                                             CLLocationCoordinate2D(latitude:51.482393, longitude:-0.121620)])
        
        XCTAssertEqual(134122247.74526292, rect.minX)
        XCTAssertEqual(89284392.8402991, rect.minY)
        XCTAssertEqual(134127787.2091591, rect.maxX)
        XCTAssertEqual(89292787.90239197, rect.maxY)
        XCTAssertEqual(5539.46389618516, rect.width)
        XCTAssertEqual(8395.062092870474, rect.height)
    }
    
    func testMakeRectTwoPointsInversed() {
        let rect = map.makeRect(coordinates:[
            CLLocationCoordinate2D(latitude:51.482393, longitude:-0.121620),
            CLLocationCoordinate2D(latitude:51.487404, longitude:-0.127049)])
        
        XCTAssertEqual(134122247.74526292, rect.minX)
        XCTAssertEqual(89284392.8402991, rect.minY)
        XCTAssertEqual(134127787.2091591, rect.maxX)
        XCTAssertEqual(89292787.90239197, rect.maxY)
        XCTAssertEqual(5539.46389618516, rect.width)
        XCTAssertEqual(8395.062092870474, rect.height)
    }
    
    func testMakeRectCrossing() {
        let rect = map.makeRect(coordinates:[CLLocationCoordinate2D(latitude:0.001, longitude:-0.001),
                                             CLLocationCoordinate2D(latitude:-0.001, longitude:0.001)])
        XCTAssertEqual(134216236.69191112, rect.minX)
        XCTAssertEqual(134216236.6919108, rect.minY)
        XCTAssertEqual(134219219.3080889, rect.maxX)
        XCTAssertEqual(134219219.3080892, rect.maxY)
        XCTAssertEqual(2982.6161777824163, rect.width)
        XCTAssertEqual(2982.616178393364, rect.height)
    }
    
    func testCreateProject() {
        let origin = CLLocationCoordinate2D(latitude:51.482393, longitude:-0.121620)
        let destination = CLLocationCoordinate2D(latitude:51.487404, longitude:-0.127049)
        let route = MKRoute()
        map.builder = Builder()
        let _ = map.makeProject(points:[MKPlacemark(coordinate:origin, addressDictionary:nil),
                                        MKPlacemark(coordinate:destination, addressDictionary:nil)], route:route)
        XCTAssertFalse(map.builder.project.id.isEmpty)
        XCTAssertEqual(51.482393, map.builder.project.origin.point.latitude)
        XCTAssertEqual(-0.121620, map.builder.project.origin.point.longitude)
        XCTAssertEqual(51.487404, map.builder.project.destination.point.latitude)
        XCTAssertEqual(-0.127049, map.builder.project.destination.point.longitude)
    }
    
    func testUpdatesProfile() {
        let expect = expectation(description:String())
        let storage = Factory.makeSession().storage as! MockStorage
        storage.onSaveProfile = { expect.fulfill() }
        map.makeMap(points:[], route:nil)
        waitForExpectations(timeout:1)
    }
}
