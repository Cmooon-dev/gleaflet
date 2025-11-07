export function new_map(map_id) {
  let map = L.map(map_id);
  return map;
}

export function set_view(map, lat, lng, zoom) {
  map.setView([lat, lng], zoom);
  return map;
}

export function add_tile_layer(map, url, options) {
  L.tileLayer(url, options).addTo(map);
  return map;
}

export function add_marker(map, marker) {
  marker.addTo(map);
  return map;
}

export function new_marker(lat, lng, icon) {
  if (icon[0] != undefined) {
    let icon_data = icon[0];
    icon = L.icon({
      iconUrl: icon_data.icon_url,
      shadowUrl: icon_data.shadow_url,

      iconSize: icon_data.icon_size,
      shadowSize: icon_data.shadow_size,
      iconAnchor: icon_data.icon_anchor,
      shadowAnchor: icon_data.shadow_anchor,
      popupAnchor: icon_data.popup_anchor,
    });
    return L.marker([lat, lng], { icon: icon });
  }
  return L.marker([lat, lng]);
}

export function marker_add_popup(marker, popup) {
  marker.bindPopup(popup);
  return marker;
}

export function remove_marker(map, marker) {
  map.removeLayer(marker);
}
