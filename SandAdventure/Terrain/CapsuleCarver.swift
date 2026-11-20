import CoreGraphics

public class CapsuleCarver {
    public var carveRadius: CGFloat = 45.0
    private var isDragging: Bool = false
    private var lastPoint: CGPoint = .zero
    public var onCarveCapsule: ((CGPoint, CGPoint, CGFloat) -> Void)?

    public init(carveRadius: CGFloat = 45.0) {
        self.carveRadius = carveRadius
    }

    public func touchBegan(at point: CGPoint) {
        isDragging = true
        lastPoint = point
        onCarveCapsule?(point, point, carveRadius)
    }

    public func touchMoved(to point: CGPoint) {
        guard isDragging else {
            touchBegan(at: point)
            return
        }
        onCarveCapsule?(lastPoint, point, carveRadius)
        lastPoint = point
    }

    public func touchEnded(at point: CGPoint) {
        if isDragging {
            onCarveCapsule?(lastPoint, point, carveRadius)
            isDragging = false
        }
    }
}
