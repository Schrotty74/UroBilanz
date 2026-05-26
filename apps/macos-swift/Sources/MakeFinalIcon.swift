import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let iconset = root.appendingPathComponent("build/UroBilanz.iconset")
let resources = root.appendingPathComponent("build/UroBilanz.app/Contents/Resources")
let source = root.appendingPathComponent("Assets/urobilanz-icon-dark.svg")

try? FileManager.default.removeItem(at: iconset)
try FileManager.default.createDirectory(at: iconset, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: resources, withIntermediateDirectories: true)

let svg = try String(contentsOf: source, encoding: .utf8)
let sizes: [(String, CGFloat)] = [
    ("icon_16x16.png", 16),
    ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32),
    ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128),
    ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256),
    ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512),
    ("icon_512x512@2x.png", 1024)
]

for (filename, size) in sizes {
    guard let data = svg.data(using: .utf8),
          let image = NSImage(data: data) else {
        fatalError("SVG konnte nicht gelesen werden.")
    }
    let target = NSImage(size: CGSize(width: size, height: size))
    target.lockFocus()
    image.draw(in: CGRect(x: 0, y: 0, width: size, height: size))
    target.unlockFocus()
    guard let tiff = target.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff),
          let png = bitmap.representation(using: .png, properties: [:]) else {
        fatalError("PNG konnte nicht erzeugt werden.")
    }
    try png.write(to: iconset.appendingPathComponent(filename))
}
