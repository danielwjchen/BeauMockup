import SwiftUI

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
        if configuration.isOn {
          Image(systemName: "checkmark")
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.green)
        }
      }
    }
    .buttonStyle(.plain)
  }
}
