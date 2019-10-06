//
//  THUXJsonProvider.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 10/13/18.
//

import UIKit

public class THUXJsonProvider {
    public static var jsonEncoder = defaultJsonEncoder()
    public static var jsonDecoder = defaultJsonDecoder()
    
    public static func defaultJsonEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
    
    public static func defaultJsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
