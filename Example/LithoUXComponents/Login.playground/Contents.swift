import UIKit
import PlaygroundSupport
import PlaygroundVCHelpers
import LithoUXComponents
import LithoOperators
import Prelude

func optionalCast<T, U>(object: U) -> T? {
    return object as? T
}

let styleVC: (THUXLoginViewController) -> Void = { loginVC in
    print(loginVC.view)
    loginVC.forgotPasswordButton?.isHidden = true
}

let vc = THUXLoginViewController(nibName: "THUXLoginViewController", bundle: Bundle(for: THUXLoginViewController.self))
vc.onViewDidLoad = optionalCast >>> (styleVC >||> ifExecute)

PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true
