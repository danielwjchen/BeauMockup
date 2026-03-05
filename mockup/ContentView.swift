//  ContentView.swift
import SwiftUI
import UniformTypeIdentifiers

enum OptimizeStatus {
  case pending, processing, done
}

struct FileItem: Identifiable {
  let id = UUID()
  var name: String
  var kind: FileKind
  var size: Int  // bytes
  var isChecked: Bool
  var status: OptimizeStatus = .pending
}

// MARK: - Presets

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

// MARK: - Helpers

func formatBytes(_ bytes: Int) -> String {
  let kb = Double(bytes) / 1_024
  let mb = kb / 1_024
  let gb = mb / 1_024
  if gb >= 1 { return String(format: "%.1f GB", gb) }
  if mb >= 1 { return String(format: "%.1f MB", mb) }
  if kb >= 1 { return String(format: "%.0f KB", kb) }
  return "\(bytes) B"
}

// MARK: - Mock Data

let mockFiles: [FileItem] = [
  FileItem(name: "product-brochure.pdf", kind: .pdf, size: 8_420_000, isChecked: true),
  FileItem(name: "hero-banner.png", kind: .image, size: 4_102_400, isChecked: true),
  FileItem(name: "team-photo.jpg", kind: .image, size: 6_553_600, isChecked: true),
  FileItem(name: "demo-reel.mp4", kind: .video, size: 209_715_200, isChecked: true),
  FileItem(name: "annual-report.pdf", kind: .pdf, size: 15_728_640, isChecked: false),
  FileItem(name: "logo-vector.png", kind: .image, size: 1_048_576, isChecked: true),
  FileItem(name: "onboarding-video.mp4", kind: .video, size: 524_288_000, isChecked: false),
  FileItem(name: "wireframes.pdf", kind: .pdf, size: 3_145_728, isChecked: true),
]

// MARK: - ContentView

struct ContentView: View {
  @StateObject private var vm = MockupViewModel()

  var body: some View {
    ZStack {
      Color.appBG.ignoresSafeArea()

      VStack(spacing: 0) {
        TitleBarView(vm: vm)
        ToolbarView(vm: vm)
        Divider().background(Color.separator)
        BodyView(vm: vm)
      }
    }
    .preferredColorScheme(.dark)
  }
}

// MARK: - Body / Drop Zone

struct BodyView: View {
  @ObservedObject var vm: MockupViewModel

  var body: some View {
    ZStack {
      Color.appBG

      if vm.files.isEmpty {
        DropZoneView(vm: vm)
      } else {
        FileListView(vm: vm)
      }
    }
    .onDrop(of: [UTType.fileURL], isTargeted: $vm.isDragging) { _ in
      vm.loadMockFiles()
      return true
    }
  }
}

// MARK: - Drop Zone

struct DropZoneView: View {
  @ObservedObject var vm: MockupViewModel

  var body: some View {
    VStack(spacing: 16) {
      ZStack {
        RoundedRectangle(cornerRadius: 16)
          .fill(Color.brandLight.opacity(0.08))
          .frame(width: 72, height: 72)
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color.brandLight.opacity(0.3), lineWidth: 1.5)
          .frame(width: 72, height: 72)
        Image(systemName: "arrow.up.doc.on.clipboard")
          .font(.system(size: 28, weight: .light))
          .foregroundColor(.brandLight)
      }

      VStack(spacing: 5) {
        Text("Drop files or folders here")
          .font(.system(size: 15, weight: .medium))
          .foregroundColor(.labelPrimary.opacity(0.75))
        Text("Supports PDF, PNG, JPG, HEIC, MP4, MOV")
          .font(.system(size: 13))
          .foregroundColor(.labelTertiary)
      }

      Button {
        vm.loadMockFiles()
      } label: {
        Text("or click to select files")
          .font(.system(size: 12))
          .foregroundColor(.labelTertiary)
          .padding(.horizontal, 14)
          .padding(.vertical, 5)
          .background(Color.white.opacity(0.05))
          .clipShape(RoundedRectangle(cornerRadius: 6))
          .overlay(
            RoundedRectangle(cornerRadius: 6)
              .stroke(Color.white.opacity(0.08), lineWidth: 1)
          )
      }
      .buttonStyle(.plain)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .stroke(
          vm.isDragging ? Color.brandLight : Color.white.opacity(0.1),
          style: StrokeStyle(lineWidth: 2, dash: [6])
        )
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(vm.isDragging ? Color.brandLight.opacity(0.05) : Color.clear)
        )
        .padding(20)
    )
    .animation(.easeInOut(duration: 0.15), value: vm.isDragging)
  }
}

// MARK: - File Row

// MARK: - Thumbnail

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

// MARK: - Status Badge

struct StatusBadge: View {
  let status: OptimizeStatus
  let isChecked: Bool

  @State private var dotOpacity: Double = 1.0

  var body: some View {
    Group {
      switch status {
      case .processing:
        HStack(spacing: 5) {
          Circle()
            .fill(Color.brandLight)
            .frame(width: 7, height: 7)
            .opacity(dotOpacity)
            .onAppear {
              withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                dotOpacity = 0.2
              }
            }
          Text("Working")
            .font(.system(size: 11))
            .foregroundColor(.brandLight)
        }

      case .done:
        HStack(spacing: 4) {
          ZStack {
            Circle()
              .fill(Color.green.opacity(0.15))
              .frame(width: 16, height: 16)
            Image(systemName: "checkmark")
              .font(.system(size: 8, weight: .bold))
              .foregroundColor(.green)
          }
          Text("Done")
            .font(.system(size: 11))
            .foregroundColor(.green)
        }

      case .pending:
        Text(isChecked ? "Queued" : "—")
          .font(.system(size: 11))
          .foregroundColor(.labelTertiary)
      }
    }
    .transition(.opacity.combined(with: .scale(scale: 0.9)))
    .animation(.spring(response: 0.3), value: status)
  }
}

// MARK: - Custom Green Checkbox

struct GreenCheckboxStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button {
      configuration.isOn.toggle()
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 4)
          .fill(
            configuration.isOn
              ? LinearGradient(
                colors: [.brandLight, .brandDark], startPoint: .top, endPoint: .bottom)
              : LinearGradient(
                colors: [Color.white.opacity(0.08), Color.white.opacity(0.05)], startPoint: .top,
                endPoint: .bottom)
          )
          .frame(width: 16, height: 16)

        RoundedRectangle(cornerRadius: 4)
          .stroke(configuration.isOn ? Color.brandDark : Color.white.opacity(0.15), lineWidth: 1)
          .frame(width: 16, height: 16)

        if configuration.isOn {
          Image(systemName: "checkmark")
            .font(.system(size: 9, weight: .bold))
            .foregroundColor(.white)
        }
      }
      .animation(.spring(response: 0.2), value: configuration.isOn)
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  ContentView()
}
