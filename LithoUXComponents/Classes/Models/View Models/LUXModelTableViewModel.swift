//
//  LUXModelTableViewModel.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 7/23/18.
//

import UIKit
import FlexDataSource
import Prelude
import FunNet
import ReactiveSwift
import LithoOperators

open class LUXModelTableViewModel<T>: LUXModelCallViewModel<T> {
    public var sectionsSignal: Signal<[FlexDataSourceSection], Never>!
    public var modelToItem: ((T) -> FlexDataSourceItem)
    
    public init(modelsSignal: Signal<[T], Never>, modelToItem: @escaping (T) -> FlexDataSourceItem) {
        self.modelToItem = modelToItem
        
        super.init(modelsSignal: modelsSignal)
        
        let toSections = itemsToSection >>> arrayOfSingleObject
        let modelsToItems = modelToItem >||> map
        let transform = modelsToItems >>> toSections
        self.sectionsSignal = self.modelsSignal.map(transform)
    }
}

public func arrayOfSingleObject<T>(object: T) -> [T] {
    return [object]
}
