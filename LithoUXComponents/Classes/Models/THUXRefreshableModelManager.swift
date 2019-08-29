//
//  THUXRefreshableModelManager.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/11/18.
//

import UIKit
import ReactiveSwift
import FunNet

public protocol Refreshable {
    func refresh()
}

public protocol Pageable {
    func nextPage()
    func fetchPage(_ page: Int)
}

open class THUXRefreshableNetworkCallManager: Refreshable {
    open var call: ReactiveNetCall?
    
    public init(_ call: ReactiveNetCall) {
        self.call = call
    }
    
    open func refresh() {
        call?.fire()
    }
    
}

open class THUXPageableModelManager: THUXRefreshableNetworkCallManager, Pageable {
    public let pageProperty = MutableProperty<Int>(0)
    
    open func viewDidLoad() {
        pageProperty.signal.observeValues { page in
            if let call = self.call {
                call.endpoint.getParams.updateValue(page, forKey: "page")
            }
            self.call?.fire()
        }
    }
    
    open override func refresh() {
        pageProperty.value = 0
    }
    
    open func nextPage() {
        pageProperty.value = pageProperty.value + 1
    }
    
    open func fetchPage(_ page: Int) {
        pageProperty.value = page
    }
    
}
