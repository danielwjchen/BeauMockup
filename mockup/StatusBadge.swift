import SwiftUI

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
