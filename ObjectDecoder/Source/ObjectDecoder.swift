//
//  ObjectDecoder.swift
//  ObjectDecoder
//
//  Created by Atkinson, Oliver (Developer) on 12/02/2017.
//  Copyright © 2017 Oliver Atkinson. All rights reserved.
//

/// A type describing a JSON object.
public typealias JSONObject = Any

/// A type describing the key used for indexing JSON objects.
public typealias Key = String

/// precedence group for the custom operators => and =>?
precedencegroup KeyPrecedence {
    associativity: right
    higherThan: CastingPrecedence
}

infix operator => : KeyPrecedence
infix operator =>? : KeyPrecedence

/// Return the value in dictionary `JSON` at keyPath `keyPath`
///
/// - parameter JSON: The dictionary object to query.
/// - parameter keyPath: A key path of the form _relationship.property_ (with one or more relationships); for example “department.name”
///
/// - throws: see DecodingError
///
/// - returns: The value for the derived property identified by keyPath.
public func => <Value: Any>(JSON: [Key : Any], keyPath: KeyPath) throws -> Value {
    return try decode(JSON: JSON, keyPath: keyPath)
}

/// Return the value in dictionary `JSON` at keyPath `keyPath`
///
/// - parameter JSON: The dictionary object to query.
/// - parameter keyPath: A key path of the form _relationship.property_ (with one or more relationships); for example “department.name”
///
/// - returns: The value from the JSON object for `key` or nil if failure.
public func =>? <Value: Any>(JSON: [Key : Any], keyPath: KeyPath) -> Value? {
    return try? JSON => keyPath
}

/// Return the value in dictionary `JSON` at keyPath `keyPath`
///
/// - parameter JSON: The dictionary object to query.
/// - parameter keyPath: A key path of the form _relationship.property_ (with one or more relationships); for example “department.name”
///
/// - throws: see DecodingError
///
/// - returns: The value for the derived property identified by keyPath.
public func => <Value: Any>(JSON: JSONObject, keyPath: KeyPath) throws -> Value {
    return try decode(JSON: JSON, keyPath: keyPath)
}

/// Return the value in dictionary `JSON` at keyPath `keyPath`
///
/// - parameter JSON: The dictionary object to query.
/// - parameter keyPath: A key path of the form _relationship.property_ (with one or more relationships); for example “department.name”
///
/// - returns: The value for the derived property identified by keyPath.
public func =>? <Value: Any>(JSON: JSONObject, keyPath: KeyPath) -> Value? {
    return try? JSON => keyPath
}

// MARK: Functions

public func decode<Value: Any>(JSON: JSONObject, keyPath: KeyPath) throws -> Value {
    
    guard let JSONData = JSON as? [Key : Any] else {
        throw DecodingError.typeMismatch(
            keyPath: keyPath,
            expected: [Key : Any].self,
            actual: type(of: JSON),
            enclosing: JSON,
            reason: "Could not unwrap JSONObject as \([Key : Any].self)"
        )
    }
    
    return try decode(JSON: JSONData, keyPath: keyPath)
    
}

public func decode<Value: Any>(JSON: [Key : Any], keyPath: KeyPath) throws -> Value {
    
    guard !keyPath.isEmpty else {
        throw DecodingError.invalidKeyPath(keyPath: keyPath)
    }
    
    var current = JSON
    
    for (index, key) in keyPath.segments.dropLast().enumerated() {
        
        guard let next = current[key] as? [Key : Any] else {
            throw DecodingError.missing(
                keyPath: keyPath,
                enclosing: current as JSONObject,
                reason: "\(keyPath.segments[0...index]) is missing in \(current)"
            )
        }
        
        current = next
        
    }
    
    guard let key = keyPath.segments.last else {
        throw DecodingError.invalidKeyPath(keyPath: keyPath)
    }
    
    guard current.keys.contains(key) else {
        throw DecodingError.missing(keyPath: keyPath, enclosing: current as JSONObject, reason: "\(keyPath) is missing in \(current)")
    }
    
    guard let value = current[key], !(value is NSNull) else {
        throw DecodingError.isNil(keyPath: keyPath, reason: "\(keyPath) is null in \(current)")
    }
    
    guard let unwrapped = value as? Value else {
        throw DecodingError.typeMismatch(
            keyPath: keyPath,
            expected: Value.self,
            actual: type(of: value),
            enclosing: current as JSONObject,
            reason: "\(Value.self) for \(key) was specified but got type \(type(of: value))"
        )
    }
    
    return unwrapped
    
}
