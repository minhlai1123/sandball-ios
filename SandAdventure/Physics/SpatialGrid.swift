import Foundation

public class SpatialGrid {
    public let worldWidth: CGFloat
    public let worldHeight: CGFloat
    public let cellSize: CGFloat
    public let cols: Int
    public let rows: Int

    private var buckets: [[Int]]

    public init(worldWidth: CGFloat = 1000.0, worldHeight: CGFloat = 1800.0, cellSize: CGFloat = 50.0) {
        self.worldWidth = worldWidth
        self.worldHeight = worldHeight
        self.cellSize = cellSize
        self.cols = Int(ceil(worldWidth / cellSize))
        self.rows = Int(ceil(worldHeight / cellSize))
        self.buckets = Array(repeating: [Int](), count: cols * rows)
    }

    public func clear() {
        for i in 0..<buckets.count {
            buckets[i].removeAll(keepingCapacity: true)
        }
    }

    private func getIndex(x: CGFloat, y: CGFloat) -> Int {
        let col = min(max(Int(x / cellSize), 0), cols - 1)
        let row = min(max(Int(y / cellSize), 0), rows - 1)
        return row * cols + col
    }

    public func insert(id: Int, x: CGFloat, y: CGFloat) {
        let idx = getIndex(x: x, y: y)
        buckets[idx].append(id)
    }

    public func getCandidatePairs() -> [(Int, Int)] {
        var pairs = [(Int, Int)]()
        for r in 0..<rows {
            for c in 0..<cols {
                let idx = r * cols + c
                let bucket = buckets[idx]
                let count = bucket.count
                if count > 1 {
                    for i in 0..<count {
                        for j in (i + 1)..<count {
                            pairs.append((bucket[i], bucket[j]))
                        }
                    }
                }
            }
        }
        return pairs
    }
}
