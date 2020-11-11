//
//  LUXFlexTableViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/12/19.
//

import fuikit
import ReactiveSwift
import FunNet
import LUX
import Slippers

open class LUXFlexTableViewController<T>: FUITableViewViewController {
    open var tableViewDelegate: FUITableViewDelegate? { didSet { configureTableView() }}
    open var viewModel: T? { didSet { configureTableView() }}
    open var refreshableModelManager: (Refreshable & CallManager)? { didSet { indicatingCall = refreshableModelManager?.call as? ReactiveNetCall }}
    open var indicatingCall: ReactiveNetCall? {
        didSet {
            indicatingCall?.responder?.responseSignal.observeValues({ _ in
                self.tableView?.refreshControl?.endRefreshing()
            })
            indicatingCall?.responder?.dataSignal.observeValues({ _ in
                self.tableView?.refreshControl?.endRefreshing()
            })
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.tableFooterView = UIView()
        
        configureTableView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    @objc
    open func refresh() {
        if let refresher = refreshableModelManager {
            if let isRefreshing = tableView?.refreshControl?.isRefreshing, !isRefreshing {
                tableView?.refreshControl?.beginRefreshing()
            }
            refresher.refresh()
        }
    }

    open func configureTableView() {
        if let vm = viewModel as? LUXDataSourceProvider {
            vm.dataSource.tableView = tableView
            tableView?.dataSource = vm.dataSource
        }
        tableView?.delegate = tableViewDelegate
        
        tableView?.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
}
