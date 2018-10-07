import XCTest
@testable import Argonaut

class TestRate:XCTestCase {
    private var session:Session!
    
    override func setUp() {
        Factory.storage = MockStorage.self
        session = Session()
    }
    
    func testNoRateAtFirst() {
        XCTAssertFalse(session.rate())
    }
    
    func testRateIfMoreThan1Project() {
        session.profile().planed = 2
        XCTAssertTrue(session.rate())
        XCTAssertFalse(session.profile().rates.isEmpty)
    }
    
    func testNoRateIfRatedRecently() {
        session.profile().planed = 2
        session.profile().rates = [Date()]
        XCTAssertFalse(session.rate())
    }
    
    func testRateIfRatedMoreThan2MonthsAgo() {
        var components = DateComponents()
        components.month = 4
        let date = Calendar.current.date(byAdding:components, to:Date())!
        session.profile().planed = 2
        session.profile().rates = [date]
        XCTAssertEqual(date, session.profile().rates.last!)
        XCTAssertTrue(session.rate())
        XCTAssertNotEqual(date, session.profile().rates.last!)
    }
}
