//
//  LUXSearchViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/17/19.
//

import LUX
import ReactiveSwift
import LithoOperators
import Prelude
import FunNet
import LUX
import Slippers

open class LUXSearchViewController<T, U>: LUXFlexTableViewController<T> {
    @IBOutlet open weak var searchBar: UISearchBar?
    @IBOutlet open weak var searchTopConstraint: NSLayoutConstraint?
    
    open var lastScreenYForAnimation: CGFloat?
    
    open var searchViewModel: LUXSearchViewModel<U>? = LUXSearchViewModel<U>()
    open var shouldRefresh = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if let y = lastScreenYForAnimation {
            searchTopConstraint?.constant = y
            tableView?.alpha = 0
        }
        
        searchBar?.delegate = searchViewModel?.searchBarDelegate
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldRefresh = (searchViewModel?.savedSearch == nil || searchViewModel?.savedSearch == "")
        if let searchText = searchViewModel?.savedSearch {
            searchBar?.text = searchText
            searchBar?.resignFirstResponder()
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = self.lastScreenYForAnimation {
            UIView.animate(withDuration: 0.25, animations: {
                self.searchTopConstraint?.constant = 0
                self.tableView?.alpha = 1
            }) { _ in
                self.searchBar?.becomeFirstResponder()
            }
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchViewModel?.savedSearch = searchBar?.text
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
}

open class LUXSearcher<T>: LUXSearchable {
    let searchTextProperty = MutableProperty<String?>(nil)
    public let searchTextSignal: Signal<String?, Never>
    let incrementalSearchTextProperty = MutableProperty<String?>(nil)
    public let incrementalSearchTextSignal: Signal<String?, Never>
    open var isIncluded: (String?, T) -> Bool
    
    public init(isIncluded: @escaping (String?, T) -> Bool) {
        self.isIncluded = isIncluded
        searchTextSignal = searchTextProperty.signal
        incrementalSearchTextSignal = incrementalSearchTextProperty.signal
    }
    
    public init(_ modelToString: @escaping (T) -> String?, _ nilAndEmptyStrategy: NilAndEmptyMatchStrategy, _ matchStrategy: MatchStrategy, _ isCaseSensitive: Bool = false) {
        searchTextSignal = searchTextProperty.signal
        incrementalSearchTextSignal = incrementalSearchTextProperty.signal
        
        let (nilMatcher, emptyMatcher) = nilAndEmptyMatchers(for: nilAndEmptyStrategy)
        let match = matcher(for: matchStrategy)
        
        if isCaseSensitive {
            isIncluded = { search, t in defaultIsIncluded(search, t, modelToString, nilMatcher, emptyMatcher, match)}
        } else {
            isIncluded = { search, t in
                defaultIsIncluded(search?.lowercased(), t, modelToString >>> lowercased(string:), nilMatcher, emptyMatcher, match)
            }
        }
    }
    
    public init(_ modelToString: @escaping (T) -> String, _ nilAndEmptyStrategy: NilAndEmptyMatchStrategy, _ matchStrategy: MatchStrategy, _ isCaseSensitive: Bool = false) {
        searchTextSignal = searchTextProperty.signal
        incrementalSearchTextSignal = incrementalSearchTextProperty.signal
        
        let (nilMatcher, emptyMatcher) = nilAndEmptyMatchers(for: nilAndEmptyStrategy)
        let match = matcher(for: matchStrategy)
        
        if isCaseSensitive {
            isIncluded = { search, t in defaultIsIncluded(search, t, modelToString, nilMatcher, emptyMatcher, match)}
        } else {
            isIncluded = { search, t in
                defaultIsIncluded(search?.lowercased(), t, modelToString >>> lowercased(string:), nilMatcher, emptyMatcher, match)
            }
        }
    }
    
    open func updateIncrementalSearch(text: String?) {
        incrementalSearchTextProperty.value = text
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
        guard let t = text, t != "" else {
            return array
        }
        return array.filter(t >|> isIncluded)
    }
    
    open func filter(tuple: (String?, [T])) -> [T] {
        return tuple |> ~filter(text:array:)
    }
}

extension LUXSearcher {
    open func filteredSignal(from modelsSignal: Signal<[T], Never>) -> Signal<[T], Never> {
        return Signal.combineLatest(searchTextSignal, modelsSignal).map(filter(tuple:))
    }
}
