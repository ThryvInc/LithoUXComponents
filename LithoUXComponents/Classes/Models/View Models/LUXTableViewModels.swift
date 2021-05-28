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
extension LUXRefreshableTableViewModel {
    public func setupOnLoad() -> (FUITableViewViewController) -> Void {
        return {
            self.tableView = $0.tableView
            self.refresh()
        }
    }
}

open class LUXSectionsTableViewModel: LUXRefreshableTableViewModel, LUXDataSourceProvider {
    public var flexDataSource: LUXTableDataSource = FlexSimpleDataSource() { didSet { dataSource = flexDataSource }}
    public var sectionsPublisher: Signal<[FlexDataSourceSection], Never>
    
    public init(_ refresher: Refreshable,
                _ sectionsPublisher: Signal<[FlexDataSourceSection], Never>) {
        self.sectionsPublisher = sectionsPublisher
        
        super.init(refresher)
        
        self.sectionsPublisher.observeValues {[weak self] in
            self?.flexDataSource.sections = $0
            self?.flexDataSource.tableView?.reloadData()
        }
        self.dataSource = flexDataSource
    }
}

open class LUXItemsTableViewModel: LUXSectionsTableViewModel {
    public init(_ refresher: Refreshable,
                itemsPublisher: Signal<[FlexDataSourceItem], Never>,
                toSections: @escaping ([FlexDataSourceItem]) -> [FlexDataSourceSection] = itemsToSection >>> arrayOfSingleObject) {
        super.init(refresher, itemsPublisher.map(toSections))
    }
}
