import gleaflet/icon
import gleaflet/marker
import gleaflet/polyline
import gleam/option
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}

pub fn polyline_creation_test() {
  let points = [
    #(40.7128, -74.006),
    #(51.5074, -0.1278),
    #(48.8566, 2.3522),
  ]

  let polyline =
    polyline.new_polyline(points)
    |> polyline.with_color("#ff0000")
    |> polyline.with_weight(5)
    |> polyline.with_opacity(0.8)
    |> polyline.build()

  assert polyline.points == points
  assert polyline.options.color == "#ff0000"
  assert polyline.options.weight == 5
  assert polyline.options.opacity == 0.8
}

pub fn polyline_options_test() {
  let options =
    polyline.LeafletPolylineOptions(color: "#0000ff", weight: 3, opacity: 1.0)

  assert options.color == "#0000ff"
  assert options.weight == 3
  assert options.opacity == 1.0
}

pub fn marker_builder_basic_test() {
  let builder = marker.new_marker(40.7128, -74.006, "New York")

  assert builder.lat == 40.7128
  assert builder.lon == -74.006
  assert builder.name == "New York"
  assert builder.icon == option.None
  assert builder.popup == option.None
}

pub fn marker_builder_with_popup_test() {
  let builder =
    marker.new_marker(40.7128, -74.006, "New York")
    |> marker.with_popup("Welcome to NYC!")

  assert builder.popup == option.Some("Welcome to NYC!")
  assert builder.icon == option.None
}

pub fn marker_builder_with_icon_test() {
  let custom_icon =
    icon.LeafletIcon(
      icon_url: "/marker.png",
      shadow_url: "/shadow.png",
      icon_size: #(25, 41),
      shadow_size: #(41, 41),
      icon_anchor: #(12, 41),
      shadow_anchor: #(12, 41),
      popup_anchor: #(1, -34),
    )

  let builder =
    marker.new_marker(40.7128, -74.006, "New York")
    |> marker.with_icon(custom_icon)

  assert builder.icon == option.Some(custom_icon)
  assert builder.popup == option.None
}

pub fn marker_builder_complete_test() {
  let custom_icon =
    icon.LeafletIcon(
      icon_url: "/marker.png",
      shadow_url: "/shadow.png",
      icon_size: #(25, 41),
      shadow_size: #(41, 41),
      icon_anchor: #(12, 41),
      shadow_anchor: #(12, 41),
      popup_anchor: #(1, -34),
    )

  let marker =
    marker.new_marker(40.7128, -74.006, "New York")
    |> marker.with_popup("Welcome to NYC!")
    |> marker.with_icon(custom_icon)
    |> marker.build()

  assert marker.lat == 40.7128
  assert marker.lon == -74.006
  assert marker.name == "New York"
  assert marker.popup == option.Some("Welcome to NYC!")
  assert marker.icon == option.Some(custom_icon)
}

pub fn polyline_builder_basic_test() {
  let points = [
    #(40.7128, -74.006),
    #(51.5074, -0.1278),
  ]

  let builder = polyline.new_polyline(points)

  assert builder.points == points
  assert builder.color == option.None
  assert builder.weight == option.None
  assert builder.opacity == option.None
}

pub fn polyline_builder_with_color_test() {
  let points = [
    #(40.7128, -74.006),
    #(51.5074, -0.1278),
  ]

  let builder =
    polyline.new_polyline(points)
    |> polyline.with_color("#ff0000")

  assert builder.color == option.Some("#ff0000")
  assert builder.weight == option.None
  assert builder.opacity == option.None
}

pub fn polyline_builder_with_weight_test() {
  let points = [
    #(40.7128, -74.006),
    #(51.5074, -0.1278),
  ]

  let builder =
    polyline.new_polyline(points)
    |> polyline.with_weight(4)

  assert builder.weight == option.Some(4)
  assert builder.color == option.None
  assert builder.opacity == option.None
}

pub fn polyline_builder_with_opacity_test() {
  let points = [
    #(40.7128, -74.006),
    #(51.5074, -0.1278),
  ]

  let builder =
    polyline.new_polyline(points)
    |> polyline.with_opacity(0.8)

  assert builder.opacity == option.Some(0.8)
  assert builder.color == option.None
  assert builder.weight == option.None
}

