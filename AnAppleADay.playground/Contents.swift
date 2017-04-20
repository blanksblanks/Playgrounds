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
    func isVowel(s: String) -> Bool {
        return !["a","e","i","o","u"].contains(s.lowercased())
    }
    return Array(s.characters)
        .map{ String.init($0) }
        .filter(isVowel)
        .joined()
}

expect(disemvowel("you are so weird!")).to(equal("y r s wrd!"))



