//: [Previous](@previous)

import Foundation

/*
 
 4/23/17
 Island Count
 
 Given a 2D array binaryMatrix of 0s and 1s, implement a function getNumberOfIslands that returns the number of islands of 1s in binaryMatrix.
 
 An island is defined as a group of adjacent values that are all 1s. A cell in binaryMatrix is considered adjacent to another cell if they are next to each either on the same row or column. Note that two values of 1 are not part of the same island if they’re sharing only a mutual “corner” (i.e. they are diagonally neighbors).
 
 input:  binaryMatrix =
 [ [0,    1,    0,    1,    0],
 [0,    0,    1,    1,    1],
 [1,    0,    0,    1,    0],
 [0,    1,    1,    0,    0],
 [1,    0,    1,    0,    1] ]
 
 output: 6
 
 */


/*
 
 5/31/17
 Matrix Spiral Copy
 
 Given a 2D array (matrix) inputMatrix of integers, create a function spiralCopy that copies inputMatrix’s values into a 1D array in a spiral order, clockwise. Your function then should return that array. Analyze the time and space complexities of your solution.
 Example:
 input:  inputMatrix  = [ [1,    2,   3,  4,    5],
 [6,    7,   8,  9,   10],
 [11,  12,  13,  14,  15],
 [16,  17,  18,  19,  20] ]
 
 output: [1, 2, 3, 4, 5, 10, 15, 20, 19, 18, 17, 16, 11, 6, 7, 8, 9, 14, 13, 12]
 
 */

func spiralCopy(matrix: [[Int]]) -> [Int] {
    // result
    var arr: [Int] = []
    
    // bounds
    var top = 0
    var right = matrix[0].count - 1
    var bottom = matrix.count - 1
    var left = 0
    
    // indices
    var row = 0
    var col = 0
    
    while (top <= bottom || right >= left) {
        // traverse right
        while (col < right) {
            arr.append(matrix[row][col])
            col += 1
        }
        top += 1
        //traverse down
        while (row < bottom) {
            arr.append(matrix[row][col])
            row += 1
        }
        right -= 1
        // traverse left
        while (col > left) {
            arr.append(matrix[row][col])
            col -= 1
        }
        bottom -= 1
        // traverse up
        while (row > top) {
            arr.append(matrix[row][col])
            row -= 1
        }
        left += 1
    }
    return arr
}

let inputMatrix  = [ [1,    2,   3,  4,    5],
                     [6,    7,   8,  9,   10],
                     [11,  12,  13,  14,  15],
                     [16,  17,  18,  19,  20] ]

let expectedOutput = [1, 2, 3, 4, 5, 10, 15, 20, 19, 18, 17, 16, 11, 6, 7, 8, 9, 14, 13, 12]

let output = spiralCopy(matrix: inputMatrix)

for i in (0..<expectedOutput.count) {
    expect(output[i]).to(equal(expectedOutput[i]))
}

//: [Next](@next)
