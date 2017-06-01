//: [Previous](@previous)

import Foundation

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



/*
 import java.io.*;
 import java.util.*;
 
 class Solution {
	
 static HashMap<String, String> flattenDictionary(HashMap<String, Object> dict, String prefix,
 HashMap<String, String> output)  {
 for (Map.Entry<String, Object> entry : dict.entrySet()){
 String key = entry.getKey();
 Object value = entry.getValue();
 
 if (value instanceof String){
 if (!prefix.isEmpty()){
 output.put(prefix + "." + key, ((String)value));
 }
 else {
 output.put(key, (String) value);
 
 }
 }
 else {
 
 flattenDictionary((HashMap<String,Object>)value, key, output);
 }
 }
 return output;
 
 
 }
 
 public static void main(String[] args) {
 HashMap<String, Object> map = new HashMap<>();
 HashMap<String, String> innerMap = new HashMap<>();
 HashMap<String, String> result = new HashMap<>();
 innerMap.put("a", "1");
 innerMap.put("b", "2");
 map.put("key2", "1");
 map.put("Key1", innerMap);
 HashMap<String, String> output = flattenDictionary(map, "", result);
 for (Map.Entry<String, String> entry : output.entrySet()){
 System.out.println(entry.getKey() + " : " + entry.getValue());
 }
 }
 
 }
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

let document = "Practice makes perfect. you'll only get Perfect by practice. just practice!"

func wordCountEngine(_ document: String) -> [[String]] {
    let words = document.components(separatedBy: .punctuationCharacters)
        .joined()
        .components(separatedBy: .whitespaces)
        .map { $0.lowercased() }
    let counter = words.reduce([String: Int]()) { acc, word in
        var c = acc
        c[word] = (c[word] ?? 0) + 1
        return c
    }
    let frequencies = counter.reduce([Int: [String]]()) { acc, pair in
        var f = acc
        let word = pair.key
        let count = pair.value
        if f[count] == nil {
            f[count] = []
        }
        f[count]?.append(word)
        return f
    }
    
    var wordCount = [[String]]()
    for (count, wordList) in frequencies {
        for word in wordList {
            wordCount.append([word, String(count)])
        }
    }
    return wordCount
    //    return frequencies.reduce([[String]]()) { acc, pair in
    //        var wc = acc
    //        let frequency = pair.key
    //        let wordList = pair.value
    //        for word in wordList {
    //            wc.append([word, String(frequency)])
    //        }
    //        return wc
    //    }
}

// Annoying this no longer works
//["a": "b"].reduce(["c": "d"]) { (var dict, pair) in
//    dict[pair.0] = pair.1
//    return dict
//}

let wc = wordCountEngine("How much wood could a woodchuck chuck if a woodchuck could chuck wood? As much wood as a woodchuck could chuck, if a woodchuck could chuck wood.")
print(wc)



//: [Next](@next)
