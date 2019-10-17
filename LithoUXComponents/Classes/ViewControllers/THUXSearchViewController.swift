//
//  THUXSearchViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/17/19.
//

import UIKit

open class THUXSearchViewController<T, U>: THUXMultiModelTableViewController<T>, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var searchTopConstraint: NSLayoutConstraint?
    
    var lastScreenYForAnimation: CGFloat?
    var onSearch: (String) -> Void = { _ in }
    var searcher: Searcher<U>?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if let y = lastScreenYForAnimation {
            searchTopConstraint?.constant = y
            tableView?.alpha = 0
        }
        
        searchBar?.delegate = self
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.25, animations: {
            self.searchTopConstraint?.constant = 0
            self.tableView?.alpha = 1
        }) { _ in
            self.searchBar?.becomeFirstResponder()
        }
    }
    
    //MARK: - search
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onSearch(searchText)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

open class Searcher<T> {
    open var searchText: String?
    open var isIncluded: (String, T) -> Bool
    
    public init(isIncluded: @escaping (String, T) -> Bool) {
        self.isIncluded = isIncluded
    }
    
    open func filter(t: T) -> Bool {
        guard let text = searchText, text != "" else {
            return true
        }
        return isIncluded(text, t)
    }
}
