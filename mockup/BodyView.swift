import SwiftUI
import UniformTypeIdentifiers

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
