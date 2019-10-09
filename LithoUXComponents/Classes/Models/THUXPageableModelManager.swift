//
//  THUXPageableModelManager.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/6/19.
//

import ReactiveSwift

public protocol Pageable {
    func nextPage()
    func fetchPage(_ page: Int)
}

open class THUXPageableModelManager: THUXRefreshableNetworkCallManager, Pageable {
    public let pageProperty: MutableProperty<Int>
    private let firstPageValue: Int
    
    public init(_ call: ReactiveNetCall, firstPageValue: Int = 0) {
        self.firstPageValue = firstPageValue
        self.pageProperty = MutableProperty(firstPageValue)
        super.init(call)
    }
    
    open func viewDidLoad() {
        pageProperty.signal.observeValues { page in
            if let call = self.call {
                call.endpoint.getParams.updateValue(page, forKey: "page")
            }
            self.call?.fire()
        }
    }
    
    open override func refresh() {
        pageProperty.value = firstPageValue
    }
    
    open func nextPage() {
        pageProperty.value = pageProperty.value + 1
    }
    
    open func fetchPage(_ page: Int) {
        pageProperty.value = page
    }
}
