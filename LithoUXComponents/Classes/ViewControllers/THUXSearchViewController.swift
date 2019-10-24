//
//  THUXSearchViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/17/19.
//

import UIKit
import ReactiveSwift
import LithoOperators
import Prelude

open class THUXSearchViewController<T, U>: THUXMultiModelTableViewController<T>, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var searchTopConstraint: NSLayoutConstraint?
    
    open var lastScreenYForAnimation: CGFloat?
    open var onSearch: (String) -> Void = { _ in }
    open var searcher: THUXSearcher<U>?
    
    open var shouldRefresh = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if let y = lastScreenYForAnimation {
            searchTopConstraint?.constant = y
            tableView?.alpha = 0
        }
        
        searchBar?.delegate = self
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        shouldRefresh = (searchBar?.text == nil || searchBar?.text == "")
        super.viewDidAppear(animated)
        
        if let _ = self.lastScreenYForAnimation {
            UIView.animate(withDuration: 1.25, animations: {
                self.searchTopConstraint?.constant = 0
                self.tableView?.alpha = 1
            }) { _ in
                self.searchBar?.becomeFirstResponder()
            }
        }
    }
    
    open override func refresh() {
        if shouldRefresh {
            super.refresh()
            searchBar?.resignFirstResponder()
            searchBar?.text = ""
        } else {
            shouldRefresh = true
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

open class THUXSearcher<T> {
    let searchTextProperty = MutableProperty<String?>(nil)
    public let searchTextSignal: Signal<String?, Never>
    open var isIncluded: (String?, T) -> Bool
    
    public init(isIncluded: @escaping (String?, T) -> Bool) {
        self.isIncluded = isIncluded
        searchTextSignal = searchTextProperty.signal
    }
    
    open func updateSearch(text: String?) {
        searchTextProperty.value = text
    }
    
    open func filter(_ t: T) -> Bool {
        guard let text = searchTextProperty.value, text != "" else {
            return true
        }
        return isIncluded(text, t)
    }
    
    open func filter(text: String?, array: [T]) -> [T] {
        guard let text = searchTextProperty.value, text != "" else {
            return array
        }
        return array.filter(text >|> isIncluded)
    }
    
    open func filter(tuple: (String?, [T])) -> [T] {
        return tuple |> ~filter(text:array:)
    }
}

extension THUXSearcher {
    open func filteredSignal(from modelsSignal: Signal<[T], Never>) -> Signal<[T], Never> {
        return Signal.combineLatest(searchTextSignal, modelsSignal).map(filter(tuple:))
    }
}
