//
//  THUXRegistrationViewModel.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 4/30/18.
//

import UIKit
import ReactiveSwift

public protocol THUXViewLifecycleInputs {
    func viewDidLoad()
}

public protocol THUXEmailRegistrationInputs {
    func emailChanged(username: String?)
}

public protocol THUXUsernameRegistrationInputs {
    func usernameChanged(username: String?)
}

public protocol THUXPasswordRegistrationInputs {
    func passwordChanged(password: String?)
}

public protocol THUXRepeatedPasswordRegistrationInputs {
    func passwordRepeatChanged(password: String?)
}

public protocol THUXRegistrationSubmissionInputs {
    func submitButtonPressed()
}

public protocol THUXRegistrationOutputs {
    var submitButtonEnabled: Signal<Bool, Never> { get }
    var activityIndicatorVisible: Signal<Bool, Never> { get }
    var advanceAuthed: Signal<(), Never> { get }
}

open class THUXRegistrationViewModel: NSObject {

}
