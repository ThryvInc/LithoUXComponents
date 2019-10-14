//
//  THUXRefreshablePagedTableViewController.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 6/9/18.
//

import UIKit

open class THUXRefreshableTableViewController: UIViewController {
    @IBOutlet public var tableView: UITableView!
    open var refreshableModelManager: THUXRefreshableNetworkCallManager? {
        didSet {
            refreshableModelManager?.call?.responder?.responseSignal.observeValues({ _ in
                self.tableView.refreshControl?.endRefreshing()
            })
            refreshableModelManager?.call?.responder?.dataSignal.observeValues({ _ in
                self.tableView.refreshControl?.endRefreshing()
            })
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    @objc
    open func refresh() {
        if let isRefreshing = tableView.refreshControl?.isRefreshing, !isRefreshing {
            tableView.refreshControl?.beginRefreshing()
        }
        refreshableModelManager?.refresh()
    }

}

open class THUXRefreshableMultiTableViewController<T>: THUXMultiModelTableViewController<T> {
    open var refreshableModelManager: THUXRefreshableNetworkCallManager? {
        didSet {
            refreshableModelManager?.call?.responder?.responseSignal.observeValues({ _ in
                self.tableView?.refreshControl?.endRefreshing()
            })
            refreshableModelManager?.call?.responder?.dataSignal.observeValues({ _ in
                self.tableView?.refreshControl?.endRefreshing()
            })
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    @objc
    open func refresh() {
        if let isRefreshing = tableView?.refreshControl?.isRefreshing, !isRefreshing {
            tableView?.refreshControl?.beginRefreshing()
        }
        refreshableModelManager?.refresh()
    }

}
