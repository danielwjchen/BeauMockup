import SwiftUI

struct ToolbarView: View {
  @ObservedObject var vm: MockupViewModel
  @State private var showPresetMenu = false

  var body: some View {
    ZStack {
      Color.toolbarBG

      HStack(spacing: 10) {

        // Preset Dropdown
        Menu {
          ForEach(allPresets) { preset in
            Button {
              vm.selectedPreset = preset
            } label: {
              HStack {
                Text(preset.name)
                if preset.id == vm.selectedPreset.id {
                  Spacer()
                  Image(systemName: "checkmark")
                }
              }
            }
          }
        } label: {
          HStack(spacing: 8) {
            Image(systemName: "slider.horizontal.3")
              .font(.system(size: 13))
            Text(vm.selectedPreset.name)
              .font(.system(size: 13, weight: .medium))
            Image(systemName: "chevron.down")
              .font(.system(size: 10, weight: .semibold))
              .foregroundColor(.labelTertiary)
          }
          .foregroundColor(.labelPrimary)
          .padding(.horizontal, 12)
          .padding(.vertical, 7)
          .background(Color.white.opacity(0.08))
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.white.opacity(0.1), lineWidth: 1)
          )
        }
        .menuStyle(.borderlessButton)
        .fixedSize()

        // Select Folder
        Button {
          vm.loadMockFiles()
        } label: {
          HStack(spacing: 6) {
            Image(systemName: "folder")
              .font(.system(size: 13))
            Text("Select Folder")
              .font(.system(size: 13, weight: .medium))
          }
          .foregroundColor(.labelPrimary.opacity(0.85))
          .padding(.horizontal, 14)
          .padding(.vertical, 7)
          .background(Color.white.opacity(0.08))
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.white.opacity(0.1), lineWidth: 1)
          )
        }
        .buttonStyle(.plain)

        Spacer()

        // Savings Pill
        if !vm.files.isEmpty {
          HStack(spacing: 6) {
            Text("~\(formatBytes(vm.estimatedSavings)) saved")
              .font(.system(size: 12, weight: .medium))
              .foregroundColor(.brandLight)
            Text("·")
              .foregroundColor(.labelTertiary)
            Text("\(vm.checkedFiles.count) selected")
              .font(.system(size: 12))
              .foregroundColor(.labelSecondary)
          }
          .padding(.horizontal, 12)
          .padding(.vertical, 5)
          .background(Color.brandLight.opacity(0.1))
          .clipShape(Capsule())
          .overlay(Capsule().stroke(Color.brandLight.opacity(0.2), lineWidth: 1))
          .animation(.easeInOut(duration: 0.2), value: vm.estimatedSavings)
        }

        // Run Button
        RunButton(vm: vm)
      }
      .padding(.horizontal, 16)
    }
    .frame(height: 50)
  }
}
