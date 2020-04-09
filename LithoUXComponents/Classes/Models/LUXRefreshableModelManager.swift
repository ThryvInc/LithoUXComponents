//
//  LUXRefreshableModelManager.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/11/18.
//

import LUX
import FunNet

open class LUXRefreshableNetworkCallManager: Refreshable {
    open var call: ReactiveNetCall?
    
    public init(_ call: ReactiveNetCall) {
        self.call = call
    }
    
    open func refresh() {
        call?.fire()
    }
    
}
