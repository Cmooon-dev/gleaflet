# Agent Guidelines for gleaflet

## Build/Test Commands
- `gleam test` - Run all tests
- `gleam test --module gleaflet_test` - Run single test module
- `gleam format --check src test` - Check formatting
- `gleam format src test` - Format code
- `gleam deps download` - Download dependencies

## Code Style Guidelines

### Imports
- Group imports by module: standard library first, then local modules
- Use qualified imports for external modules (e.g., `gleam/option`)
- Import specific types with `type` keyword when needed

### Types & Naming
- Use descriptive type names with `Leaflet` prefix for external types
- Public types use `pub type`, internal types omit `pub`
- Function names use snake_case
- Type constructors use PascalCase
- Use tuple types for coordinates: `#(Float, Float)`

### Documentation
- Document all public functions with `///` comments
- Include parameter descriptions and examples
- Use `## Parameters` and `## Example` sections
- Mark FFI functions with `@external` attribute

### Error Handling
- Use `option.Option` for optional values
- Use `assert` for unwrapping when you're certain the value exists
- Return `Result` types for operations that can fail

### FFI Pattern
- Keep internal FFI functions private
- Create public wrapper functions with proper Gleam types
- Separate internal types (`LeafletMarkerInternal`) from public ones (`LeafletMarker`)