import gleam/option

/// An icon builder that can be configured with optional properties.
///
/// Use the builder pattern to create icons with optional shadow and anchor properties.
/// Start with `new_icon` and chain `with_shadow`, `with_icon_size`, `with_icon_anchor`,
/// `with_shadow_anchor`, and `with_popup_anchor` functions, then call `build` to create the final icon.
///
/// ## Fields
///
/// * `icon_url` - URL of the icon image (required)
/// * `shadow_url` - Optional URL of the shadow image
/// * `icon_size` - Optional size of the icon (width, height)
/// * `shadow_size` - Optional size of the shadow (width, height)
/// * `icon_anchor` - Optional point of the icon which corresponds to marker's location
/// * `shadow_anchor` - Optional point of the shadow which corresponds to marker's location
/// * `popup_anchor` - Optional point from which popup should open relative to icon anchor
pub type IconBuilder {
  IconBuilder(
    icon_url: String,
    shadow_url: option.Option(String),
    icon_size: option.Option(#(Int, Int)),
    shadow_size: option.Option(#(Int, Int)),
    icon_anchor: option.Option(#(Int, Int)),
    shadow_anchor: option.Option(#(Int, Int)),
    popup_anchor: option.Option(#(Int, Int)),
  )
}

/// LeafletIcon is a struct that represents a Leaflet icon.
pub type LeafletIcon {
  LeafletIcon(
    icon_url: String,
    shadow_url: String,
    // size of the icon
    icon_size: #(Int, Int),
    // size of the shadow
    shadow_size: #(Int, Int),
    // point of the icon which will correspond to marker's location
    icon_anchor: #(Int, Int),
    // the same for the shadow
    shadow_anchor: #(Int, Int),
    // point from which the popup should open relative to the iconAnchor
    popup_anchor: #(Int, Int),
  )
}

/// Creates a new icon builder with the required icon URL.
///
/// This is the starting point for the builder pattern. Use the various `with_*`
/// functions to add optional properties, then call `build` to create the icon.
///
/// ## Parameters
///
/// * `icon_url` - URL of the icon image
///
/// ## Example
///
/// ```gleam
/// let icon = icon.new_icon("/marker.png")
///   |> icon.with_icon_size(#(25, 41))
///   |> icon.with_icon_anchor(#(12, 41))
///   |> icon.build()
/// ```
pub fn new_icon(icon_url: String) {
  IconBuilder(
    icon_url: icon_url,
    shadow_url: option.None,
    icon_size: option.None,
    shadow_size: option.None,
    icon_anchor: option.None,
    shadow_anchor: option.None,
    popup_anchor: option.None,
  )
}

/// Sets the shadow URL for the icon builder.
///
/// ## Parameters
///
/// * `builder` - The icon builder to add the shadow URL to
/// * `shadow_url` - URL of the shadow image
///
/// ## Example
///
/// ```gleam
/// let icon = icon.new_icon("/marker.png")
///   |> icon.with_shadow("/shadow.png")
///   |> icon.build()
/// ```
pub fn with_shadow(builder: IconBuilder, shadow_url: String) {
  IconBuilder(..builder, shadow_url: option.Some(shadow_url))
}

/// Sets the icon size for the icon builder.
///
/// ## Parameters
///
/// * `builder` - The icon builder to add the icon size to
/// * `icon_size` - Size of the icon as (width, height) tuple
///
/// ## Example
///
/// ```gleam
/// let icon = icon.new_icon("/marker.png")
///   |> icon.with_icon_size(#(25, 41))
///   |> icon.build()
/// ```
pub fn with_icon_size(builder: IconBuilder, icon_size: #(Int, Int)) {
  IconBuilder(..builder, icon_size: option.Some(icon_size))
}

/// Sets the shadow size for the icon builder.
///
/// ## Parameters
///
/// * `builder` - The icon builder to add the shadow size to
/// * `shadow_size` - Size of the shadow as (width, height) tuple
///
/// ## Example
///
/// ```gleam
/// let icon = icon.new_icon("/marker.png")
///   |> icon.with_shadow("/shadow.png")
///   |> icon.with_shadow_size(#(41, 41))
///   |> icon.build()
/// ```
pub fn with_shadow_size(builder: IconBuilder, shadow_size: #(Int, Int)) {
  IconBuilder(..builder, shadow_size: option.Some(shadow_size))
}

/// Sets the icon anchor for the icon builder.
///
/// The icon anchor is the point of the icon which will correspond to marker's location.
///
/// ## Parameters
///
/// * `builder` - The icon builder to add the icon anchor to
/// * `icon_anchor` - Anchor point as (x, y) tuple
///
/// ## Example
///
/// ```gleam
/// let icon = icon.new_icon("/marker.png")
///   |> icon.with_icon_size(#(25, 41))
///   |> icon.with_icon_anchor(#(12, 41))
///   |> icon.build()
/// ```
pub fn with_icon_anchor(builder: IconBuilder, icon_anchor: #(Int, Int)) {
  IconBuilder(..builder, icon_anchor: option.Some(icon_anchor))
}

/// Sets the shadow anchor for the icon builder.
///
/// The shadow anchor is the point of the shadow which will correspond to marker's location.
///
/// ## Parameters
///
/// * `builder` - The icon builder to add the shadow anchor to
/// * `shadow_anchor` - Shadow anchor point as (x, y) tuple
///
/// ## Example
///
/// ```gleam
/// let icon = icon.new_icon("/marker.png")
///   |> icon.with_shadow("/shadow.png")
///   |> icon.with_shadow_anchor(#(12, 41))
///   |> icon.build()
/// ```
pub fn with_shadow_anchor(builder: IconBuilder, shadow_anchor: #(Int, Int)) {
  IconBuilder(..builder, shadow_anchor: option.Some(shadow_anchor))
}

/// Sets the popup anchor for the icon builder.
///
/// The popup anchor is the point from which the popup should open relative to the icon anchor.
///
/// ## Parameters
///
/// * `builder` - The icon builder to add the popup anchor to
/// * `popup_anchor` - Popup anchor point as (x, y) tuple
///
/// ## Example
///
/// ```gleam
/// let icon = icon.new_icon("/marker.png")
///   |> icon.with_popup_anchor(#(0, -34))
///   |> icon.build()
/// ```
pub fn with_popup_anchor(builder: IconBuilder, popup_anchor: #(Int, Int)) {
  IconBuilder(..builder, popup_anchor: option.Some(popup_anchor))
}

/// Builds the final icon from the builder configuration.
///
/// This creates the final `LeafletIcon` with sensible defaults for any unset properties.
///
/// Default values:
/// - shadow_url: "" (empty string, no shadow)
/// - icon_size: #(25, 41) (typical Leaflet marker size)
/// - shadow_size: #(41, 41) (typical Leaflet shadow size)
/// - icon_anchor: #(12, 41) (bottom center of typical marker)
/// - shadow_anchor: #(12, 41) (bottom center of typical shadow)
/// - popup_anchor: #(0, -34) (above the marker)
///
/// ## Parameters
///
/// * `builder` - The icon builder to build
///
/// ## Example
///
/// ```gleam
/// let icon = icon.new_icon("/marker.png")
///   |> icon.with_icon_size(#(25, 41))
///   |> icon.with_icon_anchor(#(12, 41))
///   |> icon.build()
/// ```
pub fn build(builder: IconBuilder) {
  LeafletIcon(
    icon_url: builder.icon_url,
    shadow_url: option.unwrap(builder.shadow_url, ""),
    icon_size: option.unwrap(builder.icon_size, #(25, 41)),
    shadow_size: option.unwrap(builder.shadow_size, #(41, 41)),
    icon_anchor: option.unwrap(builder.icon_anchor, #(12, 41)),
    shadow_anchor: option.unwrap(builder.shadow_anchor, #(12, 41)),
    popup_anchor: option.unwrap(builder.popup_anchor, #(0, -34)),
  )
}
