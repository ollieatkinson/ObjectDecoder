//: Playground - noun: a place where people can play

import ObjectDecoder

var data: [String: Any] = [
    "this": [
        "b": "bValue",
        "is": [
            "a": "keyPath"
        ]
    ],
    "author": "Oliver Atkinson"
]

//using the operator:

do {
    let value: String = try data => "this.b" //bValue
} catch let error {
    print(error)
}

//using subscripting:

let value = data[keyPath: "this.is.a"] // keyPath

//accessing a missing key:
    
do {
    let value: String = try data => "a.b"
} catch let error {
    print(error) // DecodingError.missing(a.b, dictionary, [ a ] is missing in <dictionary>)
}

do {
    let value: Int = try data => "this.c"
} catch let error {
    print(error)  // DecodingError.missing(this.c, dictionary, this.c is missing in <dictionary>)
}

//accessing a key and casting the wrong type:
    
do {
    let value: Int = try data => "this.b"
} catch let error {
    print(error) // DecodingError.typeMismatch(this.b, expected: Swift.Int, actual: Swift.string, "Int for `b` was specified but got type String")
}

let JSONData: Data = "{\"index\":{\"value\":42}}".data(using: .utf8)!

/// {
///    "index": {
///         "value": 42
///    }
/// }

do {
    let JSON = try JSONSerialization.jsonObject(with: JSONData, options: [ ])
    let value: Int = try JSON => "index.value" // 42
} catch {
    // failed
}