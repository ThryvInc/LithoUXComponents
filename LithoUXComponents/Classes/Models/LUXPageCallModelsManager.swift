//
//  LUXPageCallModelsManager.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/6/19.
//

import ReactiveSwift
import FunNet

open class LUXPageCallModelsManager<T>: LUXPageableModelManager where T: Decodable {
    public let modelsSignal: Signal<[T], Never>
    private let modelsProperty = MutableProperty<[T]>([T]())
    public init(_ call: ReactiveNetCall, _ modelArraySignal: Signal<[T], Never>, firstPageValue: Int = 1) {
        modelsSignal = modelsProperty.signal
        super.init(call, firstPageValue: firstPageValue)
        
        modelArraySignal.observeValues({ [weak self] (array) in
            if self?.pageProperty.value == firstPageValue {
                self?.modelsProperty.value = array
            } else {
                if var allModels = self?.modelsProperty.value {
                    allModels.append(contentsOf: array)
                    self?.modelsProperty.value = allModels
                }
            }
        })
    }
    
    public override init(_ call: ReactiveNetCall, firstPageValue: Int = 1) {
        modelsSignal = modelsProperty.signal
        super.init(call, firstPageValue: firstPageValue)
        
        if let modelsSignal: Signal<[T], Never> = optModelSignal(from: call.responder?.dataSignal) {
            modelsSignal.observeValues({ [weak self] (array) in
                if self?.pageProperty.value == firstPageValue {
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
}
