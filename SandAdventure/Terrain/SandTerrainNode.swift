import SpriteKit
import CoreGraphics

public class SandTerrainGrid {
    public let worldWidth: CGFloat
    public let worldHeight: CGFloat
    public let cellSize: CGFloat
    public let cols: Int
    public let rows: Int

    public var occupancyGrid: [Bool]

    public init(worldWidth: CGFloat = 1000.0, worldHeight: CGFloat = 1800.0, cellSize: CGFloat = 20.0) {
        self.worldWidth = worldWidth
        self.worldHeight = worldHeight
        self.cellSize = cellSize
        self.cols = Int(worldWidth / cellSize) + 1
        self.rows = Int(worldHeight / cellSize) + 1
        self.occupancyGrid = Array(repeating: false, count: cols * rows)
    }

    public func reset(sandBottom: CGFloat = 260.0, sandTop: CGFloat = 1750.0) {
        for r in 0..<rows {
            let cellY = (CGFloat(r) + 0.5) * cellSize
            let isSand = cellY >= sandBottom && cellY <= sandTop
            let rowOffset = r * cols
            for c in 0..<cols {
                occupancyGrid[rowOffset + c] = isSand
            }
        }
    }

    public func carveCapsule(from p1: CGPoint, to p2: CGPoint, radius: CGFloat) {
        let minX = max(0.0, min(p1.x, p2.x) - radius)
        let maxX = min(worldWidth, max(p1.x, p2.x) + radius)
        let minY = max(0.0, min(p1.y, p2.y) - radius)
        let maxY = min(worldHeight, max(p1.y, p2.y) + radius)

        let minCol = max(0, min(Int(minX / cellSize), cols - 1))
        let maxCol = max(0, min(Int(maxX / cellSize), cols - 1))
        let minRow = max(0, min(Int(minY / cellSize), rows - 1))
        let maxRow = max(0, min(Int(maxY / cellSize), rows - 1))

        let segDx = p2.x - p1.x
        let segDy = p2.y - p1.y
        let segLenSq = segDx * segDx + segDy * segDy
        let rSq = radius * radius

        for r in minRow...maxRow {
            let cellY = (CGFloat(r) + 0.5) * cellSize
            let rowOffset = r * cols
            for c in minCol...maxCol {
                let idx = rowOffset + c
                if !occupancyGrid[idx] { continue }

                let cellX = (CGFloat(c) + 0.5) * cellSize
                let distSq: CGFloat
                if segLenSq < 0.0001 {
                    let dx = cellX - p1.x
                    let dy = cellY - p1.y
                    distSq = dx * dx + dy * dy
                } else {
                    let t = max(0.0, min(1.0, ((cellX - p1.x) * segDx + (cellY - p1.y) * segDy) / segLenSq))
                    let projX = p1.x + t * segDx
                    let projY = p1.y + t * segDy
                    let dx = cellX - projX
                    let dy = cellY - projY
                    distSq = dx * dx + dy * dy
                }

                if distSq <= rSq {
                    occupancyGrid[idx] = false
                }
            }
        }
    }

    public func isSolidAt(x: CGFloat, y: CGFloat) -> Bool {
        let c = Int(x / cellSize)
        let r = Int(y / cellSize)
        if c < 0 || c >= cols || r < 0 || r >= rows { return false }
        return occupancyGrid[r * cols + c]
    }

    public func resolveBallCollision(ball: BallNode) {
        let bx = ball.position.x
        let by = ball.position.y
        let br: CGFloat = 13.0

        let minCol = max(0, min(Int((bx - br) / cellSize), cols - 1))
        let maxCol = max(0, min(Int((bx + br) / cellSize), cols - 1))
        let minRow = max(0, min(Int((by - br) / cellSize), rows - 1))
        let maxRow = max(0, min(Int((by + br) / cellSize), rows - 1))

        var curVx = ball.physicsBody?.velocity.dx ?? 0.0
        var curVy = ball.physicsBody?.velocity.dy ?? 0.0
        var curPx = bx
        var curPy = by
        var posChanged = false

        for r in minRow...maxRow {
            let rowOffset = r * cols
            let boxBottom = CGFloat(r) * cellSize
            let boxTop = boxBottom + cellSize

            for c in minCol...maxCol {
                if !occupancyGrid[rowOffset + c] { continue }

                let boxLeft = CGFloat(c) * cellSize
                let boxRight = boxLeft + cellSize

                let clampX = max(boxLeft, min(curPx, boxRight))
                let clampY = max(boxBottom, min(curPy, boxTop))

                let dx = curPx - clampX
                let dy = curPy - clampY
                let distSq = dx * dx + dy * dy

                if distSq > 0.0001 {
                    if distSq < br * br {
                        let dist = sqrt(distSq)
                        let overlap = br - dist
                        let nx = dx / dist
                        let ny = dy / dist

                        curPx += nx * overlap
                        curPy += ny * overlap
                        posChanged = true

                        let velDotN = curVx * nx + curVy * ny
                        if velDotN < 0.0 {
                            curVx -= nx * velDotN
                            curVy -= ny * velDotN
                            curVx *= 0.995
                            curVy *= 0.995
                        }
                    }
                } else {
                    let dLeft = curPx - boxLeft
                    let dRight = boxRight - curPx
                    let dBottom = curPy - boxBottom
                    let dTop = boxTop - curPy

                    var bestDir = 0
                    var minD = dTop

                    if dBottom < minD && (r > 0 && !occupancyGrid[(r - 1) * cols + c]) {
                        minD = dBottom
                        bestDir = 1
                    }
                    if dLeft < minD && (c > 0 && !occupancyGrid[rowOffset + (c - 1)]) {
                        minD = dLeft
                        bestDir = 2
                    }
                    if dRight < minD && (c < cols - 1 && !occupancyGrid[rowOffset + (c + 1)]) {
                        minD = dRight
                        bestDir = 3
                    }

                    switch bestDir {
                    case 0:
                        curPy = boxTop + br
                        if curVy < 0.0 { curVy = 0.0 }
                        posChanged = true
                    case 1:
                        curPy = boxBottom - br
                        if curVy > 0.0 { curVy = 0.0 }
                        posChanged = true
                    case 2:
                        curPx = boxLeft - br
                        if curVx > 0.0 { curVx = 0.0 }
                        posChanged = true
                    case 3:
                        curPx = boxRight + br
                        if curVx < 0.0 { curVx = 0.0 }
                        posChanged = true
                    default:
                        break
                    }
                }
            }
        }

        if posChanged {
            ball.position = CGPoint(x: curPx, y: curPy)
            ball.physicsBody?.velocity = CGVector(dx: curVx, dy: curVy)
        }
    }
}

