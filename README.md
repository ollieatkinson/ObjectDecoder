# Deprecated - Use Decodable in Swift 3.2+

---

# ObjectDecoder

Simple and effective object mapping made possible in Swift - taking advantage of Swift's great features.

ObjectDecoder is aimed to provide a lot of fool-proof functionality with little code in the hope that it is easy to understand for every developer.

```swift
var data: [String: Any] = [
    "this": [
        "b": "bValue",
        "is": [
            "a": "keyPath"
        ]
    ],
    "author": "Oliver Atkinson"
]

do {
    let value: String = try data => "this.b" //bValue
} catch let error {
    print(error)
}

let value = data[keyPath: "this.is.a"] // keyPath

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

do {
    let value: Int = try data => "this.b"
} catch let error {
    print(error) // DecodingError.typeMismatch(this.b, expected: Swift.Int, actual: Swift.string, "Int for `b` was specified but got type String")
}

/// ---

let JSONData: Data = "{\"index\":{\"value\":42}}".data(using: .utf8)!

/// {
///    "index": {
///         "value": 42
///    }
/// }

do {
    let JSON = try JSONSerialization.jsonObject(with: JSONData, options: [ ]) as JSONObject
    let value: Int = try JSON => "index.value" // 42
} catch {
    // failed
}
```

ObjectDecoder allows you to implement your mapping however you want, and does not force you down a particular route. One example can be seen below:

```swift
struct NewsArticle {

  let identifier: Int
  let author: String
  let language: String?
  let sometimesMissing: Int?

}

struct NewsArticleMapper {

  static func decode(JSON: JSONObject) throws -> NewsArticle {
    
    return NewsArticle(
      identifier: try JSON => "id",
      author: try JSON => "author.name",
      language: try JSON => "i18n",
      sometimesMissing: JSON =>? "sometimesMissing"
    )
  
  }

}

do {
    let JSON = try JSONSerialization.jsonObject(with: JSON, options: [ ]) as JSONObject
    let article = try NewsArticle.decode(JSON: JSON)
} catch {
    print(error)
}

```

## Contributing

1. Fork it ([https://github.com/ollieatkinson/ObjectDecoder/fork](https://github.com/ollieatkinson/ObjectDecoder/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
