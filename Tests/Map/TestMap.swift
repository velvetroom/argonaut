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
        MockShooter.error = nil
        (map.session.storage as! MockStorage).onSaveProfile = nil
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
        let rect = map.makeRect(points:[])
        XCTAssertEqual(0, rect.minX)
        XCTAssertEqual(0, rect.minY)
        XCTAssertEqual(0, rect.maxX)
        XCTAssertEqual(0, rect.maxY)
        XCTAssertEqual(0, rect.width)
        XCTAssertEqual(0, rect.height)
    }
    
    func testMakeRectOnePoint() {
        let rect = map.makeRect(points:[MKPlacemark(
            coordinate:CLLocationCoordinate2D(latitude:51.487404, longitude:-0.127049), addressDictionary:nil)])
        XCTAssertEqual(134048427.99486294, rect.minX)
        XCTAssertEqual(89165710.89099653, rect.minY)
        XCTAssertEqual(149130.8088888675, rect.width)
        XCTAssertEqual(239496.25155678391, rect.height)
    }
    
    func testMakeRectTwoPoints() {
        let rect = map.makeRect(points:[
        MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:51.487404, longitude:-0.127049), addressDictionary:nil),
        MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:51.482393, longitude:-0.121620), addressDictionary:nil)])
        
        XCTAssertEqual(134048427.99486294, rect.minX)
        XCTAssertEqual(89165710.89099653, rect.minY)
        XCTAssertEqual(134201606.9595591, rect.maxX)
        XCTAssertEqual(89411194.25819035, rect.maxY)
        XCTAssertEqual(153178.964696154, rect.width)
        XCTAssertEqual(245483.3671938181, rect.height)
    }
    
    func testMakeRectTwoPointsInversed() {
        let rect = map.makeRect(points:[
        MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:51.482393, longitude:-0.121620), addressDictionary:nil),
        MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:51.487404, longitude:-0.127049), addressDictionary:nil)])
        
        XCTAssertEqual(134048427.99486294, rect.minX)
        XCTAssertEqual(89165710.89099653, rect.minY)
        XCTAssertEqual(134201606.9595591, rect.maxX)
        XCTAssertEqual(89411194.25819035, rect.maxY)
        XCTAssertEqual(153178.964696154, rect.width)
        XCTAssertEqual(245483.3671938181, rect.height)
    }
    
    func testMakeRectCrossing() {
        let rect = map.makeRect(points:[
            MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:0.001, longitude:-0.001), addressDictionary:nil),
            MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:-0.001, longitude:0.001), addressDictionary:nil)])
        XCTAssertEqual(134142416.94151111, rect.minX)
        XCTAssertEqual(134142416.90250745, rect.minY)
        XCTAssertEqual(134293039.0584889, rect.maxX)
        XCTAssertEqual(134293039.09749255, rect.maxY)
        XCTAssertEqual(150622.11697779596, rect.width)
        XCTAssertEqual(150622.1949850917, rect.height)
    }
    
    func testCreateProject() {
        let origin = CLLocationCoordinate2D(latitude:51.482393, longitude:-0.121620)
        let destination = CLLocationCoordinate2D(latitude:51.487404, longitude:-0.127049)
        let route = MKRoute()
        map.builder = Builder()
        map.makeProject(points:[MKPlacemark(coordinate:origin, addressDictionary:nil),
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
