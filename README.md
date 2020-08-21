# cubarestapi
A lightweight package for using [Cuba`s REST-API](https://doc.cuba-platform.com/restapi-7.1/).

! Still raw (development in progress)

<a href="https://github.com/Deep27/cubarestapi/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-APACHE2.0-blue.svg?longCache=true&style=flat-square"></a>

## Get started
### Add dependency
```yaml
dependencies:
  cubarestapi: ^0.0.3
```

### Initialize Hive
Initialize Hive before using `cubarestapi` by calling asynchronous method:

(if you use it in flutter [hive_flutter](https://pub.dev/packages/hive_flutter))
```dart
Hive.initFlutter(); // `package:hive_flutter/hive_flutter.dart`
```

### Initialize CubaRestApi variables
Initialize `baseUrl`, `identifier`, and `secret` of `CubaRestApi` class before using it:
```dart
CubaRestApi.baseUrl = 'your url';       // http://localhost:8080/app by default
CubaRestApi.identifier = 'your client'; // client by default
CubaRestApi.secret = 'your secret';     // secret by default
```

### Example 
Very simple to use:
```dart
// ...
// authorization using Cuba's /rest/v2/oauth/token
child: OutlineButton(
    child: const Text('Login');
    onPressed: () async {
      oauth2.Client = await CubaRestApi.getAuthToken(usernameController.text, passwordController.text);
      // move to another screen or update ui
    }
),
// ...
```
```dart
// ...
// get some entities
List<Person> items = [];
void getPersons({String view, int limit, int offset, String sort}) {
    CubaRestApi.getEntities('testProject_Person',
                view: view, limit: limit, offset: offset, sort: sort)
            .then((result) {
        items.clear();
        (result as List).forEach((p) => items.add(Person.fromMap(p as Map)));
    }).catchError((e) {
        // add error to some stream controller to show flushbar with error or whatever
    });
}
// ...
```

## Copyright & License
This opensource project authorized by [Sberbank Technology](https://sber-tech.com/), and the license is [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0)

Author - [Roman Sotnichenko](https://github.com/Deep27/)
