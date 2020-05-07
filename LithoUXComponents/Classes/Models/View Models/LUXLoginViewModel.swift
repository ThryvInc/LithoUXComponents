//
//  LUXLoginViewModel.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/11/18.
//

import LUX
import ReactiveSwift
import FunNet
import Prelude

public protocol LUXLoginInputs {
    func usernameChanged(username: String?)
    func passwordChanged(password: String?)
    func submitButtonPressed()
    func viewDidLoad()
}

public protocol LUXLoginOutputs {
    var submitButtonEnabled: Signal<Bool, Never> { get }
    var activityIndicatorVisible: Signal<Bool, Never> { get }
    var advanceAuthed: Signal<(), Never> { get }
}

public protocol LUXLoginProtocol {
    var inputs: LUXLoginInputs { get }
    var outputs: LUXLoginOutputs { get }
}

open class LUXLoginViewModel: LUXLoginProtocol, LUXLoginInputs, LUXLoginOutputs {
    open var inputs: LUXLoginInputs { return self }
    open var outputs: LUXLoginOutputs { return self }
    
    let usernameChangedProperty = MutableProperty<String>("")
    let passwordChangedProperty = MutableProperty<String>("")
    let submitButtonPressedProperty = MutableProperty(())
    let viewDidLoadProperty = MutableProperty(())
    
    public let submitButtonEnabled: Signal<Bool, Never>
    
    public let activityIndicatorVisible: Signal<Bool, Never>
    let activityIndicatorVisibleProperty = MutableProperty<Bool>(false)
    
    public let advanceAuthed: Signal<(), Never>
    public let advanceAuthedProperty = MutableProperty(())
    
    public let successfulCredEntry: Signal<(String, String), Never>
    public let submittedFormDataInvalid: Signal<(String, String), Never>
    
    public let credentialLoginCall: ReactiveNetCall?
    
    public init<T>(credsCall: ReactiveNetCall? = nil, loginModelToJson: @escaping (String, String) -> T, saveAuth: ((Data) -> Bool)? = nil) where T: Encodable {
        credentialLoginCall = credsCall
        
        if let authSaved = saveAuth, let responder = credsCall?.responder {
            advanceAuthed = responder.dataSignal.skipNil().map(authSaved).filter { $0 }.map { _ in () }
        } else {
            advanceAuthed = advanceAuthedProperty.signal
        }
        
        activityIndicatorVisible = activityIndicatorVisibleProperty.signal
        
        let formData = Signal.combineLatest(
            self.usernameChangedProperty.signal,
            self.passwordChangedProperty.signal
        )
        
        successfulCredEntry = formData
            .sample(on: self.submitButtonPressedProperty.signal)
            .filter(type(of: self).isValidCreds(username:password:))
        
        submittedFormDataInvalid = formData
            .sample(on: self.submitButtonPressedProperty.signal)
            .filter(type(of: self).isInvalidCreds(username:password:))
        
        submitButtonEnabled = Signal.merge(
            self.viewDidLoadProperty.signal.map { _ in false },
            formData.map(type(of: self).isCredsPresent(username:password:)),
            self.activityIndicatorVisibleProperty.signal.map { visible in !visible}
        )
        
        submitButtonPressedProperty.signal.observeValues { _ in
            let model = loginModelToJson(self.usernameChangedProperty.value, self.passwordChangedProperty.value)
            self.credentialLoginCall?.endpoint.postData = try? LUXJsonProvider.jsonEncoder.encode(model)
            self.credentialLoginCall?.fire()
            self.activityIndicatorVisibleProperty.value = true
        }
        
        credentialLoginCall?.responder?.httpResponseSignal.observeValues(authResponseReceived)
    }
    
    open func usernameChanged(username: String?) {
        self.usernameChangedProperty.value = username ?? ""
    }
    
    open func passwordChanged(password: String?) {
        self.passwordChangedProperty.value = password ?? ""
    }
    
    open func submitButtonPressed() {
        self.submitButtonPressedProperty.value = ()
    }
    
    open func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    open func authResponseReceived(response: HTTPURLResponse) {
        if response.statusCode < 300 {
            self.advanceAuthedProperty.value = ()
        }
        self.activityIndicatorVisibleProperty.value = false
    }
    
    public static func isValidCreds(username: String, password: String) -> Bool {
        return true
    }
    
    public static func isInvalidCreds(username: String, password: String) -> Bool {
        return false
    }
    
    public static func isCredsPresent(username: String?, password: String?) -> Bool {
        return username != nil && !(username!.isEmpty) && password != nil && !(password!.isEmpty)
    }
}
