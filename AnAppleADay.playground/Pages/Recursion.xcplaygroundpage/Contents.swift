//: [Previous](@previous)

import Foundation

//
// 5/4/17
//
// The following iterative sequence is defined for the set of positive integers:
//
// n → n/2 (n is even)
// n → 3n + 1 (n is odd)
//
// Using the rule above and starting with 13, we generate the following sequence:
//
// 13 → 40 → 20 → 10 → 5 → 16 → 8 → 4 → 2 → 1
//
// Which starting number, under one million, produces the longest chain?
//
// NOTE: Once the chain starts the terms are allowed to go above one million.
//

let startInt = 13

func chain(_ start: Int) -> Int {
    var count = 1
    var n = start
    while (n != 1) {
        count = count + 1
        if (n%2 == 0) {
            n = n / 2
        } else {
            n = 3 * n + 1
        }
    }
    return count
}

// for recursion it's useful to think of your stopping case or base case
func rchain(_ start: Int) -> Int {
    if (start == 1) { // when n == 1, stop
        return 1
    }
    
    if (start%2 == 0) {
        return 1 + rchain(start/2)
    } else {
        return 1 + rchain(3 * start + 1)
    }
}

let length = chain(13)
print("length = \(length)")

let rlength = rchain(13)
print("rlength = \(rlength)")

func findLongestChain() -> Int {
    var maxLength = 1
    var max = 1
    for x in (1...1_000) {
        let length = chain(x)
        if (length > maxLength) {
            maxLength = length
            max = x
        }
    }
    return max
}

let winner = findLongestChain()
print("Longest chain = \(winner)")

// thik

//: [Next](@next)
