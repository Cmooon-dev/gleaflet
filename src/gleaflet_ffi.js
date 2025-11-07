export function new_map(map_id) {
  let map = L.map(map_id);
  return map;
}

export function set_view(map, lat, lng, zoom) {
  map.setView([lat, lng], zoom);
  return map;
}

export function add_tile_layer(map, url, options) {
  console.log(map);
  L.tileLayer(url, options).addTo(map);
  return map;
}

export function add_marker(map, marker) {
  marker.addTo(map);
  return map;
}

export function new_marker(lat, lng) {
  return L.marker([lat, lng]);
}

export function marker_add_popup(marker, popup) {
  marker.bindPopup(popup);
  return marker;
}

export function remove_marker(map, marker) {
  map.removeLayer(marker);
}
