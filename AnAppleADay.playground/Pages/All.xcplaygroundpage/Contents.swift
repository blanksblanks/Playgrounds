/**
 
 Nimble Matchers
 
 beAKindOf              beAnInstanceOf         beCloseTo(_, within)   beEmpty
 beginWith              endWith                beGreaterThan          beGreaterThanOrEqualTo etc.
 beIdenticalTo          equal                  beTrue                 beFalsy
 beNil                  beVoid                 contain                haveCount         match(regex)
 
 */

import Foundation

/*
 
 4/20/17
 Disemvowel
 
 Your task is to write a function that takes a string and return a new string with all vowels removed.
 
 */

func disemvowel(_ s: String) -> String {
    let vowels = Set("aeiouAEIOU".characters)
    return String(s.characters.filter { !vowels.contains($0) })
}

expect(disemvowel("you are so weird!")).to(equal("y r s wrd!"))


/*
 
 4/21/17
 
 Implement an algorithm to etermine if a string has all unique characters. What if you cannot use additional data structures?
 
 */
func hasUniqueCharacters(_ s: String) -> Bool {
    guard s.characters.count < 128 else { return false } // assuming ascii characters only
    var seen = Set<Character>()
    for character in s.characters {
        guard !seen.contains(character) else { return false }
        seen.insert(character)
    }
    return true
}

expect(hasUniqueCharacters("banana")).to(beFalsy())
expect(hasUniqueCharacters("abortive")).to(beTrue())


/*
 
 4/30/17
 Find The Duplicates
 
 Given two sorted arrays arr1 and arr2 of passport numbers, implement a function findDuplicates that returns an array of all passport numbers that are both in arr1 and arr2. Note that the output array should be sorted in an ascending order.
 
 Let N and M be the lengths of arr1 and arr2, respectively. Solve for two cases and analyze the time & space complexities of your solutions: M ≈ N - the array lengths are approximately the same M ≫ N - arr2 is much bigger than arr1.
 
 Example:
 
 input:  arr1 = [1, 2, 3, 5, 6, 7], arr2 = [3, 6, 7, 8, 20]
 
 output: [3, 6, 7] # since only these three values are both in arr1 and arr2
 
 */

let arr1 = [1, 2, 3, 5, 6, 7]
let arr2 = [3, 6, 7, 8, 20]

let expectedArr = [3, 6, 7]

// arr 1 ... go through all values -> dictionary/set
// arr 2 ... go through all values -> check if it's inside dictionary
// O(M+N), try it without an additional data structure

func naiveFindDuplicates(arr1: [Int], arr2: [Int]) -> [Int] {
    var seenNumbers = [Int: Bool]()
    var duplicates = [Int]()
    for element in arr1 {
        seenNumbers[element] = true
    }
    for element in arr2 {
        if let _ = seenNumbers[element] {
            duplicates.append(element)
        }
    }
    return duplicates
}

// take advantage of the knowledge that the arrays are sorted
// have two pointers for arr 1 and 2
// move pointer in arr 1 if

func findDuplicates(arr1: [Int], arr2: [Int]) -> [Int] {
    var duplicates = [Int]()
    var i = 0
    var j = 0
    while (i < arr1.count && j < arr2.count) {
        let element1 = arr1[i]
        let element2 = arr2[j]
        if (element1 < element2) {
            i = i + 1
            continue
        } else if (element2 < element1) {
            j = j + 1
            continue
        } else { // element1 == element2
            i = i + 1
            j = j + 1
            duplicates.append(element1)
        }
    }
    return duplicates  
}

let result = findDuplicates(arr1: arr1, arr2: arr2)
expect(result.count).to(equal(3))
for i in (0..<result.count) {
    expect(result[i]).to(equal(expectedArr[i]))
}

/*
 
 5/2/17
 Array Index & Element Equality
 
 Given a sorted array arr of distinct integers, write a function indexEqualsValueSearch that returns an index i for which arr[i] == i. Return -1 if there is no such index. Analyze the time and space complexities of your solution and explain its correctness.
 
 Examples:
 
 input: arr = [-8,0,2,5]
 output: 2 # since arr[2] == 2
 
 input: arr = [-1,0,3,6]
 output: -1 # since no index in arr satisfies arr[i] == i.
 
 */

// O(N) time
func indexEqualsValueSearch(arr: [Int]) -> Int {
    var i: Int = 0
    while (i < arr.count) {
        if (i == arr[i]) { return i }
        if (i < arr[i]) { return -1 }
        i = i + 1
    }
    return -1
}

// take advantage of knowing the array is sorted
// O(logN)
func indexEqualsValueBinarySearch(arr: [Int]) -> Int {
    var mid: Int = arr.count / 2 // start in the 'mid'
    var start: Int = 0
    var end: Int = arr.count
    while (mid < end) {
        if (mid == arr[mid]) { return mid } // found a matching index
        if (mid < arr[mid]) { // if pointer in less than element
            end = mid - 1 // we can rule out right half of numbersand assign a new 'end' pointer
        } else if (mid > arr[mid]) {
            start = mid + 1 // we can rule out left half of numbers and assign a new 'start' pointer
        }
        mid = (end - start) / 2 + start // then we pick a new 'mid' pointer to check in the loop
    }
    return -1
}

let arr_1 = [-8,0,2,5] // 0,1,2,3
let arr_2 = [-1,0,3,6] // 0,1,2,3
let arr_3 = [-8,0,2,5,10,12,15,16] // 0, 4, 8 -> 0, 1, 3

// Average case: O(N/2)

print(indexEqualsValueSearch(arr: arr_1))
print(indexEqualsValueSearch(arr: arr_2))
print(indexEqualsValueBinarySearch(arr: arr_3))






