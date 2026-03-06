import Foundation

func formatBytes(_ bytes: Int) -> String {
  let kb = Double(bytes) / 1_024
  let mb = kb / 1_024
  let gb = mb / 1_024
  if gb >= 1 { return String(format: "%.1f GB", gb) }
  if mb >= 1 { return String(format: "%.1f MB", mb) }
  if kb >= 1 { return String(format: "%.0f KB", kb) }
  return "\(bytes) B"
}
