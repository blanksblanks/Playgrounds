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



