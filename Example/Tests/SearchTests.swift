//
//  SearchTests.swift
//  LithoUXComponents_Tests
//
//  Created by Elliot Schrock on 10/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import ReactiveSwift
@testable import LithoUXComponents

class SearchTests: XCTestCase {

    func testExample() {
        var count = 0
        
        let humansProperty = MutableProperty<[Human]?>(nil)
        let searcher = THUXSearcher<Human> { searchString, human in
            guard let search = searchString else {
                return true
            }
            return (human.name ?? "").contains(search)
        }
        
        let modelsSignal = humansProperty.signal.skipNil()
        
        let listSignal = Signal.merge(modelsSignal, searcher.filteredSignal(from: modelsSignal))
        
        listSignal.observeValues { (humans) in
            count += 1
            switch count {
            case 1:
                XCTAssertEqual(humans.count, 3)
                XCTAssertNil(searcher.searchTextProperty.value)
                break
            case 2:
                XCTAssertEqual(humans.count, 1)
                XCTAssertEqual(searcher.searchTextProperty.value, "N")
                break
            case 3:
                XCTAssertEqual(humans.count, 3)
                XCTAssertEqual(searcher.searchTextProperty.value, "")
                break
            case 4:
                XCTAssertEqual(humans.count, 2)
                XCTAssertEqual(searcher.searchTextProperty.value, "e")
                break
            case 5:
                XCTAssertEqual(humans.count, 2)
                XCTAssertEqual(searcher.searchTextProperty.value, "e")
                break
            case 6:
                XCTAssertEqual(humans.count, 3)
                XCTAssertEqual(searcher.searchTextProperty.value, "e")
                break
            default:
                XCTAssertEqual(count, 0)
                break
            }
        }
        
        let humans = [Human(id: 1, name: "Neo"), Human(id: 2, name: "Morpheus"), Human(id: 3, name: "Trinity")]
        
        humansProperty.value = humans
        
        searcher.updateSearch(text: "N")
        searcher.updateSearch(text: "")
        searcher.updateSearch(text: "e")
        
        humansProperty.value = humans
        
        XCTAssertEqual(count, 6)
    }
}
