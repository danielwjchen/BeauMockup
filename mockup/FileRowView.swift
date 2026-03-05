import SwiftUI

struct FileRowView: View {
  @ObservedObject var vm: MockupViewModel
  let file: FileItem
  let index: Int

  @State private var isHovered = false

  var compressedSize: Int {
    Int(Double(file.size) * vm.selectedPreset.ratio)
  }

  var body: some View {
    HStack(spacing: 10) {

      // Checkbox
      Toggle(
        "",
        isOn: Binding(
          get: { file.isChecked },
          set: { _ in vm.toggle(file) }
        )
      )
      .toggleStyle(GreenCheckboxStyle())
      .frame(width: 20)
      .disabled(vm.isRunning)

      // Thumbnail
      ThumbnailView(kind: file.kind)

      // Name + type
      VStack(alignment: .leading, spacing: 2) {
        Text(file.name)
          .font(.system(size: 13, weight: .medium))
          .foregroundColor(file.status == .done ? .labelTertiary : .labelPrimary)
          .strikethrough(file.status == .done, color: .labelTertiary)
          .lineLimit(1)
        Text(file.kind.label)
          .font(.system(size: 11))
          .foregroundColor(.labelTertiary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      // Size
      VStack(alignment: .leading, spacing: 2) {
        Text(formatBytes(file.size))
          .font(.system(size: 12, weight: .regular))
          .foregroundColor(.labelSecondary)
        if file.status == .done {
          Text("→ \(formatBytes(compressedSize))")
            .font(.system(size: 11))
            .foregroundColor(.brandLight)
        }
      }
      .frame(width: 110, alignment: .leading)
      .animation(.easeInOut(duration: 0.2), value: file.status)

      // Status
      StatusBadge(status: file.status, isChecked: file.isChecked)
        .frame(width: 90, alignment: .leading)

      // Remove
      Button {
        vm.remove(file)
      } label: {
        Image(systemName: "xmark")
          .font(.system(size: 11, weight: .medium))
          .foregroundColor(isHovered ? .labelSecondary : .labelTertiary)
          .frame(width: 20, height: 20)
          .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      .disabled(vm.isRunning)
      .frame(width: 28)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 9)
    .background(
      Group {
        if file.status == .processing {
          Color.brandLight.opacity(0.05)
        } else if index % 2 == 1 {
          Color.rowAlt
        } else {
          Color.clear
        }
      }
    )
    .opacity(file.isChecked ? 1.0 : 0.45)
    .animation(.easeInOut(duration: 0.15), value: file.isChecked)
    .onHover { isHovered = $0 }
  }
}
