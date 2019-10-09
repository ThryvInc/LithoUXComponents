import UIKit
import PlaygroundSupport
import PlaygroundVCHelpers
import LithoUXComponents

let vc = THUXLoginViewController(nibName: "THUXLoginViewController", bundle: Bundle(for: THUXLoginViewController.self))

PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true
