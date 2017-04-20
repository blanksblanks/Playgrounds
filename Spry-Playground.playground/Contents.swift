/// Starter Playground template with Spry testing set up and
/// a Device enum to easily render views for different devices

import UIKit
import PlaygroundSupport

enum Device {
    case iPhone(PhoneModel, Orientation)
    case iPad(Orientation)
    
    enum PhoneModel {
        case four, five, six, sixPlus, seven
    }
    
    enum Orientation {
        case landscape, portrait
    }
}


extension Device {
    var size: CGSize {
        let size: CGSize
        switch self {
        case .iPhone(let model, let orientation):
            switch model {
            case .four:
                size = CGSize(width: 320, height: 480)
            case .five:
                size = CGSize(width: 320, height: 568)
            case .six, .seven:
                size = CGSize(width: 375, height: 677)
            case .sixPlus:
                size = CGSize(width: 414, height: 736)
            }
            return orientation == .portrait ? size : size.flipped
        case .iPad(let orientation):
            size = CGSize(width: 768, height: 1024)
            return orientation == .portrait ? size : size.flipped
        }
    }
}

extension CGSize {
    var flipped: CGSize {
        return CGSize(width: self.height, height: self.width)
    }
}

let vc = UIViewController()
let device = Device.iPhone(.four, .portrait)
vc.view.backgroundColor = .white
vc.view.frame.size = device.size

PlaygroundPage.current.liveView = vc.view






/**
 Below are some examples -- you can delete them once you're ready to get started.
 */

var size = CGSize(width: 3, height: 4)
Int(size.width) == 3
expect(size.width).to(equal(3))
expect(size.height).to(equal(4))
expect(size.flipped.width).to(equal(4))
expect(size.flipped.height).to(equal(3))


enum Kind {
    case one, two
}

var kind: Kind
expect(Kind.one).to(beAKindOf(Kind.self))

let instance = 45
expect(Kind.one).to(beAnInstanceOf(Kind.self))
expect(Kind.one).to(beAnInstanceOf(String.self))

let close: Float = 0.5
expect(close).to(beCloseTo(1, within: 0.6))

let empty: [Int] = []
expect(empty).to(beEmpty())

let begin = "ABC"
expect(begin).to(beginWith("ABC"))

let end = "XYZ"
expect(end).to(endWith("xyz"))

let value = 5
expect(value).to(beGreaterThan(0))
expect(value).to(beGreaterThanOrEqualTo(6))
expect(value).to(beLessThan(0))
expect(begin).to(beLessThanOrEqualTo(end))

let v1 = "Shaps"
let v2 = "Shaps"
expect(v1).toNot(beIdenticalTo(v2))
expect(v1).to(equal(v2))

let result: Bool? = nil
expect(result).toNot(beTrue())
expect(result).to(beFalsy())
expect(result).to(beNil())

let void: Void
expect(void).to(beVoid())

let numbers = [1, 2, 4]
expect(numbers).to(contain(2))
expect(numbers).to(haveCount(3))

let regex = "<html />"
expect(regex).to(match("<\\w.+/>"))

