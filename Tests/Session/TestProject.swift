import XCTest
@testable import Argonaut

class TestProject:XCTestCase {
    private var session:Session!
    
    override func setUp() {
        Factory.storage = MockStorage.self
        session = Session()
    }
    
    override func tearDown() {
        (session.storage as! MockStorage).onSaveProfile = nil
        (session.storage as! MockStorage).onSaveProject = nil
    }
    
    func testAddProject() {
        let expectProfile = expectation(description:String())
        let expectProject = expectation(description:String())
        (session.storage as! MockStorage).onSaveProfile = { expectProfile.fulfill() }
        (session.storage as! MockStorage).onSaveProject = { expectProject.fulfill() }
        let project = Project()
        session.add(project:project)
        XCTAssertEqual(project.id, session.profile().projects[0])
        XCTAssertEqual(1, session.profile().planed)
        waitForExpectations(timeout:1)
    }
    
    func testGetProjects() {
        let expect = expectation(description:String())
        DispatchQueue.global(qos:.background).async {
            self.session.load { (projects:[Project]) in
                XCTAssertEqual(Thread.main, Thread.current)
                expect.fulfill()
            }
        }
        waitForExpectations(timeout:2)
    }
}
