//: [Previous](@previous)

import Foundation

/*
 
 5/30/17
 Find a missing number
 
 1. Find the one missing number in an sorted array of N-1 integers. There are no duplicates.
 
 [1, 2, 4, 6, 3, 7, 8]
 5
 
 2. What if it is unsorted?
 
 2. What if there is one or more integers missing in a sorted array?
 
 [0,1,3,4,5,7,8]
 2, 6
 
 4. Find the smallest positive number missing from an unsorted array.
 
 Input:  {2, 3, 7, 6, 8, -1, -10, 15}
 Output: 1
 
 Input:  { 2, 3, -7, 6, 8, 1, -10, 15 }
 Output: 4
 
 Input: {1, 1, 0, -1, -2}
 Output: 2
 
 If you have hashtable/dictionary at hand, you only need to iterate the input array once to find the min and max, and at the same time storing the elements as keys of a hashtable. Then iterate from min to max to search for missing elements in the hashtable.
 
 Using arrays, you need to iterate the input array twice. Once to find the min and max. Then allocate an intermediate array of size max-min, and then iterate over the input array again to record elements by marking the position at element-min as 1 or true or whatever your intermediate array element type is.
 
 5. How to find the missing K elements out of the unsorted natural N elements in an integer array? Time complexity should be O(n) with 3 extra variables of space.
 
 */

//: [Next](@next)
