//
//  LUXRegistrationViewModel.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 4/30/18.
//

import UIKit
import ReactiveSwift

public protocol LUXViewLifecycleInputs {
    func viewDidLoad()
}

public protocol LUXEmailRegistrationInputs {
    func emailChanged(username: String?)
}

public protocol LUXUsernameRegistrationInputs {
    func usernameChanged(username: String?)
}

public protocol LUXPasswordRegistrationInputs {
    func passwordChanged(password: String?)
}

public protocol LUXRepeatedPasswordRegistrationInputs {
    func passwordRepeatChanged(password: String?)
}

public protocol LUXRegistrationSubmissionInputs {
    func submitButtonPressed()
}

public protocol LUXRegistrationOutputs {
    var submitButtonEnabled: Signal<Bool, Never> { get }
    var activityIndicatorVisible: Signal<Bool, Never> { get }
    var advanceAuthed: Signal<(), Never> { get }
}

open class LUXRegistrationViewModel: NSObject {

}
