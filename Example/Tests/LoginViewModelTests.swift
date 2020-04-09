//
//  LoginViewModelTests.swift
//  LithoUXComponents_Tests
//
//  Created by Elliot Schrock on 10/9/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import LithoUXComponents
@testable import FunNet

class LoginViewModelTests: XCTestCase {

    func testSubmitButtonDisabledOnLoad() {
        var wasCalled = false
        
        let viewModel = LUXLoginViewModel(credsCall: ReactiveNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()),
                                           loginModelToJson: { _, _ in Human() })
        
        viewModel.outputs.submitButtonEnabled.observeValues { enable in
            XCTAssertFalse(enable)
            wasCalled = true
        }
        
        viewModel.inputs.viewDidLoad()
        
        XCTAssert(wasCalled)
    }

    func testSubmitButtonDisabledOnEmptyCredentials() {
        var wasCalled = false
        
        let viewModel = LUXLoginViewModel(credsCall: ReactiveNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()),
                                           loginModelToJson: { _, _ in Human() })
        
        viewModel.outputs.submitButtonEnabled.observeValues { enable in
            XCTAssertFalse(enable)
            wasCalled = true
        }
        
        viewModel.inputs.usernameChanged(username: "")
        viewModel.inputs.passwordChanged(password: "")
        
        XCTAssert(wasCalled)
    }

    func testSubmitButtonDisabledOnHalfEmptyCredentials() {
        var wasCalled = false
        
        let viewModel = LUXLoginViewModel(credsCall: ReactiveNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()),
                                           loginModelToJson: { _, _ in Human() })
        
        viewModel.outputs.submitButtonEnabled.observeValues { enable in
            XCTAssertFalse(enable)
            wasCalled = true
        }
        
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.inputs.passwordChanged(password: "")
        viewModel.inputs.usernameChanged(username: "")
        viewModel.inputs.passwordChanged(password: "password")
        
        XCTAssert(wasCalled)
    }

    func testSubmitButtonDisabledOnHalfFullCredentials() {
        var wasCalled = false
        var wasNotCalledTwice = true
        
        let viewModel = LUXLoginViewModel(credsCall: ReactiveNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()),
                                           loginModelToJson: { _, _ in Human() })
        
        viewModel.outputs.submitButtonEnabled.observeValues { enable in
            XCTAssertFalse(enable)
            if wasCalled {
                wasNotCalledTwice = false
            }
            wasCalled = true
        }
        
        viewModel.inputs.viewDidLoad()
        viewModel.inputs.usernameChanged(username: "elliot")
        
        XCTAssert(wasCalled)
        XCTAssert(wasNotCalledTwice)
    }

    func testSubmitButtonDisabledOnVisibleSpinner() {
        var callCount = 0
        
        let viewModel = LUXLoginViewModel(credsCall: ReactiveNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()),
                                           loginModelToJson: { _, _ in Human() })
        
        viewModel.outputs.submitButtonEnabled.observeValues { enable in
            callCount += 1
            if callCount != 2 {
                XCTAssertFalse(enable)
            }
        }
        
        viewModel.inputs.viewDidLoad()
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.inputs.passwordChanged(password: "password")
        viewModel.activityIndicatorVisibleProperty.value = true
        
        XCTAssertEqual(callCount, 3)
    }

    func testSubmitButtonEnabledOnValidCredentials() {
        var wasCalled = false
        
        let viewModel = LUXLoginViewModel(credsCall: ReactiveNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()),
                                           loginModelToJson: { _, _ in Human() })
        
        viewModel.outputs.submitButtonEnabled.observeValues { enable in
            XCTAssert(enable)
            wasCalled = true
        }
        
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.inputs.passwordChanged(password: "password")
        
        XCTAssert(wasCalled)
    }

    func testSubmitButtonDisabledUntilValidCredentials() {
        var callCount = 0
        
        let viewModel = LUXLoginViewModel(credsCall: ReactiveNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()),
                                           loginModelToJson: { _, _ in Human() })
        
        viewModel.outputs.submitButtonEnabled.observeValues { enable in
            callCount += 1
            if callCount < 6 {
                XCTAssertFalse(enable)
            } else {
                XCTAssert(enable)
            }
        }
        
        viewModel.inputs.viewDidLoad()
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.inputs.passwordChanged(password: "")
        viewModel.inputs.usernameChanged(username: "")
        viewModel.inputs.passwordChanged(password: "password")
        viewModel.activityIndicatorVisibleProperty.value = true
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.activityIndicatorVisibleProperty.value = false
        
        XCTAssertEqual(callCount, 7)
    }

    func testMakesCallOnSubmit() {
        var wasCalled = false
        var spinnerVisible = false
        
        let call = ReactiveNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())
        call.firingFunc = { _ in
            wasCalled = true
        }
        let viewModel = LUXLoginViewModel(credsCall: call,
                                           loginModelToJson: { _, _ in Human() })
        
        viewModel.outputs.activityIndicatorVisible.observeValues { enable in
            spinnerVisible = enable
        }
        
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.inputs.passwordChanged(password: "password")
        viewModel.inputs.submitButtonPressed()
        
        XCTAssert(wasCalled)
        XCTAssert(spinnerVisible)
    }

}
