import gleaflet/polyline
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

  let options =
    polyline.LeafletPolylineOptions(color: "#ff0000", weight: 5, opacity: 0.8)

  let polyline = polyline.new_polyline(points, options)

  assert polyline.points == points
  assert polyline.options == options
}

pub fn polyline_options_test() {
  let options =
    polyline.LeafletPolylineOptions(color: "#0000ff", weight: 3, opacity: 1.0)

  assert options.color == "#0000ff"
  assert options.weight == 3
  assert options.opacity == 1.0
}
