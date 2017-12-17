//
//  Easing.swift
//
//  Created by Jesse Lucas on 1/9/15.
//  Based on Robert Penner Easing Equations - http://robertpenner.com/easing/
import Foundation

struct Easing {
    // Linear
    static func noEasing(time t:Double, start b:Double, change c:Double, duration d:Double) -> Double {
        return c * t / d + b
    }
    
    // Quintic
    static func easeInQuint(time t:Double, start b:Double, change c:Double, duration d:Double) -> Double {
        let newT:Double = t/d
        
        return c*(newT)*newT*newT*newT*newT + b
    }
    
    // Sine
    static func easeInSine(time t:Double, start b:Double, change c:Double, duration d:Double) -> Double {
        return -c * cos(t/d * .pi) + c + b
    }
    
    static func easeOutSine(time t:Double, start b:Double, change c:Double, duration d:Double) -> Double {
        return c * sin(t/d * (.pi/2)) + b
    }
    
    static func easeInOutSine(time t:Double, start b:Double, change c:Double, duration d:Double) -> Double {
        return -c/2 * (cos(.pi*t/d) - 1) + b
    }
    
    // Exponential
    static func easeOutExpo(time t:Double, start b:Double, change c:Double, duration d:Double) -> Double {
        return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b;
    }
    
    // Quadratic
    static func easeOutQuad(time t:Double, start b:Double, change c:Double, duration d:Double) -> Double {
        let newT:Double = t/d
        return -c * (newT) * (newT-2) + b;
    }
}
