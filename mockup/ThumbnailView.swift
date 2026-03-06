import SwiftUI

struct ThumbnailView: View {
  let kind: FileKind

  var iconName: String {
    switch kind {
    case .pdf: return "doc.richtext"
    case .image: return "photo"
    case .video: return "film"
    }
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8)
        .fill(kind.accentColor.opacity(0.12))
      RoundedRectangle(cornerRadius: 8)
        .stroke(kind.accentColor.opacity(0.25), lineWidth: 1)
      VStack(spacing: 3) {
        Image(systemName: iconName)
          .font(.system(size: 16, weight: .light))
          .foregroundColor(kind.accentColor)
        Text(kind.label)
          .font(.system(size: 7, weight: .bold))
          .foregroundColor(kind.accentColor)
      }
    }
    .frame(width: 52, height: 52)
  }
}
