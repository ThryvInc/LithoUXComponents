import UIKit
import PlaygroundSupport
import PlaygroundVCHelpers
import LithoUXComponents

let vc = THUXLoginViewController()
let _ = loadViewFromNib(owner: vc)

PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true
