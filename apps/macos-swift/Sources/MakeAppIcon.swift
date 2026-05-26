import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let iconset = root.appendingPathComponent("build/AppIcon.iconset")
let resources = root.appendingPathComponent("build/Urinprotokoll SwiftUI.app/Contents/Resources")
try? FileManager.default.removeItem(at: iconset)
try FileManager.default.createDirectory(at: iconset, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: resources, withIntermediateDirectories: true)

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

func drawDrop(in rect: CGRect, color: NSColor) {
    let path = NSBezierPath()
    path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
    path.curve(to: CGPoint(x: rect.maxX, y: rect.midY * 0.92), controlPoint1: CGPoint(x: rect.maxX * 0.84, y: rect.maxY * 0.78), controlPoint2: CGPoint(x: rect.maxX, y: rect.maxY * 0.60))
    path.curve(to: CGPoint(x: rect.midX, y: rect.minY), controlPoint1: CGPoint(x: rect.maxX, y: rect.minY * 1.25), controlPoint2: CGPoint(x: rect.maxX * 0.68, y: rect.minY))
    path.curve(to: CGPoint(x: rect.minX, y: rect.midY * 0.92), controlPoint1: CGPoint(x: rect.minX * 1.32, y: rect.minY), controlPoint2: CGPoint(x: rect.minX, y: rect.maxY * 0.60))
    path.curve(to: CGPoint(x: rect.midX, y: rect.maxY), controlPoint1: CGPoint(x: rect.minX, y: rect.maxY * 0.72), controlPoint2: CGPoint(x: rect.midX * 0.78, y: rect.maxY * 0.86))
    path.close()
    color.setFill()
    path.fill()
}

func icon(size: CGFloat) -> NSImage {
    let image = NSImage(size: CGSize(width: size, height: size))
    image.lockFocus()
    let rect = CGRect(x: 0, y: 0, width: size, height: size)

    let bg = NSBezierPath(roundedRect: rect.insetBy(dx: size * 0.07, dy: size * 0.07), xRadius: size * 0.20, yRadius: size * 0.20)
    NSGradient(colors: [
        NSColor(calibratedRed: 0.02, green: 0.28, blue: 0.30, alpha: 1),
        NSColor(calibratedRed: 0.04, green: 0.12, blue: 0.14, alpha: 1)
    ])?.draw(in: bg, angle: -35)

    NSColor.white.withAlphaComponent(0.18).setStroke()
    bg.lineWidth = max(1, size * 0.012)
    bg.stroke()

    let chart = NSBezierPath()
    chart.move(to: CGPoint(x: size * 0.18, y: size * 0.33))
    chart.line(to: CGPoint(x: size * 0.30, y: size * 0.56))
    chart.line(to: CGPoint(x: size * 0.39, y: size * 0.42))
    chart.line(to: CGPoint(x: size * 0.49, y: size * 0.66))
    chart.line(to: CGPoint(x: size * 0.60, y: size * 0.48))
    chart.line(to: CGPoint(x: size * 0.75, y: size * 0.60))
    NSColor.white.withAlphaComponent(0.36).setStroke()
    chart.lineWidth = max(2, size * 0.030)
    chart.lineCapStyle = .round
    chart.lineJoinStyle = .round
    chart.stroke()

    drawDrop(in: CGRect(x: size * 0.20, y: size * 0.19, width: size * 0.36, height: size * 0.54), color: NSColor(calibratedRed: 1.00, green: 0.73, blue: 0.04, alpha: 1))
    drawDrop(in: CGRect(x: size * 0.52, y: size * 0.25, width: size * 0.26, height: size * 0.40), color: NSColor(calibratedRed: 0.08, green: 0.54, blue: 1.00, alpha: 1))

    NSColor.white.withAlphaComponent(0.30).setFill()
    NSBezierPath(ovalIn: CGRect(x: size * 0.31, y: size * 0.50, width: size * 0.08, height: size * 0.13)).fill()
    NSBezierPath(ovalIn: CGRect(x: size * 0.60, y: size * 0.43, width: size * 0.05, height: size * 0.09)).fill()

    image.unlockFocus()
    return image
}

for (filename, size) in sizes {
    let image = icon(size: size)
    guard let tiff = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff),
          let data = bitmap.representation(using: .png, properties: [:]) else {
        fatalError("Icon konnte nicht erzeugt werden.")
    }
    try data.write(to: iconset.appendingPathComponent(filename))
}
