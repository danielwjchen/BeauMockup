import SwiftUI

struct RunButton: View {
  @ObservedObject var vm: MockupViewModel
  @State private var isHovered = false

  var body: some View {
    Button {
      vm.run()
    } label: {
      HStack(spacing: 7) {
        if vm.isRunning {
          ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(0.6)
            .frame(width: 14, height: 14)
          Text("Processing…")
        } else if vm.isDone {
          Image(systemName: "checkmark")
            .font(.system(size: 12, weight: .bold))
          Text("Done!")
        } else {
          Image(systemName: "bolt.fill")
            .font(.system(size: 11, weight: .bold))
          Text("Run")
        }
      }
      .font(.system(size: 13, weight: .semibold))
      .foregroundColor(vm.canRun ? .white : .labelTertiary)
      .padding(.horizontal, 20)
      .padding(.vertical, 7)
      .background(
        Group {
          if vm.canRun {
            LinearGradient(
              colors: [.brandLight, .brandDark],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          } else {
            Color.white.opacity(0.07)
          }
        }
      )
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .shadow(color: vm.canRun ? Color.brandDark.opacity(0.45) : .clear, radius: 8, y: 3)
      .scaleEffect(isHovered && vm.canRun ? 1.02 : 1.0)
      .animation(.spring(response: 0.2), value: isHovered)
    }
    .buttonStyle(.plain)
    .disabled(!vm.canRun)
    .onHover { isHovered = $0 }
  }
}
