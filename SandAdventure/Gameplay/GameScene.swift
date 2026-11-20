import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    public let levelRepo: LevelRepository
    public let progressManager: ProgressManager
    public var currentLevelId: Int = 1

    public var remainingQuota: Int = 10
    public var collectedCount: Int = 0
    public var isVictory: Bool = false
    public var earnedStars: Int = 0

    public var onQuotaUpdated: ((Int) -> Void)?
    public var onVictory: ((Int) -> Void)?
    public var onLevelChanged: ((Int) -> Void)?

    private let carver = CapsuleCarver(carveRadius: 52.0)
    private var sandTerrainNode: SandTerrainNode?
    private var balls = [BallNode]()
    private var ballCounter = 1

    // Gate tracking to avoid duplicate clones
    private var passedGates = Set<String>()

    public init(size: CGSize, levelId: Int = 1, levelRepo: LevelRepository = BundleLevelRepository(), progressManager: ProgressManager = ProgressManager.shared) {
        self.levelRepo = levelRepo
        self.progressManager = progressManager
        self.currentLevelId = levelId
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        self.levelRepo = BundleLevelRepository()
        self.progressManager = ProgressManager.shared
        super.init(coder: aDecoder)
    }

    public override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8 * 85.0)
        physicsWorld.contactDelegate = self

        // Side boundary walls
        let borderBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        borderBody.categoryBitMask = CollisionCategory.sandBoundary
        borderBody.friction = 0.1
        borderBody.restitution = 0.2
        self.physicsBody = borderBody

        setupTerrain()
        loadLevel(levelId: currentLevelId)
    }

    private func setupTerrain() {
        let terrain = SandTerrainNode(size: size)
        sandTerrainNode = terrain
        addChild(terrain)

        carver.onCarveCapsule = { [weak self] p1, p2, radius in
            self?.sandTerrainNode?.carveCapsule(from: p1, to: p2, radius: radius)
        }
    }

    public func loadLevel(levelId: Int) {
        currentLevelId = levelId
        balls.removeAll()
        passedGates.removeAll()
        children.filter { $0 is BallNode || $0.name == "truck" || $0.name == "obstacle" || $0.name == "portal" || $0.name == "tnt" || $0.name == "bumper" || $0.name == "gate" }.forEach { $0.removeFromParent() }

        let worldId = ((levelId - 1) / 10) + 1
        let theme = getWorldTheme(for: worldId)

        backgroundColor = SKColor(white: 0.96, alpha: 1.0)
        sandTerrainNode?.setSandColor(theme.sandColor)
        sandTerrainNode?.resetTerrain()

        AudioManager.shared.playWorldBgm(for: worldId)

        let level = levelRepo.getLevel(levelId: levelId)
        remainingQuota = level.quota
        collectedCount = 0
        isVictory = false
        earnedStars = 0
        onQuotaUpdated?(remainingQuota)
        onLevelChanged?(levelId)

        // Pre-carve initial bowl opening
        sandTerrainNode?.carveCapsule(from: CGPoint(x: 500, y: 1720), to: CGPoint(x: 500, y: 1560), radius: 120)

        // Pre-carve dormant white chambers
        for spawner in level.ballSpawners where spawner.type == "dormant_white" {
            sandTerrainNode?.carveCapsule(
                from: CGPoint(x: spawner.x, y: spawner.y),
                to: CGPoint(x: spawner.x, y: spawner.y),
                radius: CGFloat(spawner.spreadRadius + 14.0)
            )
        }

        // Setup Truck Sensor at bottom
        let truck = level.truck
        let truckNode = SKNode()
        truckNode.name = "truck"
        truckNode.position = CGPoint(x: truck.x, y: truck.y)

        // Cute truck sprite
        let truckSprite = SKSpriteNode(color: SKColor(red: 1.0, green: 0.28, blue: 0.34, alpha: 1.0), size: CGSize(width: truck.width, height: truck.height * 0.6))
        truckNode.addChild(truckSprite)

        // Truck sensor
        let sensorBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -truck.width/2, y: -truck.height/2, width: truck.width, height: truck.height))
        sensorBody.categoryBitMask = CollisionCategory.truckBed
        sensorBody.contactTestBitMask = CollisionCategory.ballColored
        sensorBody.isDynamic = false
        truckNode.physicsBody = sensorBody
        addChild(truckNode)

        // Setup Obstacles
        for obs in level.obstacles {
            switch obs.type {
            case "multiplier_gate":
                let gateNode = SKNode()
                gateNode.name = "gate"
                gateNode.position = CGPoint(x: obs.x, y: obs.y)
                gateNode.userData = ["id": obs.id, "mult": obs.safeMultiplier]

                let w = CGFloat(max(150.0, obs.safeWidth))
                let h = CGFloat(max(32.0, obs.safeHeight))
                let rect = SKShapeNode(rectOf: CGSize(width: w, height: h), cornerRadius: 8.0)
                rect.fillColor = SKColor(red: 0.56, green: 0.27, blue: 0.68, alpha: 0.85) // Purple neon
                rect.strokeColor = SKColor(red: 0.0, green: 0.82, blue: 0.83, alpha: 1.0)
                rect.lineWidth = 3.0
                gateNode.addChild(rect)

                let label = SKLabelNode(text: "★ ×\(obs.safeMultiplier) ★")
                label.fontSize = 18
                label.fontName = "AvenirNext-Bold"
                label.fontColor = .white
                label.verticalAlignmentMode = .center
                gateNode.addChild(label)

                let sensor = SKPhysicsBody(rectangleOf: CGSize(width: w, height: h))
                sensor.isDynamic = false
                sensor.categoryBitMask = CollisionCategory.multiplierGate
                sensor.contactTestBitMask = CollisionCategory.ballColored
                gateNode.physicsBody = sensor
                addChild(gateNode)

            case "portal_pair":
                // In Portal
                let inPortal = SKShapeNode(circleOfRadius: 36)
                inPortal.name = "portal"
                inPortal.position = CGPoint(x: obs.x, y: obs.y)
                inPortal.fillColor = SKColor(red: 0.04, green: 0.52, blue: 0.89, alpha: 0.9)
                inPortal.strokeColor = SKColor(red: 0.0, green: 0.81, blue: 0.79, alpha: 1.0)
                inPortal.lineWidth = 4.0
                inPortal.userData = ["exitX": obs.safeExitX, "exitY": obs.safeExitY]

                let pBody = SKPhysicsBody(circleOfRadius: 36)
                pBody.isDynamic = false
                pBody.categoryBitMask = CollisionCategory.portal
                pBody.contactTestBitMask = CollisionCategory.ballColored
                inPortal.physicsBody = pBody
                addChild(inPortal)

                // Out Portal
                let outPortal = SKShapeNode(circleOfRadius: 36)
                outPortal.position = CGPoint(x: obs.safeExitX, y: obs.safeExitY)
                outPortal.fillColor = SKColor(red: 0.88, green: 0.44, blue: 0.33, alpha: 0.9)
                outPortal.strokeColor = SKColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.0)
                outPortal.lineWidth = 4.0
                addChild(outPortal)

            case "bouncy_bumper":
                let bumper = SKShapeNode(circleOfRadius: 38)
                bumper.name = "bumper"
                bumper.position = CGPoint(x: obs.x, y: obs.y)
                bumper.fillColor = SKColor(red: 1.0, green: 0.28, blue: 0.34, alpha: 1.0)
                bumper.strokeColor = .white
                bumper.lineWidth = 4.0

                let body = SKPhysicsBody(circleOfRadius: 38)
                body.isDynamic = false
                body.categoryBitMask = CollisionCategory.bumper
                body.contactTestBitMask = CollisionCategory.ballColored
                body.restitution = 1.8
                bumper.physicsBody = body
                addChild(bumper)

            case "tnt_crate":
                let tnt = SKNode()
                tnt.name = "tnt"
                tnt.position = CGPoint(x: obs.x, y: obs.y)

                let box = SKShapeNode(rectOf: CGSize(width: 55, height: 55), cornerRadius: 6.0)
                box.fillColor = SKColor(red: 0.90, green: 0.49, blue: 0.13, alpha: 1.0)
                box.strokeColor = SKColor(red: 0.83, green: 0.33, blue: 0.0, alpha: 1.0)
                box.lineWidth = 3.0
                tnt.addChild(box)

                let label = SKLabelNode(text: "TNT 💣")
                label.fontSize = 14
                label.fontName = "AvenirNext-Bold"
                label.fontColor = .white
                label.verticalAlignmentMode = .center
                tnt.addChild(label)

                let body = SKPhysicsBody(rectangleOf: CGSize(width: 55, height: 55))
                body.isDynamic = false
                body.categoryBitMask = CollisionCategory.tnt
                body.contactTestBitMask = CollisionCategory.ballColored
                tnt.physicsBody = body
                addChild(tnt)

            default: // static_beam, funnel_bumper, rotating_paddle
                let w = CGFloat(max(10.0, obs.safeWidth))
                let h = CGFloat(max(10.0, obs.safeHeight))
                let obsNode = SKShapeNode(rectOf: CGSize(width: w, height: h), cornerRadius: 6.0)
                obsNode.name = "obstacle"
                obsNode.position = CGPoint(x: obs.x, y: obs.y)
                obsNode.zRotation = CGFloat(obs.safeRotation * .pi / 180.0)
                obsNode.fillColor = theme.obstacleColor
                obsNode.strokeColor = .white
                obsNode.lineWidth = 2.0

                let body = SKPhysicsBody(rectangleOf: CGSize(width: w, height: h))
                body.isDynamic = false
                body.categoryBitMask = CollisionCategory.obstacle
                body.restitution = CGFloat(obs.safeRestitution)
                obsNode.physicsBody = body

                if obs.type == "rotating_paddle" && obs.safeMotorSpeed != 0 {
                    let dur = Double(360.0 / abs(obs.safeMotorSpeed))
                    let angle = CGFloat((obs.safeMotorSpeed > 0 ? 1 : -1) * Double.pi * 2)
                    let rotate = SKAction.rotate(byAngle: angle, duration: dur)
                    obsNode.run(SKAction.repeatForever(rotate))
                }
                addChild(obsNode)
            }
        }

        // Spawn Balls
        for spawner in level.ballSpawners {
            let isDormant = spawner.type == "dormant_white"
            for _ in 0..<spawner.count {
                let angle = CGFloat.random(in: 0...(.pi * 2))
                let dist = CGFloat.random(in: 0...CGFloat(spawner.spreadRadius))
                let bx = CGFloat(spawner.x) + cos(angle) * dist
                let by = CGFloat(spawner.y) + sin(angle) * dist

                let ball = BallNode(ballId: ballCounter, radius: 13.0, isDormant: isDormant)
                ballCounter += 1
                ball.position = CGPoint(x: bx, y: by)
                balls.append(ball)
                addChild(ball)
            }
        }
    }

    // Touch Handling
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        carver.touchBegan(at: location)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        carver.touchMoved(to: location)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        carver.touchEnded(at: location)
    }

    // Contact Detection
    public func didBegin(_ contact: SKPhysicsContact) {
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        // 1. Colored ball hits dormant white ball
        if mask == (CollisionCategory.ballColored | CollisionCategory.ballWhite) {
            let whiteBody = contact.bodyA.categoryBitMask == CollisionCategory.ballWhite ? contact.bodyA : contact.bodyB
            if let ball = whiteBody.node as? BallNode {
                ball.activateAndColorize()
                AudioManager.shared.playBallPop()
            }
        }

        // 2. Ball reaches Truck
        if mask == (CollisionCategory.ballColored | CollisionCategory.truckBed) {
            let ballBody = contact.bodyA.categoryBitMask == CollisionCategory.ballColored ? contact.bodyA : contact.bodyB
            if let ball = ballBody.node as? BallNode, !ball.isCollected {
                ball.isCollected = true
                collectedCount += 1
                AudioManager.shared.playTruckDrop()
                if remainingQuota > 0 {
                    remainingQuota -= 1
                    onQuotaUpdated?(remainingQuota)
                }
                if collectedCount >= (levelRepo.getLevel(levelId: currentLevelId).quota) && !isVictory {
                    triggerVictory()
                }
            }
        }

        // 3. Multiplier Gate
        if mask == (CollisionCategory.ballColored | CollisionCategory.multiplierGate) {
            let ballBody = contact.bodyA.categoryBitMask == CollisionCategory.ballColored ? contact.bodyA : contact.bodyB
            let gateBody = contact.bodyA.categoryBitMask == CollisionCategory.multiplierGate ? contact.bodyA : contact.bodyB
            if let ball = ballBody.node as? BallNode, let gate = gateBody.node {
                let gateKey = "\(ball.ballId)_\(gate.position.x)"
                if !passedGates.contains(gateKey) {
                    passedGates.insert(gateKey)
                    let mult = (gate.userData?["mult"] as? Int) ?? 2
                    AudioManager.shared.playMultiplier()
                    for m in 1..<mult {
                        let clone = BallNode(ballId: ballCounter, radius: 13.0, isDormant: false)
                        ballCounter += 1
                        clone.position = CGPoint(x: ball.position.x + CGFloat(m * 10), y: ball.position.y)
                        clone.physicsBody?.velocity = ball.physicsBody?.velocity ?? CGVector.zero
                        balls.append(clone)
                        addChild(clone)
                    }
                }
            }
        }

        // 4. Portal Teleport
        if mask == (CollisionCategory.ballColored | CollisionCategory.portal) {
            let ballBody = contact.bodyA.categoryBitMask == CollisionCategory.ballColored ? contact.bodyA : contact.bodyB
            let portalBody = contact.bodyA.categoryBitMask == CollisionCategory.portal ? contact.bodyA : contact.bodyB
            if let ball = ballBody.node as? BallNode, let portal = portalBody.node {
                if let ex = portal.userData?["exitX"] as? Double, let ey = portal.userData?["exitY"] as? Double {
                    ball.position = CGPoint(x: ex + Double.random(in: -10...10), y: ey - 20)
                    ball.physicsBody?.velocity = CGVector(dx: Double.random(in: -50...50), dy: -300)
                    AudioManager.shared.playPortal()
                }
            }
        }

        // 5. Bouncy Bumper
        if mask == (CollisionCategory.ballColored | CollisionCategory.bumper) {
            let bumperBody = contact.bodyA.categoryBitMask == CollisionCategory.bumper ? contact.bodyA : contact.bodyB
            if let bumper = bumperBody.node {
                let pulse = SKAction.sequence([SKAction.scale(to: 1.25, duration: 0.08), SKAction.scale(to: 1.0, duration: 0.12)])
                bumper.run(pulse)
                AudioManager.shared.playBoing()
            }
        }

        // 6. TNT Explosion
        if mask == (CollisionCategory.ballColored | CollisionCategory.tnt) {
            let tntBody = contact.bodyA.categoryBitMask == CollisionCategory.tnt ? contact.bodyA : contact.bodyB
            if let tnt = tntBody.node {
                let pos = tnt.position
                tnt.removeFromParent()
                AudioManager.shared.playTntBlast()
                sandTerrainNode?.carveCapsule(from: pos, to: pos, radius: 140)
            }
        }
    }

    private func triggerVictory() {
        isVictory = true
        let total = max(1, levelRepo.getLevel(levelId: currentLevelId).totalInitialBalls)
        let ratio = Float(collectedCount) / Float(total)
        earnedStars = ratio >= 0.85 ? 3 : (ratio >= 0.65 ? 2 : 1)
        progressManager.setStars(for: currentLevelId, stars: earnedStars)
        onVictory?(earnedStars)
        AudioManager.shared.playVictory()
        AudioManager.shared.playTruckHorn()
        spawnConfetti()

        // Auto-advance to next level after celebration
        let wait = SKAction.wait(forDuration: 2.4)
        let advance = SKAction.run { [weak self] in
            guard let self = self else { return }
            let next = self.currentLevelId + 1
            if next <= 100 {
                self.loadLevel(levelId: next)
            }
        }
        run(SKAction.sequence([wait, advance]), withKey: "autoAdvance")
    }

    private func spawnConfetti() {
        for _ in 0..<60 {
            let confetti = SKShapeNode(rectOf: CGSize(width: 8, height: 16))
            confetti.fillColor = BallNode.palette.randomElement() ?? .yellow
            confetti.strokeColor = .clear
            confetti.position = CGPoint(x: 500, y: 300)
            addChild(confetti)

            let dx = CGFloat.random(in: -350...350)
            let dy = CGFloat.random(in: 250...650)
            let move = SKAction.moveBy(x: dx, y: dy, duration: 0.6)
            let fall = SKAction.moveBy(x: dx * 0.5, y: -800, duration: 1.8)
            let rotate = SKAction.rotate(byAngle: CGFloat.random(in: 5...15), duration: 2.4)
            let fade = SKAction.fadeOut(withDuration: 0.4)
            let seq = SKAction.sequence([move, fall, fade, SKAction.removeFromParent()])

            confetti.run(SKAction.group([seq, rotate]))
        }
    }
}
