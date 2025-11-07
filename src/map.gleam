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

/// Adds a MapLibre GL style to the map
///
/// ## Parameters
///
/// * `map` - The map instance to add the style to
/// * `url` - URL to the MapLibre GL style JSON
@external(javascript, "./gleaflet_ffi.js", "add_maplibre_gl_style")
pub fn add_maplibre_gl_style(map map: LeafletMap, url url: String) -> LeafletMap
