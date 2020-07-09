//
//  ReactiveModelFunctions.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/8/19.
//

import ReactiveSwift
import Slippers

public func modelSignal<T>(from dataSignal: Signal<Data?, Never>) -> Signal<T, Never> where T: Decodable {
    #if targetEnvironment(simulator)
        return dataSignal.skipNil().compactMap({ JsonProvider.forceDecode(T.self, from: $0) })
    #else
        return dataSignal.skipNil().compactMap({ JsonProvider.decode(T.self, from: $0) })
    #endif
}

public func unwrappedModelSignal<T, U>(from dataSignal: Signal<Data?, Never>, _ unwrapper: @escaping (T) -> U?) -> Signal<U, Never> where T: Decodable {
    return modelSignal(from: dataSignal).map(unwrapper).skipNil()
}

public func optModelSignal<T>(from dataSignal: Signal<Data?, Never>?) -> Signal<T, Never>? where T: Decodable {
    #if targetEnvironment(simulator)
        return dataSignal?.skipNil().compactMap({ JsonProvider.forceDecode(T.self, from: $0) })
    #else
        return dataSignal?.skipNil().compactMap({ JsonProvider.decode(T.self, from: $0) })
    #endif
}

public func unwrappedModelSignal<T, U>(from dataSignal: Signal<Data?, Never>?, _ unwrapper: @escaping (T) -> U?) -> Signal<U, Never>? where T: Decodable {
    return optModelSignal(from: dataSignal)?.map(unwrapper).skipNil()
}
