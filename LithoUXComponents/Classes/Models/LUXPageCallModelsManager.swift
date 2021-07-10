//
//  LUXPageCallModelsManager.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/6/19.
//

import ReactiveSwift
import FunNet
import Prelude
import LithoOperators

open class LUXPageCallModelsManager<T>: LUXCallPager where T: Decodable {
    public let modelsSignal: Signal<[T], Never>
    private let modelsProperty = MutableProperty<[T]>([T]())
    
    public init(pageKeyName: String = "page",
                countKeyName: String = "count",
                defaultCount: Int = 20,
                firstPageValue: Int = 1,
                _ call: ReactiveNetCall,
                _ modelArraySignal: Signal<[T], Never>) {
        modelsSignal = modelsProperty.signal
        super.init(pageKeyName: pageKeyName, countKeyName: countKeyName, defaultCount: defaultCount, firstPageValue: firstPageValue, call)
        
        modelArraySignal |> subscribeForPaging
    }
    
    public init(pageKeyName: String = "page",
                countKeyName: String = "count",
                defaultCount: Int = 20,
                firstPageValue: Int = 1,
                _ call: ReactiveNetCall) {
        modelsSignal = modelsProperty.signal
        super.init(pageKeyName: pageKeyName, countKeyName: countKeyName, defaultCount: defaultCount, firstPageValue: firstPageValue, call)
        
        optModelSignal(from: call.responder?.dataSignal) ?> subscribeForPaging
    }
    
    open func subscribeForPaging(_ modelsSignal: Signal<[T], Never>) {
        modelsSignal.observeValues({ [weak self] (array) in
            if self?.page == self?.firstPageValue {
                self?.modelsProperty.value = array
            } else {
                if var allModels = self?.modelsProperty.value {
                    allModels.append(contentsOf: array)
                    self?.modelsProperty.value = allModels
                }
            }
        })
    }
}
