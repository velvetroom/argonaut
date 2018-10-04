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
    
    func testSessionIsMonostate() {
        XCTAssertTrue(map.session === Factory.makeSession())
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
        MockShooter.error = Exception.mapUnknownError
        let expect = expectation(description:String())
        map.onFail = { error in
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        }
        DispatchQueue.global(qos:.background).async { self.map.makeMap(points:[MKPointAnnotation()], route:nil) }
        waitForExpectations(timeout:1)
    }
    
    func testCreateUrl() {
        let project = Project()
        let url = map.makeUrl(project:project)
        XCTAssertTrue(FileManager.default.fileExists(atPath:url.path))
        XCTAssertTrue(url.path.contains(map.path.path))
        XCTAssertTrue(url.path.contains(project.id))
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
        let project = map.makeProject(points:[MKPlacemark(coordinate:origin, addressDictionary:nil),
                                              MKPlacemark(coordinate:destination, addressDictionary:nil)], route:route)
        XCTAssertEqual(51.482393, project.origin.point.latitude)
        XCTAssertEqual(-0.121620, project.origin.point.longitude)
        XCTAssertEqual(51.487404, project.destination.point.latitude)
        XCTAssertEqual(-0.127049, project.destination.point.longitude)
    }
    
    func testUpdatesProfile() {
        let expect = expectation(description:String())
        let storage = Factory.makeSession().storage as! MockStorage
        storage.onSaveProfile = { expect.fulfill() }
        map.makeMap(points:[], route:nil)
        waitForExpectations(timeout:1)
    }
}
