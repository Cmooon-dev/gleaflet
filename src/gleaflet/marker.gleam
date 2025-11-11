import gleaflet/icon
import gleaflet/map.{type LeafletMap}
import gleam/option

/// Internal representation of a Leaflet marker.
/// This type is used to interface with the JavaScript FFI and should not be created directly.
pub type LeafletMarkerInternal

/// A marker builder that can be configured with optional properties.
///
/// Use the builder pattern to create markers with optional popup and icon.
/// Start with `new_marker` and chain `with_popup` and `with_icon` functions,
/// then call `build` to create the final marker.
///
/// ## Fields
///
/// * `lat` - Latitude coordinate of the marker
/// * `lon` - Longitude coordinate of the marker
/// * `name` - Display name for the marker
/// * `icon` - Optional icon for the marker
/// * `popup` - Optional popup text that appears when the marker is clicked
pub type MarkerBuilder {
  MarkerBuilder(
    lat: Float,
    lon: Float,
    name: String,
    icon: option.Option(icon.LeafletIcon),
    popup: option.Option(String),
  )
}

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

/// Creates a new marker builder with the required coordinates and name.
///
/// This is the starting point for the builder pattern. Use `with_popup` and
/// `with_icon` to add optional properties, then call `build` to create the marker.
///
/// ## Parameters
///
/// * `lat` - Latitude coordinate for the marker
/// * `lon` - Longitude coordinate for the marker
/// * `name` - Display name for the marker
///
/// ## Example
///
/// ```gleam
/// let marker = marker.new_marker(40.7128, -74.0060, "New York")
///   |> marker.with_popup("The Big Apple")
///   |> marker.build()
/// ```
pub fn new_marker(lat lat: Float, lon lon: Float, name name: String) {
  MarkerBuilder(lat:, lon:, name:, icon: option.None, popup: option.None)
}

/// Adds a popup to the marker builder.
///
/// ## Parameters
///
/// * `builder` - The marker builder to add the popup to
/// * `popup` - Popup text that appears when the marker is clicked
///
/// ## Example
///
/// ```gleam
/// let marker = marker.new_marker(40.7128, -74.0060, "New York")
///   |> marker.with_popup("Welcome to NYC!")
///   |> marker.build()
/// ```
pub fn with_popup(builder: MarkerBuilder, popup: String) {
  MarkerBuilder(..builder, popup: option.Some(popup))
}

/// Adds an icon to the marker builder.
///
/// ## Parameters
///
/// * `builder` - The marker builder to add the icon to
/// * `icon` - Icon to use for the marker
///
/// ## Example
///
/// ```gleam
/// let custom_icon = icon.LeafletIcon(
///   icon_url: "/marker.png",
///   shadow_url: "/shadow.png",
///   icon_size: #(25, 41),
///   shadow_size: #(41, 41),
///   icon_anchor: #(12, 41),
///   shadow_anchor: #(12, 41),
///   popup_anchor: #(1, -34),
/// )
///
/// let marker = marker.new_marker(40.7128, -74.0060, "New York")
///   |> marker.with_icon(custom_icon)
///   |> marker.build()
/// ```
pub fn with_icon(builder: MarkerBuilder, icon: icon.LeafletIcon) {
  MarkerBuilder(..builder, icon: option.Some(icon))
}

/// Builds the final marker from the builder configuration.
///
/// This creates the internal marker representation and returns the final
/// `LeafletMarker` that can be added to maps.
///
/// ## Parameters
///
/// * `builder` - The marker builder to build
///
/// ## Example
///
/// ```gleam
/// let marker = marker.new_marker(40.7128, -74.0060, "New York")
///   |> marker.with_popup("Welcome to NYC!")
///   |> marker.build()
/// ```
pub fn build(builder: MarkerBuilder) {
  let internal = new_marker_internal(builder.lat, builder.lon, builder.icon)
  LeafletMarker(
    internal: internal,
    lat: builder.lat,
    lon: builder.lon,
    name: builder.name,
    icon: builder.icon,
    popup: builder.popup,
  )
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
/// let marker = marker.new_marker(40.7128, -74.0060, "New York")
///   |> marker.with_popup("Welcome to NYC!")
///   |> marker.build()
/// let map =
///   map.new_map("my-map-div")
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
/// let marker = marker.new_marker(40.7128, -74.0060, "New York")
///   |> marker.build()
/// let map_with_marker =
///   map.new_map("my-map-div")
///   |> marker.add_marker_to_map(marker)
///
/// // Later, remove the marker
/// let map_without_marker = marker.remove_marker_from_map(map_with_marker, marker)
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
