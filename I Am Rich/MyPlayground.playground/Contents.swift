import UIKit
import Foundation
//key: value
var studentsAndScores = ["Amy": 88, "James": 2, "Helen": 98]
var minScore = Int.min
var maxScore = Int.max

for (_, value) in studentsAndScores{
    print("minScore")
    print(minScore)
    print("value")
    print(value)
    
    
    maxScore = max(value, minScore)
    minScore = min(value, maxScore)
    
    
    print("max score")
    print(maxScore)
}

//print("max score: \(maxScore)")

