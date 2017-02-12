//
//  DecodingError.swift
//  ObjectDecoder
//
//  Created by Atkinson, Oliver (Developer) on 12/02/2017.
//  Copyright © 2017 Oliver Atkinson. All rights reserved.
//

/// Provides information about an error which occured when trying to decode the JSON object.
public enum DecodingError: Error {
    
    /// - invalidKeyPath: Thrown when the keyPath is not in the correct format.
    case invalidKeyPath(keyPath: KeyPath)
    
    /// - missing: Thrown when an item could not be found the JSON object.
    case missing(keyPath: KeyPath, enclosing: JSONObject, reason: String)
    
    /// - isNil: Thrown when the value of the specified key is nil.
    case isNil(keyPath: KeyPath, reason: String)
    
    /// - typeMismatch: Thrown when casting to `expected` fails or when trying to cast as [Key : Any].
    case typeMismatch(keyPath: KeyPath, expected: Any.Type, actual: Any.Type, enclosing: JSONObject, reason: String)
    
}
