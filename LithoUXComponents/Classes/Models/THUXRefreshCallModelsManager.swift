//
//  THUXRefreshCallModelsManager.swift
//  FunNet
//
//  Created by Elliot Schrock on 10/12/19.
//

import ReactiveSwift
import FunNet

open class THUXRefreshCallModelsManager<T>: THUXRefreshableNetworkCallManager where T: Decodable {
    public let modelsSignal: Signal<[T], Never>
    public init(_ call: ReactiveNetCall, _ modelArraySignal: Signal<[T], Never>) {
        modelsSignal = modelArraySignal
        super.init(call)
    }
}
