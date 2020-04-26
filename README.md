# ContentApi

Generic, reusable, content focused REST service endpoints.


## Install

Add the repository as a dependency:

```swift
.package(url: "https://github.com/binarybirds/content-api.git", from: "1.0.0"),
```

Add ContentApi to the target dependencies:

```swift
.product(name: "ContentApi", package: "content-api"),
```

Update the packages and you are ready.

## Usage

### Api

```swift
import Vapor
import Fluent
import ContentApi

final class ExampleModel: Model {

    static var schema: String = "categories"

    struct FieldKeys {
        static var foo: FieldKey { "foo" }
        static var bar: FieldKey { "bar" }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.foo) var foo: String
    @Field(key: FieldKeys.bar) var bar: String

    init() { }

    init(id: UUID? = nil,
         foo: String,
         bar: String)
    {
        self.id = id
        self.foo = foo
        self.bar = bar
    }
}

extension ExampleModel: ApiRepresentable {
    struct ApiContent: ValidatableContent {
        let foo: String
        let bar: String?
    }

    var listContent: ApiContent {
        .init(foo: self.foo)
    }

    var getContent: ApiContent {
        .init(foo: self.foo, bar: self.bar)
    }

    func create(content: ApiContent) throws {
        self.foo = content.foo
        self.bar = "default"
    }

    func update(_: ApiContent) throws {
        self.foo = content.foo
        self.bar = content.bar
    }

    func patch(_: ApiContent) throws {
        self.foo = content.foo
        self.bar = content.bar ?? "default"
    }
}

final class ExampleApiController: ApiController {
    typealias Model = ExampleModel
}

// router
ExampleApiController().setupRoutes(routes: app.routes, on: "example")
```

### List


```swift
extension ExampleModel: ListContentRepresentable {

    struct ListItem: Content {
        let foo: String
    }

    var listContent: ListItem {
        .init(foo: self.foo)
    }
}

final class ListController: ListContentController {
    typealias Model = ExampleModel
}

ListController().setupListRoute(routes: routes.grouped("example"))
```


### Get

```swift
extension ExampleModel: GetContentRepresentable {

    struct Get: Content {
        let foo: String
        let bar: String?
    }

    var getContent: Get {
        .init(foo: self.foo, bar: self.bar)
    }
}

final class GetController: GetontentController {
    typealias Model = ExampleModel
}

GetController().setupGetRoute(routes: routes.grouped("example"))
```


### Create

```swift
extension ExampleModel: CreateContentRepresentable {

    struct Create: ValidatableContent {
        var foo: String
        var bar: String
    }

    func create(_ content: Create) throws {
        self.foo = content.foo
        self.bar = content.bar
    }
}

final class CreateController: CreateContentController {
    typealias Model = ExampleModel
}

CreateController().setupCreateRoute(routes: routes.grouped("example"))
```


### Update

```swift
extension ExampleModel: UpdateContentRepresentable {

    struct Update: ValidatableContent {
        var foo: String
        var bar: String
    }

    func update(_ content: Update) throws {
        self.foo = content.foo
        self.foo = content.bar
    }
}

final class UpdateController: UpdateContentController {
    typealias Model = ExampleModel
}

UpdateController().setupUpdateRoute(routes: routes.grouped("example"))
```


### Patch

```swift
extension ExampleModel: PatchContentRepresentable {
    struct Patch: ValidatableContent {
        var foo: String?
        var bar: String?
    }

    func patch(_ content: Patch) throws {
        self.foo = content.foo ?? self.foo
        self.bar = content.bar ?? self.bar
    }
}

final class PatchController: PatchontentController {
    typealias Model = ExampleModel
}

PatchController().setupPatchRoute(routes: routes.grouped("example"))
```


### Delete

```swift
extension ExampleModel: DeleteContentRepresentable {}

final class DeleteController: DeleteContentController {
    typealias Model = ExampleModel
}

DeleteController().setupDeleteRoute(routes: routes.grouped("example"))

```


## License

[WTFPL](LICENSE) - Do what the fuck you want to.









