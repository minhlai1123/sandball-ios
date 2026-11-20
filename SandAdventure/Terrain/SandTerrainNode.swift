import SpriteKit

public class SandTerrainNode: SKNode {
    private let worldSize: CGSize
    private let cropNode = SKCropNode()
    private let maskRootNode = SKNode()
    private let sandSurfaceNode: SKSpriteNode

    public init(size: CGSize) {
        self.worldSize = size
        self.sandSurfaceNode = SKSpriteNode(color: SKColor(red: 0.96, green: 0.82, blue: 0.38, alpha: 1.0), size: size)
        super.init()

        sandSurfaceNode.anchorPoint = .zero
        sandSurfaceNode.position = .zero

        cropNode.maskNode = maskRootNode
        // CropNode masks out pixels where mask is transparent; by inverting or adding clear nodes
        cropNode.addChild(sandSurfaceNode)
        addChild(cropNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setSandColor(_ color: SKColor) {
        sandSurfaceNode.color = color
    }

    public func resetTerrain() {
        maskRootNode.removeAllChildren()
    }

    public func carveCapsule(from p1: CGPoint, to p2: CGPoint, radius: CGFloat) {
        // Add carved shape node into mask
        let path = CGMutablePath()
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        let len = sqrt(dx * dx + dy * dy)

        if len < 0.1 {
            path.addArc(center: p1, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        } else {
            let nx = -dy / len * radius
            let ny = dx / len * radius

            path.move(to: CGPoint(x: p1.x + nx, y: p1.y + ny))
            path.addLine(to: CGPoint(x: p2.x + nx, y: p2.y + ny))
            path.addArc(center: p2, radius: radius, startAngle: atan2(ny, nx), endAngle: atan2(-ny, -nx), clockwise: false)
            path.addLine(to: CGPoint(x: p1.x - nx, y: p1.y - ny))
            path.addArc(center: p1, radius: radius, startAngle: atan2(-ny, -nx), endAngle: atan2(ny, nx), clockwise: false)
            path.closeSubpath()
        }

        let carveNode = SKShapeNode(path: path)
        carveNode.fillColor = .black
        carveNode.strokeColor = .clear
        carveNode.blendMode = .replace
        maskRootNode.addChild(carveNode)
    }
}
