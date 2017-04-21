/**
 Nimble matchers:
 beAKindOf
 beAnInstanceOf
 beCloseTo(_, within)
 beEmpty
 beginWith
 endWith
 beGreaterThan
 beGreaterThanOrEqualTo etc.
 beIdenticalTo
 equal
 beTrue
 beFalsy
 beNil
 beVoid
 contain
 haveCount
 match(regex)
 */

import Foundation

/// 4/20/17

func disemvowel(_ s: String) -> String {
    let vowels = Set("aeiouAEIOU".characters)
    return String(s.characters.filter { !vowels.contains($0) })
}

expect(disemvowel("you are so weird!")).to(equal("y r s wrd!"))


/// 4/21/17

/// This function assumes an ASCII string
func hasUniqueCharacters(_ s: String) -> Bool {
    guard s.characters.count < 128 else { return false }
    var seen = Set<Character>()
    for character in s.characters {
        guard !seen.contains(character) else { return false }
        seen.insert(character)
    }
    return true
}

expect(hasUniqueCharacters("banana")).to(beFalsy())
expect(hasUniqueCharacters("abortive")).to(beTrue())
