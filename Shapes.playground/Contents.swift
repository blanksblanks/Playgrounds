// https://www.raywenderlich.com/119881/enums-structs-and-classes-in-swift

import Foundation

/// Pros of Swift enums
/// 1. Safer: Avoid misspelling errors from representing colors as strings
/// 2. Autocomplete
/// 3. Type is obvious
///
/// First class enums:
/// Extensions, protocols and methods, encapsulation, custom initializers, namespaces.
/// Great for readable way to name options, weekdays, states, optionals are .none or .some with associated value, instead of string constants or plain numbers


/// Each enum case can pair with different associated values
///
/// - named: the associated data is a ColorName value
/// - rgb: the associated data is 3 UInt8 numbers for red, green, blue
enum CSSColor {
    case named(ColorName)
    case rgb(UInt8, UInt8, UInt8)
}


/// All models - enums, structs and classes - can conform to a protocol
/// CustomStringConvertible makes the model printable
extension CSSColor: CustomStringConvertible {
    var description: String {
        switch self {
        case .named(let colorName):
            return colorName.rawValue
        case .rgb(let r, let g, let b):
            return String(format: "#%02X%02X%02X", r, g, b)
            //return String("R \(r), G \(g), B \(b)")
        }
    }
}

extension CSSColor {
    init(gray: UInt8) {
        self = .rgb(gray, gray, gray)
    }
}

/// Because the enum has a String representation, this is automatically equivalent to
/// ``` enum ColorName: String {
/// case black = "black"
/// case silver = "silver"
/// ... } ```
extension CSSColor {
    enum ColorName: String {
        case black, silver, gray, white, maroon, red, purple, fuchsia, green, lime, olive, yellow, navy, blue, teal, aqua
    }
}

/// Enums can be used as pure namespaces with static constants
/// No cases and extensions can't add new cases means it cannot be instantiated
enum Math {
    static let phi = 1.6180339887498948482 // golden mean
}

/// Type checked at compile time
let color1 = CSSColor.named(.red) // used to have to be ColorName.red
let color2 = CSSColor.rgb(0xAA, 0xAA, 0xAA)
let color3 = CSSColor(gray: 0xaa)
print("color 1 = \(color1), color2 = \(color2), color3 = \(color3)")


/// Structs store together stored properties
/// Structs are value types (makes new copy) while classes reference types (same object)
/// Structs and classes allow new types to be defined in an extension

protocol Drawable {
    func draw(with context: DrawingContext)
}

/// DrawingContext knows how to draw pure geometric types
protocol DrawingContext {
    func draw(_ circle: Circle)
    func draw(_ rectangle: Rectangle)
}

struct Circle : Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor .named(.red)
    var fillColor = CSSColor.named(.yellow)
    var center = (x: 80.0, y: 160.0)
    var radius = 60.0
    
    func draw(with context: DrawingContext) {
        context.draw(self)
    }
}

struct Rectangle : Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor.named(.teal)
    var fillColor = CSSColor.named(.aqua)
    var origin = (x: 110.0, y: 10.0)
    var size = (width: 100.0, height: 130.0)
    
    func draw(with context: DrawingContext) {
        context.draw(self)
    }
}

final class SVGContext : DrawingContext {
    
    private var commands: [String] = []
    
    var width = 250
    var height = 250
    
    func draw(_ circle: Circle) {
        commands.append("<circle cx='\(circle.center.x)' cy='\(circle.center.y)\' r='\(circle.radius)' stroke='\(circle.strokeColor)' fill='\(circle.fillColor)' stroke-width='\(circle.strokeWidth)'  />")
    }
    
    func draw(_ rectangle: Rectangle) {
        commands.append("<rect x='\(rectangle.origin.x)' y='\(rectangle.origin.y)' width='\(rectangle.size.width)' height='\(rectangle.size.height)' stroke='\(rectangle.strokeColor)' fill='\(rectangle.fillColor)' stroke-width='\(rectangle.strokeWidth)' />")
    }
    
    var svgString: String {
        var output = "<svg width='\(width)' height='\(height)'>"
        for command in commands {
            output += command
        }
        output += "</svg>"
        return output
    }
    
    var htmlString: String {
        return "<!DOCTYPE html><html><body>" + svgString + "</body></html>"
    }
}

struct SVGDocument {
    var drawables: [Drawable] = []
    
    var htmlString: String {
        let context = SVGContext()
        for drawable in drawables {
            drawable.draw(with: context)
        }
        return context.htmlString
    }
    
    mutating func append(_ drawable: Drawable) {
        drawables.append(drawable)
    }
}

var document = SVGDocument()

let rectangle = Rectangle()
document.append(rectangle)

let circle = Circle()
document.append(circle)

let htmlString = document.htmlString
print(htmlString)

import WebKit
import PlaygroundSupport
let view = WKWebView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
view.loadHTMLString(htmlString, baseURL: nil)
PlaygroundPage.current.liveView = view

/// Classes
/// Swift introduces `override` keyword to make it clear you're changing existing behavior
/// 
/// Cons:
/// Checks at runtime instead of compile time that derived classes have to overwrite a method
/// Subclasses have to deal with initialization of base class data
/// Tricky to future proof a base-class i.e. think about a Line subclass
/// Reference cycles/ memory leaks and shared reference semantics
///
/// Pros:
/// Large expensive to copy objects
/// Many views display the same object in sync

/// Enums, structs, classes all let you do computed properties

extension Circle {
    var diameter: Double {
        get {
            return radius * 2
        }
        set {
            radius = newValue / 2
        }
    }

    /// Getter only computed properties
    var area: Double {
        return radius * radius * Double.pi
    }
    
    var perimeter: Double {
        return radius * 2 * Double.pi
    }
    
    /// OK to mutate the struct
    mutating func shift(x: Double, y: Double) {
        center.x += x
        center.y += y
    }
}

/// Retroactive modeling and type constraining
protocol ClosedShape {
    var area: Double { get }
    var perimeter: Double { get }
}

extension Rectangle {
    var area: Double {
        return size.width * size.height
    }
    var perimeter: Double {
        return 2 * (size.width + size.height)
    }
}

extension Circle: ClosedShape {}
extension Rectangle: ClosedShape {}

func totalPerimeter(_ shapes: [ClosedShape]) -> Double {
    return shapes.reduce(0) { $0 + $1.perimeter }
}

totalPerimeter([circle, rectangle])



























