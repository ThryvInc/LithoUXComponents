import UIKit
import PlaygroundSupport
import PlaygroundVCHelpers
import LithoUXComponents
import LithoOperators
import Prelude

func optionalCast<T, U>(object: U) -> T? {
    return object as? T
}

let styleVC: (LUXLoginViewController) -> Void = { loginVC in
    print(loginVC.view)
    loginVC.forgotPasswordButton?.isHidden = true
}

let vc = LUXLoginViewController.makeFromXIB()
vc.onViewDidLoad = optionalCast >>> (styleVC >||> ifExecute)

PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true
