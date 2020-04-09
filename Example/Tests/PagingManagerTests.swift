//
//  PagingManagerTests.swift
//  LithoUXComponents_Tests
//
//  Created by Elliot Schrock on 10/8/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import LithoUXComponents
@testable import FunNet

class PagingManagerTests: XCTestCase {
    var call: ReactiveNetCall = ReactiveNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())

    override func setUp() {
        call.firingFunc = { netCall in
            if let page: Int = netCall.endpoint.getParams["page"] as? Int, let responder = netCall.responder {
                switch page {
                    case 1:
                        responder.dataProperty.value = firstPageOfHumans.data(using: .utf8)
                        break
                    case 2:
                        responder.dataProperty.value = secondPageOfHumans.data(using: .utf8)
                        break
                    case 3:
                        responder.dataProperty.value = thirdPageOfHumans.data(using: .utf8)
                        break
                default:
                    XCTFail()
                }
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRefresh() {
        var wasCalled = false
        
        let pageManager = LUXPageCallModelsManager<Human>(call, firstPageValue: 1)
        pageManager.modelsSignal.observeValues { (humans) in
            XCTAssertEqual(humans.count, 1)
            XCTAssertEqual(humans.first?.id, 1)
            wasCalled = true
        }
        pageManager.viewDidLoad()
        pageManager.refresh()
        
        XCTAssert(wasCalled)
    }

    func testNextPage() {
        var callCount = 0
        let pageManager = LUXPageCallModelsManager<Human>(call, firstPageValue: 1)
        pageManager.modelsSignal.observeValues { (humans) in
            callCount += 1
            if callCount == 2 {
                XCTAssertEqual(humans.count, 2)
                XCTAssertEqual(humans.first?.id, 1)
                XCTAssertEqual(humans[1].id, 2)
            }
            if callCount == 3 {
                XCTAssertEqual(humans.count, 3)
                XCTAssertEqual(humans.first?.id, 1)
                XCTAssertEqual(humans[1].id, 2)
                XCTAssertEqual(humans[2].id, 3)
            }
        }
        pageManager.viewDidLoad()
        pageManager.refresh()
        pageManager.nextPage()
        pageManager.nextPage()
        
        XCTAssertEqual(callCount, 3)
    }

    func testRefreshAfterNextPage() {
        var callCount = 0
        let pageManager = LUXPageCallModelsManager<Human>(call, firstPageValue: 1)
        pageManager.modelsSignal.observeValues { (humans) in
            callCount += 1
            if callCount == 2 {
                XCTAssertEqual(humans.count, 2)
                XCTAssertEqual(humans.first?.id, 1)
                XCTAssertEqual(humans[1].id, 2)
            }
            if callCount == 3 {
                XCTAssertEqual(humans.count, 1)
                XCTAssertEqual(humans.first?.id, 1)
            }
        }
        pageManager.viewDidLoad()
        pageManager.refresh()
        pageManager.nextPage()
        pageManager.refresh()
        
        XCTAssertEqual(callCount, 3)
    }
}

struct Human: Codable {
    var id: Int = -1
    var name: String?
}

let firstPageOfHumans = """
[{"id":1}]
"""
let secondPageOfHumans = """
[{"id":2}]
"""
let thirdPageOfHumans = """
[{"id":3}]
"""
