export function new_polyline(points, options) {
  // Convert Gleam list of tuples to Leaflet's expected format
  const latlngs = points.toArray().map(point => [point[0], point[1]]);
  
  const leafletOptions = {
    color: options.color,
    weight: options.weight,
    opacity: options.opacity
  };
  
  let polyline = L.polyline(latlngs, leafletOptions);
  return polyline;
}

export function add_polyline_to_map(map, polyline) {
  polyline.addTo(map);
  return map;
}

export function remove_polyline_from_map(map, polyline) {
  map.removeLayer(polyline);
}
 
