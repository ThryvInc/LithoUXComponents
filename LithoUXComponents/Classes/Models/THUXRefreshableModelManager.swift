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

open class THUXRefreshableNetworkCallManager: Refreshable {
    open var call: ReactiveNetCall?
    
    public init(_ call: ReactiveNetCall) {
        self.call = call
    }
    
    open func refresh() {
        call?.fire()
    }
    
}
