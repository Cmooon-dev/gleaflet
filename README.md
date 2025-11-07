# gleaflet

[![Package Version](https://img.shields.io/hexpm/v/gleaflet)](https://hex.pm/packages/gleaflet)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gleaflet/)

A simple wrapper around the Leaflet.js library

Gleaflet is still very early days. It currently supports:
- Creating a map
- Adding markers
- Adding popups
- Adding layers

I will add features as I need them, but I'm open to contributions.
Please feel free to open an issue if you'd like to see more features added.

## Installation

```sh
gleam add gleaflet@1
```

Usage with lustre:
```gleam
import gleaflet
import gleam/list
import gleam/option
import lustre
import lustre/attribute
import lustre/effect
import lustre/element/html
import lustre/event

// Create your basic lustre messages
type Message {
  MapMounted(gleaflet.LeafletMap)
  AddMarker(gleaflet.LeafletMarker)
  RemoveMarker(String)
}

type Model {
  Model(
    map: option.Option(gleaflet.LeafletMap),
    markers: List(gleaflet.LeafletMarker),
  )
}

pub fn main() {
  let app = lustre.application(init, update, view)

  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

fn init(_) -> #(Model, effect.Effect(Message)) {
  let model = Model(map: option.None, markers: [])

  // Create an effect that mounts the map
  // It's important to run this after the first paint, so that the div with the map is present
  let mount_map =
    effect.after_paint(fn(dispatch, _root_element) {
      let map =
        gleaflet.new_map("map")
        |> gleaflet.add_tile_layer(
          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          gleaflet.LeafletLayerOptions(
            max_zoom: 19,
            min_zoom: 1,
            opacity: 1.0,
            attribution: "© OpenStreetMap contributors",
          ),
        )
        |> gleaflet.set_view(52.526876, 13.407703, 19)

      // Create a marker that should be preset on from the start
      let restaurant_marker =
        gleaflet.new_marker(
          52.526876,
          13.407703,
          "shiso",
          option.Some("Tasty Burgers in Berlin"),
        )

      // Tell the runtime that the map is created
      dispatch(MapMounted(map))

      // Tell the runtime that the marker is created
      dispatch(AddMarker(restaurant_marker))

      Nil
    })

  #(model, mount_map)
}

fn update(model: Model, message: Message) -> #(Model, effect.Effect(Message)) {
  let model = case message {
    MapMounted(map) -> Model(..model, map: option.Some(map))
    AddMarker(marker) -> {
      let assert option.Some(map) = model.map
      // Render this new marker on the map
      gleaflet.add_marker(map, marker)
      Model(..model, markers: list.append(model.markers, [marker]))
    }
    RemoveMarker(name) -> {
      let assert option.Some(map) = model.map

      // Find the marker by its name
      let assert Ok(marker) =
        list.find(model.markers, fn(marker) { marker.name == name })

      // Remove the market from the map
      gleaflet.remove_marker(map, marker)

      Model(
        ..model,
        // Remove the marker from the list
        markers: list.filter(model.markers, fn(marker) { marker.name != name }),
      )
    }
  }

  let effect = effect.none()

  #(model, effect)
}

fn view(model: Model) {
  html.main([], [
    // Create the div with the map id
    // This is where Leaflet will mount the map to
    html.div(
      [
        attribute.id("map"),
        attribute.styles([#("width", "500px"), #("height", "500px")]),
      ],
      [],
    ),

    html.button(
      [
        attribute.disabled(list.length(model.markers) >= 2),
        event.on_click({
          // Create a new marker that will be rendered on the map
          // Note the name, as we will use it to delete the marker later
          let marker =
            gleaflet.new_marker(
              52.526458,
              13.407778,
              "dump_ling",
              option.Some("Another tasty restaurant"),
            )
          AddMarker(marker)
        }),
      ],
      [html.text("Add another marker")],
    ),
    html.button(
      [
        attribute.disabled(list.length(model.markers) < 2),
        // Remove the marker that be created before
        event.on_click({ RemoveMarker("dump_ling") }),
      ],
      [html.text("Remove other marker")],
    ),
  ])
}
```

Further documentation can be found at <https://hexdocs.pm/gleaflet>.
