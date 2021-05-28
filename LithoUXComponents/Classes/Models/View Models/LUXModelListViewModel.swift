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

public typealias LUXTableDataSource = FlexDataSource & UITableViewDataSource

public protocol LUXDataSourceProvider {
    var flexDataSource: LUXTableDataSource { get set }
}

open class LUXModelListViewModel<T>: LUXModelTableViewModel<T>, LUXDataSourceProvider {
    public var flexDataSource: LUXTableDataSource = FlexSimpleDataSource()
    
    public override init(modelsSignal: Signal<[T], Never>, modelToItem: @escaping (T) -> FlexDataSourceItem) {
        super.init(modelsSignal: modelsSignal, modelToItem: modelToItem)
        
        self.sectionsSignal.observeValues { [weak self] in
            self?.flexDataSource.sections = $0
            self?.flexDataSource.tableView?.reloadData()
        }
    }
}

open class LUXFilteredModelListViewModel<T>: LUXModelListViewModel<T> {
    public init(modelsSignal: Signal<[T], Never>, filter: @escaping (T) -> Bool, modelToItem: @escaping (T) -> FlexDataSourceItem) {
        super.init(modelsSignal: modelsSignal.map { $0.filter(filter) }, modelToItem: modelToItem)
    }
}