public class SandTerrainNode: SKNode {
    public let worldSize: CGSize
    public let grid: SandTerrainGrid
    private let sandSprite: SKSpriteNode

    // Offscreen visual sand mask texture
    private let maskW = 500
    private let maskH = 900
    private var cgContext: CGContext?
    private var currentColor: SKColor

    public init(size: CGSize) {
        self.worldSize = size
        self.grid = SandTerrainGrid(worldWidth: size.width, worldHeight: size.height, cellSize: 20.0)
        self.currentColor = SKColor(red: 1.0, green: 0.82, blue: 0.32, alpha: 1.0)
        self.sandSprite = SKSpriteNode()
        super.init()

        sandSprite.anchorPoint = .zero
        sandSprite.position = .zero
        sandSprite.size = size
        addChild(sandSprite)

        setupContext()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContext() {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        self.cgContext = CGContext(
            data: nil,
            width: maskW,
            height: maskH,
            bitsPerComponent: 8,
            bytesPerRow: maskW * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        )
    }

    public func reset(sandBottom: CGFloat = 260.0, sandTop: CGFloat = 1750.0, color: SKColor) {
        self.currentColor = color
        grid.reset(sandBottom: sandBottom, sandTop: sandTop)

        guard let ctx = cgContext else { return }
        ctx.clear(CGRect(x: 0, y: 0, width: maskW, height: maskH))

        var r: CGFloat = 1.0
        var g: CGFloat = 0.82
        var b: CGFloat = 0.32
        var a: CGFloat = 1.0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        ctx.setFillColor(red: r, green: g, blue: b, alpha: a)

        let scaleY = CGFloat(maskH) / worldSize.height
        let screenBottom = sandBottom * scaleY
        let screenHeight = (sandTop - sandBottom) * scaleY

        ctx.fill(CGRect(x: 0, y: screenBottom, width: CGFloat(maskW), height: screenHeight))

        updateSpriteTexture()
    }

    public func carveCapsule(from p1: CGPoint, to p2: CGPoint, radius: CGFloat) {
        // 1. Update occupancy physics grid
        grid.carveCapsule(from: p1, to: p2, radius: radius)

        // 2. Update visual mask texture
        guard let ctx = cgContext else { return }
        let scaleX = CGFloat(maskW) / worldSize.width
        let scaleY = CGFloat(maskH) / worldSize.height

        let mx1 = p1.x * scaleX
        let my1 = p1.y * scaleY
        let mx2 = p2.x * scaleX
        let my2 = p2.y * scaleY
        let mr = radius * scaleX

        ctx.setBlendMode(.clear)
        ctx.setLineCap(.round)
        ctx.setLineWidth(mr * 2.0)

        ctx.beginPath()
        ctx.move(to: CGPoint(x: mx1, y: my1))
        ctx.addLine(to: CGPoint(x: mx2, y: my2))
        ctx.strokePath()

        ctx.fillEllipse(in: CGRect(x: mx1 - mr, y: my1 - mr, width: mr * 2.0, height: mr * 2.0))
        ctx.fillEllipse(in: CGRect(x: mx2 - mr, y: my2 - mr, width: mr * 2.0, height: mr * 2.0))

        updateSpriteTexture()
    }

    public func resolveBallCollision(ball: BallNode) {
        grid.resolveBallCollision(ball: ball)
    }

    private func updateSpriteTexture() {
        guard let ctx = cgContext, let cgImage = ctx.makeImage() else { return }
        sandSprite.texture = SKTexture(cgImage: cgImage)
    }
}