pub fn polyline_builder_complete_test() {
  let points = [
    #(40.7128, -74.006),
    #(51.5074, -0.1278),
  ]

  let polyline =
    polyline.new_polyline(points)
    |> polyline.with_color("#ff0000")
    |> polyline.with_weight(4)
    |> polyline.with_opacity(0.8)
    |> polyline.build()

  assert polyline.points == points
  assert polyline.options.color == "#ff0000"
  assert polyline.options.weight == 4
  assert polyline.options.opacity == 0.8
}

pub fn polyline_builder_defaults_test() {
  let points = [
    #(40.7128, -74.006),
    #(51.5074, -0.1278),
  ]

  let polyline =
    polyline.new_polyline(points)
    |> polyline.build()

  assert polyline.points == points
  assert polyline.options.color == "#3388ff"
  // Default blue
  assert polyline.options.weight == 5
  // Default weight
  assert polyline.options.opacity == 0.5
  // Default opacity
}

pub fn icon_builder_basic_test() {
  let builder = icon.new_icon("/marker.png")

  assert builder.icon_url == "/marker.png"
  assert builder.shadow_url == option.None
  assert builder.icon_size == option.None
  assert builder.shadow_size == option.None
  assert builder.icon_anchor == option.None
  assert builder.shadow_anchor == option.None
  assert builder.popup_anchor == option.None
}

pub fn icon_builder_with_shadow_test() {
  let builder =
    icon.new_icon("/marker.png")
    |> icon.with_shadow("/shadow.png")

  assert builder.shadow_url == option.Some("/shadow.png")
  assert builder.icon_size == option.None
}

pub fn icon_builder_with_sizes_test() {
  let builder =
    icon.new_icon("/marker.png")
    |> icon.with_icon_size(#(25, 41))
    |> icon.with_shadow_size(#(41, 41))

  assert builder.icon_size == option.Some(#(25, 41))
  assert builder.shadow_size == option.Some(#(41, 41))
}

pub fn icon_builder_with_anchors_test() {
  let builder =
    icon.new_icon("/marker.png")
    |> icon.with_icon_anchor(#(12, 41))
    |> icon.with_shadow_anchor(#(12, 41))
    |> icon.with_popup_anchor(#(0, -34))

  assert builder.icon_anchor == option.Some(#(12, 41))
  assert builder.shadow_anchor == option.Some(#(12, 41))
  assert builder.popup_anchor == option.Some(#(0, -34))
}

pub fn icon_builder_complete_test() {
  let icon =
    icon.new_icon("/marker.png")
    |> icon.with_shadow("/shadow.png")
    |> icon.with_icon_size(#(25, 41))
    |> icon.with_shadow_size(#(41, 41))
    |> icon.with_icon_anchor(#(12, 41))
    |> icon.with_shadow_anchor(#(12, 41))
    |> icon.with_popup_anchor(#(0, -34))
    |> icon.build()

  assert icon.icon_url == "/marker.png"
  assert icon.shadow_url == "/shadow.png"
  assert icon.icon_size == #(25, 41)
  assert icon.shadow_size == #(41, 41)
  assert icon.icon_anchor == #(12, 41)
  assert icon.shadow_anchor == #(12, 41)
  assert icon.popup_anchor == #(0, -34)
}

pub fn icon_builder_defaults_test() {
  let icon =
    icon.new_icon("/marker.png")
    |> icon.build()

  assert icon.icon_url == "/marker.png"
  assert icon.shadow_url == ""
  // No shadow by default
  assert icon.icon_size == #(25, 41)
  // Default marker size
  assert icon.shadow_size == #(41, 41)
  // Default shadow size
  assert icon.icon_anchor == #(12, 41)
  // Bottom center
  assert icon.shadow_anchor == #(12, 41)
  // Bottom center
  assert icon.popup_anchor == #(0, -34)
  // Above marker
}

pub fn icon_builder_minimal_test() {
  let icon =
    icon.new_icon("/simple-marker.png")
    |> icon.build()

  assert icon.icon_url == "/simple-marker.png"
  assert icon.shadow_url == ""
  // No shadow
  assert icon.icon_size == #(25, 41)
  // Default size
}
