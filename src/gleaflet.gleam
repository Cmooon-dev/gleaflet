import gleam/option

/// Internal representation of a Leaflet marker.
/// This type is used to interface with the JavaScript FFI and should not be created directly.
pub type LeafletMarkerInternal

/// A marker that can be placed on a Leaflet map.
///
/// Contains the internal marker reference along with its metadata including
/// latitude, longitude, name, and optional popup content.
///
/// ## Fields
///
/// * `internal` - The internal marker representation (FFI use only)
/// * `lat` - Latitude coordinate of the marker
/// * `lon` - Longitude coordinate of the marker
/// * `name` - Display name for the marker
/// * `popup` - Optional popup text that appears when the marker is clicked
pub type LeafletMarker {
  LeafletMarker(
    internal: LeafletMarkerInternal,
    lat: Float,
    lon: Float,
    name: String,
    popup: option.Option(String),
  )
}

/// Represents a Leaflet map instance.
/// This type is used as a handle to interact with map operations.
pub type LeafletMap

/// Configuration options for tile layers on a Leaflet map.
///
/// ## Fields
///
/// * `max_zoom` - Maximum zoom level for the tile layer
/// * `min_zoom` - Minimum zoom level for the tile layer
/// * `opacity` - Opacity of the tile layer (0.0 to 1.0)
/// * `attribution` - Attribution text to display on the map
pub type LeafletLayerOptions {
  LeafletLayerOptions(
    max_zoom: Int,
    min_zoom: Int,
    opacity: Float,
    attribution: String,
  )
}

/// Creates a new Leaflet map instance bound to a DOM element.
///
/// ## Parameters
///
/// * `map_id` - The ID of the HTML element where the map should be rendered
///
/// ## Returns
///
/// A new `LeafletMap` instance
///
/// ## Example
///
/// ```gleam
/// let map = new_map("my-map-div")
/// ```
@external(javascript, "./gleaflet_ffi.js", "new_map")
pub fn new_map(id map_id: String) -> LeafletMap

/// Sets the center point and zoom level of a Leaflet map.
///
/// ## Parameters
///
/// * `map` - The map instance to modify
/// * `lat` - Latitude coordinate for the map center
/// * `lon` - Longitude coordinate for the map center
/// * `zoom` - Zoom level (typically 0-18)
///
/// ## Returns
///
/// The updated `LeafletMap` instance for chaining
///
/// ## Example
///
/// ```gleam
/// let map =
///   new_map("my-map-div")
///   |> set_view(40.7128, -74.0060, 13)  // New York City, zoom level 13
/// ```
@external(javascript, "./gleaflet_ffi.js", "set_view")
pub fn set_view(
  map map: LeafletMap,
  lat lat: Float,
  lon lon: Float,
  zoom zoom: Int,
) -> LeafletMap

/// Adds a tile layer to a Leaflet map for rendering map tiles.
///
/// ## Parameters
///
/// * `map` - The map instance to add the layer to
/// * `url` - URL template for tile images (e.g., "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
/// * `options` - Configuration options for the tile layer
///
/// ## Returns
///
/// The updated `LeafletMap` instance for chaining
///
/// ## Example
///
/// ```gleam
/// let layer_options = LeafletLayerOptions(
///   max_zoom: 19,
///   min_zoom: 0,
///   opacity: 1.0,
///   attribution: "© OpenStreetMap contributors"
/// )
///
/// let map =
///   new_map("my-map-div")
///   |> add_tile_layer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", layer_options)
/// ```
@external(javascript, "./gleaflet_ffi.js", "add_tile_layer")
pub fn add_tile_layer(
  map map: LeafletMap,
  url url: String,
  options options: LeafletLayerOptions,
) -> LeafletMap

/// Creates a new marker at the specified coordinates.
///
/// This is an internal function that interfaces with the JavaScript FFI.
/// Use `new_marker` instead for creating markers with metadata.
@external(javascript, "./gleaflet_ffi.js", "new_marker")
fn new_marker_internal(lat: Float, lng: Float) -> LeafletMarkerInternal

/// Adds a marker to the map.
///
/// This is an internal function that interfaces with the JavaScript FFI.
/// Use `add_marker` instead for adding markers with popup support.
@external(javascript, "./gleaflet_ffi.js", "add_marker")
fn add_marker_internal(
  map: LeafletMap,
  marker: LeafletMarkerInternal,
) -> LeafletMap

/// Adds a popup to an existing marker.
///
/// This is an internal function that interfaces with the JavaScript FFI.
@external(javascript, "./gleaflet_ffi.js", "marker_add_popup")
fn add_marker_popup_internal(
  marker: LeafletMarkerInternal,
  popup: String,
) -> LeafletMarkerInternal

/// Creates a new marker with the specified properties.
///
/// ## Parameters
///
/// * `lat` - Latitude coordinate for the marker
/// * `lon` - Longitude coordinate for the marker
/// * `name` - Display name for the marker
/// * `popup` - Optional popup text that appears when the marker is clicked
///
/// ## Returns
///
/// A new `LeafletMarker` instance
///
/// ## Example
///
/// ```gleam
/// let marker = gleaflet.new_marker(40.7128, -74.0060, "New York", Some("The Big Apple"))
/// let marker_without_popup = gleaflet.new_marker(51.5074, -0.1278, "London", None)
/// ```
pub fn new_marker(
  lat lat: Float,
  lon lon: Float,
  name name: String,
  popup popup: option.Option(String),
) {
  let internal = new_marker_internal(lat, lon)
  LeafletMarker(internal, lat, lon, name, popup)
}

/// Adds a marker to the map.
///
/// Handles both markers with and without popup content.
/// If the marker has a popup, it will be attached to the marker before adding to the map.
///
/// ## Parameters
///
/// * `map` - The map instance to add the marker to
/// * `marker` - The marker to add
///
/// ## Example
///
/// ```gleam
/// let marker = gleaflet.new_marker(40.7128, -74.0060, "New York", Some("Welcome to NYC!"))
/// let map =
///   gleaflet.new_map("my-map-div")
///   |> gleaflet.add_marker(marker)
/// ```
pub fn add_marker(map map: LeafletMap, marker marker: LeafletMarker) {
  case marker.popup {
    option.None -> add_marker_internal(map, marker.internal)
    option.Some(popup) -> {
      let _ = add_marker_popup_internal(marker.internal, popup)
      add_marker_internal(map, marker.internal)
    }
  }
}

/// Removes a marker from the map.
///
/// ## Parameters
///
/// * `map` - The map instance to remove the marker from
/// * `marker` - The marker to remove
///
/// ## Example
///
/// ```gleam
/// let marker = gleaflet.new_marker(40.7128, -74.0060, "New York", None)
/// let map_with_marker =
///   gleaflet.new_map("my-map-div")
///   |> gleaflet.add_marker(marker)
///
/// // Later, remove the marker
/// let map_without_marker = gleaflet.remove_marker(map_with_marker, marker)
/// ```
pub fn remove_marker(map map: LeafletMap, marker marker: LeafletMarker) {
  remove_marker_internal(map, marker.internal)
}

/// Removes a marker from the map.
///
/// This is an internal function that interfaces with the JavaScript FFI.
@external(javascript, "./gleaflet_ffi.js", "remove_marker")
fn remove_marker_internal(map: LeafletMap, marker: LeafletMarkerInternal) -> Nil
