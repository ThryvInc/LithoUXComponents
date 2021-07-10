//
//  LUXPageableModelManager.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/6/19.
//

import FunNet
import Slippers
import LUX

open class LUXCallPager: Pager, CallManager {
    open var call: Fireable?
    
    public init(pageKeyName: String = "page", countKeyName: String = "count", defaultCount: Int = 20, firstPageValue: Int = 0, _ call: Fireable?) {
        self.call = call
        super.init(firstPageValue: firstPageValue, onPageUpdate: nil)
        self.onPageUpdate = { [unowned self] page in
            if let call = self.call as? ReactiveNetCall {
                call.endpoint.getParams.updateValue(page, forKey: pageKeyName)
                call.endpoint.getParams.updateValue(defaultCount, forKey: countKeyName)
            }
            self.call?.fire()
        }
    }
}
