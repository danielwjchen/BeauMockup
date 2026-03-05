import SwiftUI

struct FileListView: View {
  @ObservedObject var vm: MockupViewModel

  var body: some View {
    VStack(spacing: 0) {
      // Column Headers
      HStack(spacing: 10) {
        Toggle(
          "",
          isOn: Binding(
            get: { vm.allChecked },
            set: { _ in vm.toggleAll() }
          )
        )
        .toggleStyle(.checkbox)
        .frame(width: 20)

        Color.clear.frame(width: 52)

        Text("Name")
          .frame(maxWidth: .infinity, alignment: .leading)

        Text("Size")
          .frame(width: 110, alignment: .leading)

        Text("Status")
          .frame(width: 90, alignment: .leading)

        Color.clear.frame(width: 28)
      }
      .font(.system(size: 11, weight: .semibold))
      .foregroundColor(.labelTertiary)
      .textCase(.uppercase)
      .tracking(0.5)
      .padding(.horizontal, 16)
      // we no longer add vertical padding – the header will size itself to its text content
      .background(Color.toolbarBG)

      Divider().background(Color.separator)

      // Rows
      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(Array(vm.files.enumerated()), id: \.element.id) { index, file in
            FileRowView(vm: vm, file: file, index: index)
            if index < vm.files.count - 1 {
              Divider()
                .background(Color.separator)
                .padding(.leading, 16)
            }
          }
        }
      }

      Divider().background(Color.separator)

      // Footer
      HStack {
        Text("\(vm.files.count) files · \(formatBytes(vm.files.reduce(0) { $0 + $1.size })) total")
          .font(.system(size: 12))
          .foregroundColor(.labelTertiary)

        Spacer()

        Button {
          vm.loadMockFiles()
        } label: {
          Text("+ Add more")
            .font(.system(size: 12))
            .foregroundColor(vm.isRunning ? .labelTertiary : .brandLight)
        }
        .buttonStyle(.plain)
        .disabled(vm.isRunning)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 9)
      .background(Color.toolbarBG)
    }
  }
}

#Preview {
  FileListView(vm: MockupViewModel())
    .background(Color.appBG)
}
