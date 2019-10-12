//
//  THUXModelTableViewModel.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 7/23/18.
//

import UIKit
import MultiModelTableViewDataSource
import Prelude
import FunNet
import ReactiveSwift
import LithoOperators

open class THUXModelTableViewModel<T>: THUXModelCallViewModel<T> {
    public var sectionsSignal: Signal<[MultiModelTableViewDataSourceSection], Never>!
    public var modelToItem: ((T) -> MultiModelTableViewDataSourceItem)
    
    public init(modelsSignal: Signal<[T], Never>, modelToItem: @escaping (T) -> MultiModelTableViewDataSourceItem) {
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
