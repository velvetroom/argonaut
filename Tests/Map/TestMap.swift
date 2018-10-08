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
        waitForExpectations(timeout:1)
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
        DispatchQueue.global(qos:.background).async { self.map.makeMap(points:[MKPointAnnotation()], route:nil) }
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
        XCTAssertEqual(134122993.39930739, rect.minX)
        XCTAssertEqual(89285590.33216065, rect.minY)
        XCTAssertEqual(1, rect.width)
        XCTAssertEqual(1, rect.height)
    }
    
    func testMakeRectTwoPoints() {
        let rect = map.makeRect(points:[
        MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:51.487404, longitude:-0.127049), addressDictionary:nil),
        MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:51.482393, longitude:-0.121620), addressDictionary:nil)])
        
        XCTAssertEqual(134122993.39930739, rect.minX)
        XCTAssertEqual(89285590.33216065, rect.minY)
        XCTAssertEqual(134127041.55511466, rect.maxX)
        XCTAssertEqual(89291590.56837434, rect.maxY)
        XCTAssertEqual(4048.1558072715998, rect.width)
        XCTAssertEqual(6000.236213684082, rect.height)
    }
    
    func testMakeRectTwoPointsInversed() {
        let rect = map.makeRect(points:[
        MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:51.482393, longitude:-0.121620), addressDictionary:nil),
        MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:51.487404, longitude:-0.127049), addressDictionary:nil)])
        
        XCTAssertEqual(134122993.39930739, rect.minX)
        XCTAssertEqual(89285590.33216065, rect.minY)
        XCTAssertEqual(134127041.55511466, rect.maxX)
        XCTAssertEqual(89291590.56837434, rect.maxY)
        XCTAssertEqual(4048.1558072715998, rect.width)
        XCTAssertEqual(6000.236213684082, rect.height)
    }
    
    func testMakeRectCrossing() {
        let rect = map.makeRect(points:[
            MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:0.001, longitude:-0.001), addressDictionary:nil),
            MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:-0.001, longitude:0.001), addressDictionary:nil)])
        
        XCTAssertEqual(134216982.34595555, rect.minX)
        XCTAssertEqual(134216982.34595552, rect.minY)
        XCTAssertEqual(134218473.65404445, rect.maxX)
        XCTAssertEqual(134218473.65404448, rect.maxY)
        XCTAssertEqual(1491.3080888986588, rect.width)
        XCTAssertEqual(1491.3080889582634, rect.height)
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
