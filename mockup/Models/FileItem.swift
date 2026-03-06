import Foundation

enum OptimizeStatus {
    case pending, processing, done
}

struct FileItem: Identifiable {
    let id = UUID()
    var name: String
    var kind: FileKind
    var size: Int  // bytes
    var isChecked: Bool
    var status: OptimizeStatus = .pending
}

let mockFiles: [FileItem] = [
    FileItem(name: "product-brochure.pdf", kind: .pdf, size: 8_420_000, isChecked: true),
    FileItem(name: "hero-banner.png", kind: .image, size: 4_102_400, isChecked: true),
    FileItem(name: "team-photo.jpg", kind: .image, size: 6_553_600, isChecked: true),
    FileItem(name: "demo-reel.mp4", kind: .video, size: 209_715_200, isChecked: true),
    FileItem(name: "annual-report.pdf", kind: .pdf, size: 15_728_640, isChecked: false),
    FileItem(name: "logo-vector.png", kind: .image, size: 1_048_576, isChecked: true),
    FileItem(name: "onboarding-video.mp4", kind: .video, size: 524_288_000, isChecked: false),
    FileItem(name: "wireframes.pdf", kind: .pdf, size: 3_145_728, isChecked: true),
]
