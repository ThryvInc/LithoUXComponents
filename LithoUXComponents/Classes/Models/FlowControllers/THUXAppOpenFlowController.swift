//
//  THUXAppOpenFlowController.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 4/30/18.
//

import UIKit

open class THUXAppOpenFlowController: THUXFlowCoordinator {
    open var splashViewModel: THUXSplashViewModel?
    open var loginViewModel: THUXLoginViewModel?
    open var registrationViewModel: THUXRegistrationViewModel?
    
    public init() {}
    open func initialVC() -> UIViewController? { return nil }
}
