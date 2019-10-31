//
//  THUXFunctionalViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/31/19.
//

import UIKit

open class THUXFunctionalViewController: UIViewController {
    public var onLoadView: ((THUXFunctionalViewController) -> Void)?
    public var onLayoutSubviews: ((THUXFunctionalViewController) -> Void)?
    public var onViewDidLoad: ((THUXFunctionalViewController) -> Void)?
    public var onViewWillAppear: ((THUXFunctionalViewController, Bool) -> Void)?
    public var onViewDidAppear: ((THUXFunctionalViewController, Bool) -> Void)?
    
    open override func loadView() {
        onLoadView?(self)
        super.loadView()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad?(self)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewWillAppear?(self, animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewDidAppear?(self, animated)
    }
}
