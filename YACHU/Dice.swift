//
//  Dice.swift
//  YACHU
//
//  Created by Yundong Lee on 2021/03/30.
//

import Foundation

enum Dice : Int{
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    
    static func randomDice() -> Dice {
        let rand = Int.random(in: 1...6)
            return Dice(rawValue: Int(rand))!
        }
}
