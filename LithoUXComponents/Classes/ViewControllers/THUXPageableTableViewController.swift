//
//  THUXPageableTableViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 8/29/19.
//

import Foundation

open class THUXPageableTableViewController: THUXRefreshableTableViewController {
    open var pageableModelManager: THUXPageableModelManager? {
        didSet {
            self.refreshableModelManager = pageableModelManager
        }
    }
    open var pageableTableViewDelegate: THUXPageableTableViewDelegate?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = pageableTableViewDelegate
        pageableModelManager?.viewDidLoad()
    }
}

open class THUXPageableMultiTableViewController<T>: THUXRefreshableMultiTableViewController<T> {
    open var pageableModelManager: THUXPageableModelManager? {
        didSet {
            self.refreshableModelManager = pageableModelManager
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        pageableModelManager?.viewDidLoad()
    }
}
