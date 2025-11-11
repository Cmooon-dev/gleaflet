import gleaflet/map.{type LeafletMap}

/// Internal representation of a Leaflet polyline.
/// This type is used to interface with the JavaScript FFI and should not be created directly.
pub type LeafletPolylineInternal

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

/// Creates a new polyline with the specified points and options.
///
/// ## Parameters
///
/// * `points` - List of latitude/longitude coordinate tuples
/// * `options` - Styling options for the polyline
///
/// ## Example
///
/// ```gleam
/// let options = LeafletPolylineOptions(color: "#ff0000", weight: 5, opacity: 0.8)
/// let polyline = new_polyline([
///   #(40.7128, -74.0060),  // New York
///   #(51.5074, -0.1278),   // London
/// ], options)
/// ```
pub fn new_polyline(
  points points: List(#(Float, Float)),
  options options: LeafletPolylineOptions,
) {
  let internal = new_polyline_internal(points, options)
  LeafletPolyline(internal:, points:, options:)
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
