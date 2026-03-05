import Combine
import SwiftUI

@MainActor
class MockupViewModel: ObservableObject {

  @Published var files: [FileItem] = []
  @Published var selectedPreset: Preset = allPresets[0]
  @Published var isRunning = false
  @Published var isDone = false
  @Published var isDragging = false

  var checkedFiles: [FileItem] { files.filter(\.isChecked) }
  var canRun: Bool { !checkedFiles.isEmpty && !isRunning }
  var allChecked: Bool { !files.isEmpty && files.allSatisfy(\.isChecked) }

  var estimatedSavings: Int {
    checkedFiles.reduce(0) { $0 + Int(Double($1.size) * (1 - selectedPreset.ratio)) }
  }

  func loadMockFiles() {
    files = mockFiles
    isDone = false
  }

  func toggleAll() {
    let target = !allChecked
    for i in files.indices { files[i].isChecked = target }
  }

  func toggle(_ item: FileItem) {
    guard let i = files.firstIndex(where: { $0.id == item.id }) else { return }
    files[i].isChecked.toggle()
  }

  func remove(_ item: FileItem) {
    files.removeAll { $0.id == item.id }
  }

  func run() {
    guard canRun else { return }
    isRunning = true
    isDone = false
    let toProcess = checkedFiles.map(\.id)

    Task {
      for id in toProcess {
        if let i = files.firstIndex(where: { $0.id == id }) {
          files[i].status = .processing
        }
        try? await Task.sleep(nanoseconds: UInt64.random(in: 500_000_000...1_200_000_000))
        if let i = files.firstIndex(where: { $0.id == id }) {
          files[i].status = .done
        }
      }
      isRunning = false
      isDone = true
    }
  }
}
