import XCTest
import LithoUXComponents
import FunNet

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFromSnakeCaseJson() {
        let data = jsonUserString.data(using: .utf8)
        let crissy = try! THUXJsonProvider.defaultJsonDecoder().decode(User.self, from: data!)
        
        XCTAssertNotNil(crissy)
        XCTAssertEqual(crissy.emailAddress, "crissy@lithobyte.co")
    }
    
    func testToSnakeCaseJson(){
//        let data = jsonUserString.data(using: .utf8)
        let crissy = User(emailAddress: "crissy@lithobyte.co")
        
        let data = try! THUXJsonProvider.defaultJsonEncoder().encode(crissy)
        
        let result = String.init(data: data, encoding: .utf8)
        
        XCTAssertEqual(result, jsonUserString)
    }
    
    func testRefreshable() {
        var wasCalled = false
        let netCall = ReactiveNetCall(configuration: ServerConfiguration(host: "", apiRoute: ""), Endpoint())
        netCall.firingFunc = { _ in wasCalled = true }
        
        let refreshable = THUXRefreshableNetworkCallManager(netCall)
        refreshable.refresh()
        
        XCTAssertTrue(wasCalled)
    }
}

let jsonUserString = """
{"email_address":"crissy@lithobyte.co"}
"""
struct User: Codable {
    var emailAddress: String?
}

