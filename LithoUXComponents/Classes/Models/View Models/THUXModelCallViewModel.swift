//
//  THUXModelCallViewModel.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 7/23/18.
//

import UIKit
import MultiModelTableViewDataSource
import Prelude
import ReactiveSwift

open class THUXModelCallViewModel<T> {
    public let modelsSignal: Signal<[T], Never>
    
    public init(modelsSignal: Signal<[T], Never>) {
        self.modelsSignal = modelsSignal
    }
}
