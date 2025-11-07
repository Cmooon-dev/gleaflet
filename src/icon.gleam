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
