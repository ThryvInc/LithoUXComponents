//
//  THUXModelListViewModel.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 7/18/18.
//

import UIKit
import MultiModelTableViewDataSource
import Prelude
import ReactiveSwift

public protocol THUXDataSourceProvider {
    var dataSource: MultiModelTableViewDataSource { get }
}

open class THUXModelListViewModel<T>: THUXModelTableViewModel<T>, THUXDataSourceProvider {
    public let dataSource = MultiModelTableViewDataSource()
    
    public override init(modelsSignal: Signal<[T], Never>, modelToItem: @escaping (T) -> MultiModelTableViewDataSourceItem) {
        super.init(modelsSignal: modelsSignal, modelToItem: modelToItem)
        
        self.sectionsSignal.observeValues {
            self.dataSource.sections = $0
            self.dataSource.tableView?.reloadData()
        }
    }
}
