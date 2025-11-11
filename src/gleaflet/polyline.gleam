import gleaflet/map.{type LeafletMap}
import gleam/option

/// Internal representation of a Leaflet polyline.
/// This type is used to interface with the JavaScript FFI and should not be created directly.
pub type LeafletPolylineInternal

/// A polyline builder that can be configured with optional styling properties.
///
/// Use the builder pattern to create polylines with optional styling.
/// Start with `new_polyline` and chain `with_color`, `with_weight`, and `with_opacity`
/// functions, then call `build` to create the final polyline.
///
/// ## Fields
///
/// * `points` - List of latitude/longitude coordinate tuples
/// * `color` - Optional color of the polyline (CSS color string)
/// * `weight` - Optional width of the polyline in pixels
/// * `opacity` - Optional opacity of the polyline (0.0 to 1.0)
pub type PolylineBuilder {
  PolylineBuilder(
    points: List(#(Float, Float)),
    color: option.Option(String),
    weight: option.Option(Int),
    opacity: option.Option(Float),
  )
}

/// Configuration options for Leaflet polylines.
///
/// ## Fields
///
/// * `color` - Color of the polyline (CSS color string)
/// * `weight` - Width of the polyline in pixels
/// * `opacity` - Opacity of the polyline (0.0 to 1.0)
pub type LeafletPolylineOptions {
  LeafletPolylineOptions(color: String, weight: Int, opacity: Float)
}

/// A polyline that can be drawn on a Leaflet map.
///
/// Contains the internal polyline reference along with its metadata including
/// the list of coordinate points and styling options.
///
/// ## Fields
///
/// * `internal` - The internal polyline representation (FFI use only)
/// * `points` - List of latitude/longitude coordinate tuples
/// * `options` - Styling options for the polyline
pub type LeafletPolyline {
  LeafletPolyline(
    internal: LeafletPolylineInternal,
    points: List(#(Float, Float)),
    options: LeafletPolylineOptions,
  )
}

/// Creates a new polyline builder with the required points.
///
/// This is the starting point for the builder pattern. Use `with_color`,
/// `with_weight`, and `with_opacity` to add optional styling, then call `build`
/// to create the polyline.
///
/// ## Parameters
///
/// * `points` - List of latitude/longitude coordinate tuples
///
/// ## Example
///
/// ```gleam
/// let polyline = polyline.new_polyline([
///   #(40.7128, -74.0060),  // New York
///   #(51.5074, -0.1278),   // London
/// ])
/// |> polyline.with_color("#ff0000")
/// |> polyline.with_weight(5)
/// |> polyline.build()
/// ```
pub fn new_polyline(points points: List(#(Float, Float))) {
  PolylineBuilder(
    points: points,
    color: option.None,
    weight: option.None,
    opacity: option.None,
  )
}

/// Sets the color for the polyline builder.
///
/// ## Parameters
///
/// * `builder` - The polyline builder to add the color to
/// * `color` - Color of the polyline (CSS color string)
///
/// ## Example
///
/// ```gleam
/// let polyline = polyline.new_polyline(points)
///   |> polyline.with_color("#ff0000")
///   |> polyline.build()
/// ```
pub fn with_color(builder: PolylineBuilder, color: String) {
  PolylineBuilder(..builder, color: option.Some(color))
}

/// Sets the weight (line width) for the polyline builder.
///
/// ## Parameters
///
/// * `builder` - The polyline builder to add the weight to
/// * `weight` - Width of the polyline in pixels
///
/// ## Example
///
/// ```gleam
/// let polyline = polyline.new_polyline(points)
///   |> polyline.with_weight(5)
///   |> polyline.build()
/// ```
pub fn with_weight(builder: PolylineBuilder, weight: Int) {
  PolylineBuilder(..builder, weight: option.Some(weight))
}

/// Sets the opacity for the polyline builder.
///
/// ## Parameters
///
/// * `builder` - The polyline builder to add the opacity to
/// * `opacity` - Opacity of the polyline (0.0 to 1.0)
///
/// ## Example
///
/// ```gleam
/// let polyline = polyline.new_polyline(points)
///   |> polyline.with_opacity(0.8)
///   |> polyline.build()
/// ```
pub fn with_opacity(builder: PolylineBuilder, opacity: Float) {
  PolylineBuilder(..builder, opacity: option.Some(opacity))
}

/// Builds the final polyline from the builder configuration.
///
/// This creates the internal polyline representation with default values
/// for any unset options and returns the final `LeafletPolyline` that can
/// be added to maps.
///
/// Default values:
/// - color: "#3388ff" (Leaflet default blue)
/// - weight: 5 (Leaflet default)
/// - opacity: 0.5 (Leaflet default)
///
/// ## Parameters
///
/// * `builder` - The polyline builder to build
///
/// ## Example
///
/// ```gleam
/// let polyline = polyline.new_polyline(points)
///   |> polyline.with_color("#ff0000")
///   |> polyline.with_weight(5)
///   |> polyline.build()
/// ```
pub fn build(builder: PolylineBuilder) {
  let options =
    LeafletPolylineOptions(
      color: option.unwrap(builder.color, "#3388ff"),
      weight: option.unwrap(builder.weight, 5),
      opacity: option.unwrap(builder.opacity, 0.5),
    )

  let internal = new_polyline_internal(builder.points, options)
  LeafletPolyline(internal: internal, points: builder.points, options: options)
}

/// Adds a polyline to the map.
///
/// ## Parameters
///
/// * `map` - The map instance to add the polyline to
/// * `polyline` - The polyline to add
///
/// ## Example
///
/// ```gleam
/// let options = LeafletPolylineOptions(color: "#0000ff", weight: 3, opacity: 1.0)
/// let polyline = new_polyline([
///   #(40.7128, -74.0060),
///   #(51.5074, -0.1278),
/// ], options)
///
/// let map =
///   map.new_map("my-map-div")
///   |> add_polyline_to_map(polyline)
/// ```
pub fn add_polyline_to_map(
  map map: LeafletMap,
  polyline polyline: LeafletPolyline,
) {
  add_polyline_to_map_internal(map, polyline.internal)
}

/// Removes a polyline from the map.
///
/// ## Parameters
///
/// * `map` - The map instance to remove the polyline from
/// * `polyline` - The polyline to remove
///
/// ## Example
///
/// ```gleam
/// let polyline = new_polyline(points, options)
/// let map_with_polyline =
///   map.new_map("my-map-div")
///   |> add_polyline_to_map(polyline)
///
/// // Later, remove the polyline
/// remove_polyline_from_map(map_with_polyline, polyline)
/// ```
pub fn remove_polyline_from_map(
  map map: LeafletMap,
  polyline polyline: LeafletPolyline,
) {
  remove_polyline_from_map_internal(map, polyline.internal)
}

/// Creates a new polyline with the specified points and options.
///
/// This is an internal function that interfaces with the JavaScript FFI.
/// Use `new_polyline` instead for creating polylines with metadata.
@external(javascript, "./polyline_ffi.js", "new_polyline")
fn new_polyline_internal(
  points: List(#(Float, Float)),
  options: LeafletPolylineOptions,
) -> LeafletPolylineInternal

/// Adds a polyline to the map.
///
/// This is an internal function that interfaces with the JavaScript FFI.
/// Use `add_polyline_to_map` instead for adding polylines with proper metadata.
@external(javascript, "./polyline_ffi.js", "add_polyline_to_map")
fn add_polyline_to_map_internal(
  map: LeafletMap,
  polyline: LeafletPolylineInternal,
) -> LeafletMap

/// Removes a polyline from the map.
///
/// This is an internal function that interfaces with the JavaScript FFI.
/// Use `remove_polyline_from_map` instead for removing polylines with proper metadata.
@external(javascript, "./polyline_ffi.js", "remove_polyline_from_map")
fn remove_polyline_from_map_internal(
  map: LeafletMap,
  polyline: LeafletPolylineInternal,
) -> Nil
