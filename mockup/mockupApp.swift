//
//  mockupApp.swift
//  mockup
//
//  Created by Daniel Chen on 3/3/26.
//

import SwiftUI

@main
struct MockupApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .frame(minWidth: 720, minHeight: 520)
    }
    .windowStyle(.hiddenTitleBar)
  }
}
