# Custom Templates

Place `.template` files here to override default code generation templates.

## Available Template Names

| Name | Used For |
|------|----------|
| `repository_interface` | Repository abstract class |
| `repository_impl` | Repository implementation |
| `remote_datasource` | Remote data source |
| `bloc` | BLoC class |
| `bloc_event` | BLoC events |
| `bloc_state` | BLoC states |
| `cubit` | Cubit class |
| `cubit_state` | Cubit states |
| `model` | Data model |
| `page` | Page widget |

## Placeholders

Use these placeholders in your templates:

- `{{className}}` — PascalCase name (e.g., `UserProfile`)
- `{{fileName}}` — snake_case name (e.g., `user_profile`)
- `{{packageName}}` — Package name from pubspec.yaml

## Example

Create `repository_interface.template`:

```dart
abstract class I{{className}}Repository {
  Future<List<{{className}}Entity>> getAll();
  Future<{{className}}Entity?> getById(String id);
  Future<void> create({{className}}Entity entity);
  Future<void> update({{className}}Entity entity);
  Future<void> delete(String id);
}
```
