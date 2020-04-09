//
//  LUXModelListViewModel.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 7/18/18.
//

import UIKit
import FlexDataSource
import Prelude
import ReactiveSwift

public protocol LUXDataSourceProvider {
    var dataSource: FlexDataSource { get }
}

open class LUXModelListViewModel<T>: LUXModelTableViewModel<T>, LUXDataSourceProvider {
    public let dataSource: FlexDataSource
    
    public override init(modelsSignal: Signal<[T], Never>, modelToItem: @escaping (T) -> FlexDataSourceItem) {
        dataSource = FlexDataSource()
        super.init(modelsSignal: modelsSignal, modelToItem: modelToItem)
        
        self.sectionsSignal.observeValues {
            self.dataSource.sections = $0
            self.dataSource.tableView?.reloadData()
        }
    }
}

open class LUXFilteredModelListViewModel<T>: LUXModelListViewModel<T> {
    public init(modelsSignal: Signal<[T], Never>, filter: @escaping (T) -> Bool, modelToItem: @escaping (T) -> FlexDataSourceItem) {
        super.init(modelsSignal: modelsSignal.map { $0.filter(filter) }, modelToItem: modelToItem)
    }
}
