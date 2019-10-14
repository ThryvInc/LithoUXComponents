//
//  THUXMultiModelTableViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/12/19.
//

import UIKit

open class THUXMultiModelTableViewController<T>: UIViewController {
    @IBOutlet public var tableView: UITableView?
    open var tableViewDelegate: THUXTappableTableDelegate?
    open var viewModel: THUXModelTableViewModel<T>?

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.tableFooterView = UIView()
        configureTableView()
    }

    open func configureTableView() {
        if let vm = viewModel as? THUXDataSourceProvider {
            vm.dataSource.tableView = tableView
            tableView?.dataSource = vm.dataSource
        }
        tableView?.delegate = tableViewDelegate
    }
}
