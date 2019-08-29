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

open class THUXModelTableViewModel<T>: THUXModelCallViewModel<T> {
    public var sectionsSignal: Signal<[MultiModelTableViewDataSourceSection], Never>!
    public var modelToItem: ((T) -> MultiModelTableViewDataSourceItem)
    
    public init(modelsSignal: Signal<[T], Never>, modelToItem: @escaping (T) -> MultiModelTableViewDataSourceItem) {
        self.modelToItem = modelToItem
        
        super.init(modelsSignal: modelsSignal)
        
        let toSections = MultiModelTableViewDataSourceSection.itemsToSection >>> arrayOfSingleObject
        let modelsToItems = modelToItem >||> map
        let transform = modelsToItems >>> toSections
        self.sectionsSignal = self.modelsSignal.map(transform)
    }
}

public extension MultiModelTableViewDataSourceSection {
    static func itemsToSection(items: [MultiModelTableViewDataSourceItem]) -> MultiModelTableViewDataSourceSection {
        let section = MultiModelTableViewDataSourceSection()
        section.items = items
        return section
    }
}

public func arrayOfSingleObject<T>(object: T) -> [T] {
    return [object]
}

public func map<U, V>(array: [U], f: (U) -> V) -> [V] {
    return array.map(f)
}
