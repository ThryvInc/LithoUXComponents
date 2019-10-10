//
//  StubbableReactiveNetCall.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/10/19.
//

import FunNet

public class StubbableReactiveNetCall: ReactiveNetCall, Stubbable {
    public var stubHolder: StubHolderProtocol?
    public lazy var stubCondition: (URLRequest) -> Bool = defaultStubCondition(configuration: self.configuration, endpoint: self.endpoint)
    
    public var fireStubbable: (StubbableReactiveNetCall) -> Void = fireStubbable(_:)
    
    public init(configuration: ServerConfigurationProtocol,
                _ endpoint: EndpointProtocol,
                responder: ReactiveNetworkResponder? = ReactiveNetworkResponder(),
                stubHolder: StubHolderProtocol? = nil,
                stubCondition: ((URLRequest) -> Bool)? = nil) {
        super.init(configuration: configuration, endpoint, responder: responder)
        self.stubHolder = stubHolder
        if let condition = stubCondition {
            self.stubCondition = condition
        }
    }
    
    open override func fire() {
        if let _ = stubHolder {
            fireStubbable(self)
        } else {
            super.fire()
        }
    }
}
