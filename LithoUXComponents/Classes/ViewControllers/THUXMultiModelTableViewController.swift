//
//  THUXMultiModelTableViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/12/19.
//

import UIKit

open class THUXMultiModelTableViewController<T>: THUXFunctionalViewController {
    @IBOutlet public var tableView: UITableView?
    open var tableViewDelegate: THUXTappableTableDelegate? { didSet { configureTableView() }}
    open var viewModel: T? { didSet { configureTableView() }}
    open var refreshableModelManager: THUXRefreshableNetworkCallManager? { didSet { indicatingCall = refreshableModelManager?.call }}
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
        if let vm = viewModel as? THUXDataSourceProvider {
            vm.dataSource.tableView = tableView
            tableView?.dataSource = vm.dataSource
        }
        if let pageableModelManager = refreshableModelManager as? THUXPageableModelManager {
            pageableModelManager.viewDidLoad()
        }
        tableView?.delegate = tableViewDelegate
        
        tableView?.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
}
