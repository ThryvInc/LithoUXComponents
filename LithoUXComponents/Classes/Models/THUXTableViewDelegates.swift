//
//  THUXRefreshableTableViewDelegate.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 6/9/18.
//

import UIKit

open class THUXTappableTableDelegate: NSObject, UITableViewDelegate {
    public var onTap: (IndexPath) -> Void = { _ in }
    
    public init(_ onTap: ((IndexPath) -> Void)? = nil) {
        if let onTap = onTap {
            self.onTap = onTap
        }
    }
    
    @objc open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onTap(indexPath)
    }
}

open class THUXPageableTableViewDelegate: THUXTappableTableDelegate {
    open var pageableModelManager: THUXPageableModelManager?
    open var pageTrigger: Int = 5
    open var pageSize: Int = 20
    
    public init(_ pageableModelManager: THUXPageableModelManager?, _ onTap: ((IndexPath) -> Void)? = nil) {
        super.init(onTap)
        self.pageableModelManager = pageableModelManager
    }

    @objc open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        if numberOfRows - indexPath.row == pageTrigger && numberOfRows % pageSize == 0  {
            pageableModelManager?.nextPage()
        }
    }
}
