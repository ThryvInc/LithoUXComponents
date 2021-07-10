//
//  ReactiveNetCallHelpers.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 1/22/21.
//

import FunNet
import Prelude
import LithoOperators

public func resetOnResponse(responder: ReactiveNetworkResponder, reset: @escaping () -> Void) {
    responder.responseSignal.observeValues(ignoreArg(reset))
    responder.errorSignal.observeValues(ignoreArg(reset))
}

public func alertOnError(_ responder: ReactiveNetworkResponder, _ vc: UIViewController) {
    responder.errorSignal.observeValues(VerboseLoginErrorHandler().alert(for:) >>> vc.presentAnimated(_:))
    responder.serverErrorSignal.observeValues(VerboseLoginErrorHandler().alert(for:) >>> vc.presentAnimated(_:))
}
