//
//  ReactiveModelFunctions.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/8/19.
//

import ReactiveSwift
import LUX

public func modelSignal<T>(from dataSignal: Signal<Data?, Never>) -> Signal<T, Never> where T: Decodable {
    return dataSignal.skipNil().filterMap({ try? LUXJsonProvider.jsonDecoder.decode(T.self, from: $0) })
}

public func unwrappedModelSignal<T, U>(from dataSignal: Signal<Data?, Never>, _ unwrapper: @escaping (T) -> U?) -> Signal<U, Never> where T: Decodable {
    return modelSignal(from: dataSignal).map(unwrapper).skipNil()
}

public func optModelSignal<T>(from dataSignal: Signal<Data?, Never>?) -> Signal<T, Never>? where T: Decodable {
    return dataSignal?.skipNil().filterMap({ try? LUXJsonProvider.jsonDecoder.decode(T.self, from: $0) })
}

public func unwrappedModelSignal<T, U>(from dataSignal: Signal<Data?, Never>?, _ unwrapper: @escaping (T) -> U?) -> Signal<U, Never>? where T: Decodable {
    return optModelSignal(from: dataSignal)?.map(unwrapper).skipNil()
}
