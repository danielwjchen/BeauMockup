import SwiftUI

struct TitleBarView: View {
  @ObservedObject var vm: MockupViewModel

  var body: some View {
    ZStack {
      Color.panelBG

      HStack {
        // Traffic lights (decorative — real ones are managed by NSWindow)
        HStack(spacing: 8) {
          Circle().fill(Color(red: 1, green: 0.37, blue: 0.34)).frame(width: 13, height: 13)
          Circle().fill(Color(red: 1, green: 0.74, blue: 0.18)).frame(width: 13, height: 13)
          Circle().fill(Color(red: 0.16, green: 0.78, blue: 0.25)).frame(width: 13, height: 13)
        }
        .padding(.leading, 16)

        Spacer()

        Text("Mockup")
          .font(.system(size: 13, weight: .medium))
          .foregroundColor(.labelSecondary)

        Spacer()

        // Mirror traffic-light width for centering
        HStack(spacing: 8) {
          Circle().fill(Color.clear).frame(width: 13, height: 13)
          Circle().fill(Color.clear).frame(width: 13, height: 13)
          Circle().fill(Color.clear).frame(width: 13, height: 13)
        }
        .padding(.trailing, 16)
      }
    }
    .frame(height: 44)
  }
}
