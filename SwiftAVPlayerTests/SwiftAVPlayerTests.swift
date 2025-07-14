//
//  SwiftAVPlayerTests.swift
//  SwiftAVPlayerTests
//
//  Created by bamiboo.han on 7/1/25.
//

import Testing
import UIKit

/**
 [Swift Testing Guide]
 Reference - https://developer.apple.com/videos/play/wwdc2024/10179/
 - Test functions
 - Expectations
 - Traits
 - Suites
 
 [Terminal Commands]
 $ `swift test`
 */

@Suite("Swift Testing - Guide")
struct SwiftAVPlayerTests {
    /*
     If you initialize something here, it won’t be shared across @Test methods.
     Instead, it’ll be initialized before each @Test execution.
    */
    
    init() async throws {
        // before each test
        print("init")
    }
    /*
    deinit {
        // called after each test, but not allowed in struct
        print("deinit")
    }
     */
    
    /// Customize the display name of a test
    @Test("#expect, #require")
    func example() throws {
        // use `#expect` when you need to check it's going well.
        #expect(true)
        print("hello")
        #expect(false)
        print("my name")
        
        // use `try #require` when you have to check it's valid.
        try #require(true)
        print("is...")
        try #require(false)
        print("hobin") // won't be called because #require(false) throwed an error.
    }
    
    /// A struct with @Test methods is automatically treated as a test suite.
    /// Use @Suite on the struct when you need to apply common traits or settings to all tests within.
    @Suite("Swift Testing - Traits", .timeLimit(.minutes(1)), .serialized, .tags(.swiftTestingTraits))
    struct SwiftTestingTraits {
        /// Reference an issue from a bug tracker
        @Test("bug", .bug("https://www.naver.com", "title here"))
        func bugExample() throws {
            #expect(true)
        }
        
        /// Add a custom tag to a test
        @Test("custom tag", .tags(.critical))
        func tagsExample() throws {
            #expect(true)
        }
        
        /// Specify a runtime condition for a test
        @Test(.enabled(if: false))
        func enabledExample() throws {
            #expect(false)
        }
        
        /// Unconditionally disable a test
        @Test(.disabled("Currently broken"))
        func disabledExample() throws {
            #expect(false)
        }
        
        /// Limit a test to certain OS versions
        @Test("Swift Testing - @available") @available(iOS 16.0, *)
        func availableExample() throws {
            #expect(true)
        }
        
        /// Set a maximum time limit for a test
        @Test(.timeLimit(.minutes(1)))
        func timeLimitExample() throws {
            #expect(true)
        }
    }
    
    /// Runs the test multiple times, once for each value in `arguments`.
    @Test(arguments: [
        UIColor.random,
        UIColor.random,
        UIColor.random,
        UIColor.random,
        UIColor.random,
        UIColor.random
    ])
    func randomColor(_ color: UIColor) throws {
        let rgbaInts = try #require(color.rgbaInts)
        print(rgbaInts)
        #expect(0 <= rgbaInts.red && rgbaInts.red <= 255)
        #expect(0 <= rgbaInts.green && rgbaInts.green <= 255)
        #expect(0 <= rgbaInts.blue && rgbaInts.blue <= 255)
    }
}

// MARK: - Helpers

private extension Tag {
    @Tag static var swiftTestingTraits: Self
    @Tag static var critical: Self
}

private extension UIColor {
    /// Returns a random color with full opacity.
    static var random: UIColor {
        let red   = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue  = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// Returns the red component as an integer (0–255), or nil if it can't be extracted.
    var redInt: Int? {
        var r: CGFloat = 0
        guard self.getRed(&r, green: nil, blue: nil, alpha: nil) else { return nil }
        return Int(round(r * 255))
    }

    /// Returns the green component as an integer (0–255), or nil if it can't be extracted.
    var greenInt: Int? {
        var g: CGFloat = 0
        guard self.getRed(nil, green: &g, blue: nil, alpha: nil) else { return nil }
        return Int(round(g * 255))
    }

    /// Returns the blue component as an integer (0–255), or nil if it can't be extracted.
    var blueInt: Int? {
        var b: CGFloat = 0
        guard self.getRed(nil, green: nil, blue: &b, alpha: nil) else { return nil }
        return Int(round(b * 255))
    }

    /// Returns all RGBA components (0–255 for rgb, 0.0–1.0 for alpha) as a tuple, or nil if unavailable.
    var rgbaInts: (red: Int, green: Int, blue: Int, alpha: CGFloat)? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return (
            red: Int(round(r * 255)),
            green: Int(round(g * 255)),
            blue: Int(round(b * 255)),
            alpha: a
        )
    }
}
