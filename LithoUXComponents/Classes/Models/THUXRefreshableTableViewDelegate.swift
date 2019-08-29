//
//  THUXRefreshableTableViewDelegate.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 6/9/18.
//

import UIKit

open class THUXPageableTableViewDelegate: NSObject, UITableViewDelegate {
    open var pageableModelManager: THUXPageableModelManager?
    open var pageSize: Int = 20
    open var pageTrigger: Int = 5
    
    public init(_ pageableModelManager: THUXPageableModelManager?) {
        self.pageableModelManager = pageableModelManager
    }

    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.numberOfRows(inSection: indexPath.section) - indexPath.row == pageSize - pageTrigger {
            pageableModelManager?.nextPage()
        }
    }
}
