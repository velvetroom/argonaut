import XCTest
@testable import Argonaut

class TestClean:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        Factory.storage = MockStorage.self
        map = Map()
        map.path = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("test")
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at:map.path)
    }
    
    func testCleanUnusedFolders() {
        let expect = expectation(description:String())
        let pathA = map.path.appendingPathComponent("A")
        let pathB = map.path.appendingPathComponent("B")
        let pathC = map.path.appendingPathComponent("C")
        let pathData = pathA.appendingPathComponent("data.json")
        try! FileManager.default.createDirectory(atPath:pathA.path, withIntermediateDirectories:true)
        try! FileManager.default.createDirectory(atPath:pathB.path, withIntermediateDirectories:true)
        try! FileManager.default.createDirectory(atPath:pathC.path, withIntermediateDirectories:true)
        try! Data().write(to:pathData)
        XCTAssertTrue(FileManager.default.fileExists(atPath:pathA.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath:pathB.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath:pathC.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath:pathData.path))
        map.session.profile().projects = ["B"]
        map.onClean = {
            XCTAssertEqual(Thread.main, Thread.current)
            XCTAssertFalse(FileManager.default.fileExists(atPath:pathA.path))
            XCTAssertTrue(FileManager.default.fileExists(atPath:pathB.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath:pathC.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath:pathData.path))
            expect.fulfill()
        }
        DispatchQueue.global(qos:.background).async { self.map.cleanDisk() }
        waitForExpectations(timeout:1)
    }
}
