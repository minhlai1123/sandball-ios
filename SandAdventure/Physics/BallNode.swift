import SpriteKit

public class BallNode: SKShapeNode {
    public let ballId: Int
    public var isDormant: Bool
    public var isCollected: Bool = false
    public var isDestroyed: Bool = false

    private var leftEye: SKShapeNode?
    private var rightEye: SKShapeNode?
    private var leftPupil: SKShapeNode?
    private var rightPupil: SKShapeNode?
    private var mouth: SKShapeNode?

    public static let palette: [SKColor] = [
        SKColor(red: 1.0, green: 0.28, blue: 0.34, alpha: 1.0), // Bubblegum Coral
        SKColor(red: 1.0, green: 0.65, blue: 0.01, alpha: 1.0), // Sunny Orange
        SKColor(red: 0.0, green: 0.82, blue: 0.83, alpha: 1.0), // Sky Blue
        SKColor(red: 0.18, green: 0.84, blue: 0.45, alpha: 1.0), // Fresh Mint
        SKColor(red: 0.37, green: 0.15, blue: 0.80, alpha: 1.0), // Sweet Lavender
        SKColor(red: 1.0, green: 0.42, blue: 0.51, alpha: 1.0), // Strawberry Pink
        SKColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.0)  // Lemon Yellow
    ]
    public static let dormantColor = SKColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)

    public init(ballId: Int, radius: CGFloat, isDormant: Bool) {
        self.ballId = ballId
        self.isDormant = isDormant
        super.init()

        let diameter = radius * 2.0
        let path = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: diameter, height: diameter), transform: nil)
        self.path = path

        self.fillColor = isDormant ? BallNode.dormantColor : (BallNode.palette.randomElement() ?? .cyan)
        self.strokeColor = isDormant ? SKColor(white: 0.8, alpha: 1.0) : SKColor.white.withAlphaComponent(0.4)
        self.lineWidth = 1.0

        // Specular glint
        let glint = SKShapeNode(ellipseIn: CGRect(x: -radius * 0.45, y: radius * 0.15, width: radius * 0.5, height: radius * 0.5))
        glint.fillColor = SKColor.white.withAlphaComponent(0.6)
        glint.strokeColor = .clear
        addChild(glint)

        // Cartoon face
        setupCartoonFace(radius: radius)

        // Physics Body
        let body = SKPhysicsBody(circleOfRadius: radius)
        body.isDynamic = !isDormant
        body.mass = 0.05
        body.restitution = 0.22
        body.friction = 0.30
        body.linearDamping = 0.08
        body.angularDamping = 0.15
        body.allowsRotation = true

        if isDormant {
            body.categoryBitMask = CollisionCategory.ballWhite
            body.collisionBitMask = CollisionCategory.sandBoundary | CollisionCategory.ballColored | CollisionCategory.obstacle
            body.contactTestBitMask = CollisionCategory.ballColored
        } else {
            body.categoryBitMask = CollisionCategory.ballColored
            body.collisionBitMask = CollisionCategory.sandBoundary | CollisionCategory.ballColored | CollisionCategory.ballWhite | CollisionCategory.obstacle
            body.contactTestBitMask = CollisionCategory.ballWhite | CollisionCategory.truckBed
        }

        self.physicsBody = body
    }

    private func setupCartoonFace(radius: CGFloat) {
        let eyeR = radius * 0.26
        let eyeSpacing = radius * 0.32
        let eyeY = -radius * 0.08

        let lEye = SKShapeNode(ellipseIn: CGRect(x: -eyeSpacing - eyeR, y: eyeY - eyeR, width: eyeR * 2, height: eyeR * 2))
        lEye.fillColor = isDormant ? SKColor(white: 0.85, alpha: 1.0) : .white
        lEye.strokeColor = .clear
        addChild(lEye)
        self.leftEye = lEye

        let rEye = SKShapeNode(ellipseIn: CGRect(x: eyeSpacing - eyeR, y: eyeY - eyeR, width: eyeR * 2, height: eyeR * 2))
        rEye.fillColor = isDormant ? SKColor(white: 0.85, alpha: 1.0) : .white
        rEye.strokeColor = .clear
        addChild(rEye)
        self.rightEye = rEye

        let pupilR = eyeR * 0.55
        let lPupil = SKShapeNode(ellipseIn: CGRect(x: -eyeSpacing - pupilR, y: eyeY - pupilR, width: pupilR * 2, height: pupilR * 2))
        lPupil.fillColor = isDormant ? SKColor(white: 0.6, alpha: 1.0) : SKColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)
        lPupil.strokeColor = .clear
        addChild(lPupil)
        self.leftPupil = lPupil

        let rPupil = SKShapeNode(ellipseIn: CGRect(x: eyeSpacing - pupilR, y: eyeY - pupilR, width: pupilR * 2, height: pupilR * 2))
        rPupil.fillColor = isDormant ? SKColor(white: 0.6, alpha: 1.0) : SKColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)
        rPupil.strokeColor = .clear
        addChild(rPupil)
        self.rightPupil = rPupil

        // Cute smiling mouth
        let mPath = CGMutablePath()
        mPath.addArc(center: CGPoint(x: 0, y: -radius * 0.35), radius: radius * 0.22, startAngle: .pi * 0.2, endAngle: .pi * 0.8, clockwise: true)
        let mNode = SKShapeNode(path: mPath)
        mNode.strokeColor = SKColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)
        mNode.lineWidth = 1.8
        addChild(mNode)
        self.mouth = mNode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func activateAndColorize() {
        guard isDormant else { return }
        isDormant = false
        fillColor = BallNode.palette.randomElement() ?? .yellow
        strokeColor = SKColor.white.withAlphaComponent(0.4)

        leftEye?.fillColor = .white
        rightEye?.fillColor = .white
        leftPupil?.fillColor = SKColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)
        rightPupil?.fillColor = SKColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)

        if let body = self.physicsBody {
            body.isDynamic = true
            body.categoryBitMask = CollisionCategory.ballColored
            body.collisionBitMask = CollisionCategory.sandBoundary | CollisionCategory.ballColored | CollisionCategory.ballWhite | CollisionCategory.obstacle
            body.contactTestBitMask = CollisionCategory.ballWhite | CollisionCategory.truckBed

            // Add happy bounce impulse
            let dx = CGFloat.random(in: -25...25)
            let dy = CGFloat.random(in: 20...45)
            body.applyImpulse(CGVector(dx: dx, dy: dy))
        }
    }
}
