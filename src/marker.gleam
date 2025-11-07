import gleam/option
import icon
import map.{type LeafletMap}

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
    icon: option.Option(icon.LeafletIcon),
    popup: option.Option(String),
  )
}

/// Creates a new marker at the specified coordinates.
///
/// This is an internal function that interfaces with the JavaScript FFI.
/// Use `new_marker` instead for creating markers with metadata.
@external(javascript, "./gleaflet_ffi.js", "new_marker")
fn new_marker_internal(
  lat: Float,
  lng: Float,
  icon: option.Option(icon.LeafletIcon),
) -> LeafletMarkerInternal

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
  icon icon: option.Option(icon.LeafletIcon),
  popup popup: option.Option(String),
) {
  let internal = new_marker_internal(lat, lon, icon)
  LeafletMarker(internal:, lat:, lon:, name:, icon:, popup:)
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
///   |> marker.add_marker_to_map(marker)
/// ```
pub fn add_marker_to_map(map map: LeafletMap, marker marker: LeafletMarker) {
  case marker.popup {
    option.None -> add_marker_to_mapinternal(map, marker.internal)
    option.Some(popup) -> {
      let _ = add_marker_popup_internal(marker.internal, popup)
      add_marker_to_mapinternal(map, marker.internal)
    }
  }
}

/// Adds a marker to the map.
///
/// This is an internal function that interfaces with the JavaScript FFI.
/// Use `add_marker` instead for adding markers with popup support.
@external(javascript, "./gleaflet_ffi.js", "add_marker")
fn add_marker_to_mapinternal(
  map: LeafletMap,
  marker: LeafletMarkerInternal,
) -> LeafletMap

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
///   map.new_map("my-map-div")
///   |> marker.add_marker_to_map(marker)
///
/// // Later, remove the marker
/// let map_without_marker = gleaflet.remove_marker_from_map(map_with_marker, marker)
/// ```
pub fn remove_marker_from_map(map map: LeafletMap, marker marker: LeafletMarker) {
  remove_marker_from_map_internal(map, marker.internal)
}

/// Removes a marker from the map.
///
/// This is an internal function that interfaces with the JavaScript FFI.
@external(javascript, "./gleaflet_ffi.js", "remove_marker")
fn remove_marker_from_map_internal(
  map: LeafletMap,
  marker: LeafletMarkerInternal,
) -> Nil
