//
//  THUXPageCallModelsManager.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/6/19.
//

import ReactiveSwift

open class THUXPageCallModelsManager<T>: THUXPageableModelManager where T: Decodable {
    public let modelsSignal: Signal<[T], Never>
    private let modelsProperty = MutableProperty<[T]>([T]())
    public override init(_ call: ReactiveNetCall, firstPageValue: Int = 1) {
        modelsSignal = modelsProperty.signal
        super.init(call, firstPageValue: firstPageValue)
        
        if let dataSignal = call.responder?.dataSignal {
            let onePageOfModelsSignal: Signal<[T], Never> = modelSignal(from: dataSignal)
            onePageOfModelsSignal.observeValues({ [weak self] (array) in
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

open class THUXPageUnwrappedModelsManager<S, T>: THUXPageableModelManager where S: Decodable, T: Decodable {
    public let modelsSignal: Signal<[T], Never>
    private let modelsProperty = MutableProperty<[T]>([T]())
    public init(_ call: ReactiveNetCall, unwrapper: @escaping (S) -> [T]?, firstPageValue: Int = 1) {
        let onePageOfModelsSignal = call.responder?
            .dataSignal.skipNil()
            .filterMap({ try? THUXJsonProvider.jsonDecoder.decode(S.self, from: $0) })
            .map(unwrapper).skipNil()
        modelsSignal = modelsProperty.signal
        super.init(call, firstPageValue: firstPageValue)
        onePageOfModelsSignal?.observeValues({ [weak self] (array) in
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
