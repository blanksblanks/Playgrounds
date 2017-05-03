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
 
 4/24/17
 Flatten A Dictionary
 
 A dictionary is a type of data structure that is supported natively in all major interpreted languages such as JavaScript, Python, Ruby and PHP, where it’s known as an Object, Dictionary, Hash and Array, respectively. In simple terms, a dictionary is a collection of unique keys and their values. The values can typically be of any primitive type (i.e an integer, boolean, double, string etc) or other dictionaries (dictionaries can be nested).
 
 Given a dictionary dict, write a function flattenDictionary that returns a flattened version of it .
 
 If you’re using a compiled language such Java, C++, C#, Swift and Go, you may want to use a Map/Dictionary/Hash Table that maps strings (keys) to a generic type (e.g. Object in Java, AnyObject in Swift etc.) to allow nested dictionaries.
 
 Example:
 
 input:  dict = {
 Key1 : 1,
 Key2 : {
 a : 2,
 b : 3,
 c : {
 d : 3,
 e : 1
 }
 }
 }
 
 output: {
 Key1: 1,
 Key2.a: 2,
 Key2.b : 3,
 Key2.c.d : 3,
 Key2.c.e : 1
 }
 Important: when you concatenate keys, make sure to add the dot character between them. For instance contacting Key2, c and d the result key would be Key2.c.d.
 */

/**
 
 4/28/17
 Word Count Engine
 
 Implement a document scanning function wordCountEngine, which receives a string document and returns a list of all unique words in it and their number of occurrences, sorted by the number of occurrences in a descending order. Assume that all letters are in english alphabet. You function should be case-insensitive, so for instance, the words “Perfect” and “perfect” should be considered the same word.
 
 The engine should strip out punctuation (even in the middle of a word) and use whitespaces to separate words.
 
 Examples:
 
 input:  document = "Practice makes perfect. you'll only
 get Perfect by practice. just practice!"
 
 output: [ ["practice", "3"], ["perfect", "2"],
 ["makes", "1"], ["get", "1"], ["by", "1"],
 ["just", "1"], ["youll", "1"], ["only", "1"] ]
 
 */

/*
 
 4/30/17
 Find The Duplicates
 
 Given two sorted arrays arr1 and arr2 of passport numbers, implement a function findDuplicates that returns an array of all passport numbers that are both in arr1 and arr2. Note that the output array should be sorted in an ascending order.
 
 Let N and M be the lengths of arr1 and arr2, respectively. Solve for two cases and analyze the time & space complexities of your solutions: M ≈ N - the array lengths are approximately the same M ≫ N - arr2 is much bigger than arr1.
 
 Example:
 
 input:  arr1 = [1, 2, 3, 5, 6, 7], arr2 = [3, 6, 7, 8, 20]
 
 output: [3, 6, 7] # since only these three values are both in arr1 and arr2
 
 */


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

