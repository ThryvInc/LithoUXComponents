//
//  LUXTableViewModels.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 11/14/20.
//

import UIKit
import LUX
import fuikit
import FunNet
import Slippers
import FlexDataSource
import Prelude
import LithoOperators
import ReactiveSwift

open class LUXRefreshableTableViewModel: LUXTableViewModel, Refreshable {
    public var refresher: Refreshable
    
    public init(_ refresher: Refreshable) {
        self.refresher = refresher
    }
    
    @objc open func refresh() {
        if let isRefreshing = tableView?.refreshControl?.isRefreshing, !isRefreshing {
            tableView?.refreshControl?.beginRefreshing()
        }
        refresher.refresh()
    }
    
    @objc open func endRefreshing() {
        tableView?.refreshControl?.endRefreshing()
    }
    
    open override func configureTableView() {
        super.configureTableView()
        
        tableView?.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
}
extension LUXRefreshableTableViewModel {
    public func setupEndRefreshing(from call: ReactiveNetCall) {
        call.responder ?> setupEndRefreshing(from:)
    }
    
    public func setupEndRefreshing(from responder: ReactiveNetworkResponder) {
        responder.dataSignal.observeValues { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.endRefreshing()
            }
        }
        
        responder.errorSignal.observeValues { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.endRefreshing()
            }
        }
        
        responder.serverErrorSignal.observeValues { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.endRefreshing()
            }
        }
    }
}

open class LUXSectionsTableViewModel: LUXRefreshableTableViewModel {
    public var sectionsPublisher: Signal<[FlexDataSourceSection], Never>
    
    public init(_ refresher: Refreshable,
                _ sectionsPublisher: Signal<[FlexDataSourceSection], Never>) {
        self.sectionsPublisher = sectionsPublisher
        
        super.init(refresher)
        
        let dataSource = FlexDataSource()
        self.sectionsPublisher.observeValues {
            dataSource.sections = $0
            dataSource.tableView?.reloadData()
        }
        self.dataSource = dataSource
    }
}

open class LUXItemsTableViewModel: LUXSectionsTableViewModel {
    public init(_ refresher: Refreshable,
                itemsPublisher: Signal<[FlexDataSourceItem], Never>,
                toSections: @escaping ([FlexDataSourceItem]) -> [FlexDataSourceSection] = itemsToSection >>> arrayOfSingleObject) {
        super.init(refresher, itemsPublisher.map(toSections))
    }
}
