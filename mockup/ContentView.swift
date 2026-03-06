import SwiftUI

struct ContentView: View {
  @StateObject private var vm = MockupViewModel()

  var body: some View {
    ZStack {
      Color.appBG.ignoresSafeArea()

      VStack(spacing: 0) {
        ToolbarView(vm: vm)
        Divider().background(Color.separator)
        BodyView(vm: vm)
      }
    }
    .preferredColorScheme(.dark)
  }
}

#Preview {
  ContentView()
    .background(Color.appBG)
}
