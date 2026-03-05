import SwiftUI

enum FileKind: String, CaseIterable {
  case pdf, image, video

  var label: String { rawValue.uppercased() }

  var accentColor: Color {
    switch self {
    case .pdf: return Color(red: 1.0, green: 0.23, blue: 0.19)
    case .image: return Color.brandLight
    case .video: return Color(red: 0.35, green: 0.34, blue: 0.84)
    }
  }
}
