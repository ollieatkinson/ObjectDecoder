//
//  KeyPath.swift
//  ObjectDecoder
//
//  Created by Atkinson, Oliver (Developer) on 12/02/2017.
//  Copyright © 2017 Oliver Atkinson. All rights reserved.
//

/// A representation of a series of strings used for accessing the value in a dictionary. These strings represent a keyPath.
public struct KeyPath {
    
    /// An array of `Key` objects used as a representation of a keyPath.
    var segments: [Key]
    
    /// A Boolean value indicating whether the KeyPath is empty.
    var isEmpty: Bool {
        return segments.isEmpty
    }
    
    /// The path for the keyPath, returned as an String object joined with fullstops '.'
    var path: String {
        return segments.joined(separator: ".")
    }
    
}

/// A string representation of the key path shown as "this.is.a.keypath"
extension KeyPath: CustomStringConvertible {
    
    public var description: String {
        return path
    }
    
}

/// Initializes a KeyPath with a string of the form "this.is.a.keypath"
extension KeyPath {
    
    init(_ string: String) {
        segments = string.components(separatedBy: ".")
    }
    
}

/// Create a key path with a plain string literal like "this.is.a.key.path", without needing to explicitly create a KeyPath instance.
extension KeyPath: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    
}

/// An extension on dictionary to provide keyPath access.
/// e.g. data[keyPath: "a.b.c"] // == "value"
public extension Dictionary {
    
    subscript(keyPath keyPath: KeyPath) -> Any? {
        return try? decode(JSON: self as JSONObject, keyPath: keyPath)
    }
    
}
