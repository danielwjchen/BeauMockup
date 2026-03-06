import Foundation

struct Preset: Identifiable, Hashable {
  let id = UUID()
  var name: String
  var description: String
  var ratio: Double  // resulting size / original size
}

let allPresets: [Preset] = [
  Preset(name: "Web Optimized", description: "Balanced size/quality for web", ratio: 0.42),
  Preset(name: "Maximum Compression", description: "Smallest possible file size", ratio: 0.25),
  Preset(name: "High Quality", description: "Minimal quality loss", ratio: 0.72),
  Preset(name: "Archive", description: "Lossless compression", ratio: 0.85),
  Preset(name: "Mobile", description: "Optimized for mobile screens", ratio: 0.35),
]
