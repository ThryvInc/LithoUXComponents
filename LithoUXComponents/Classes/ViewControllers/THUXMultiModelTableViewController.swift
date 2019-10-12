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
    open var viewModel: THUXModelListViewModel<T>?

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.tableFooterView = UIView()
        configureTableView()
    }

    open func configureTableView() {
        viewModel?.dataSource.tableView = tableView
        tableView?.dataSource = viewModel?.dataSource
        tableView?.delegate = tableViewDelegate
    }
}
