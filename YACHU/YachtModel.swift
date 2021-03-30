//
//  YachtModel.swift
//  YACHU
//
//  Created by Yundong Lee on 2021/03/30.
//

import Foundation

struct YachtModel {
    // currentDices는 5 - tmpSave
    var currentDices : [Dice] = []
    var tmpSave : [Dice] = []
    var totalDice : [Dice] = []{
        didSet{
            totalDice.sort { (first, second) -> Bool in
                return first.rawValue < second.rawValue
            }
        }
    }
    
    // scores.
    var oneScore : Int?
    var twoScore : Int?
    var threeScore : Int?
    var fourScore : Int?
    var fiveScore : Int?
    var sixScore : Int?
    
    var choiceScore : Int?
    var fourOfAKind : Int?
    var fullHouse : Int?
    var smallStraight : Int?
    var largeStrait : Int?
    var yatchu : Int?
    
    var tmponeScore = 0
    var tmptwoScore = 0
    var tmpthreeScore = 0
    var tmpfourScore = 0
    var tmpfiveScore = 0
    var tmpsixScore = 0
    
    var tmpChoiceScore = 0
    var tmpFourOfAKind = 0
    
    var tmpFullHouse = 0
    
    var tmpSmallStraight = 0
    var tmpLargeStrait = 0
    
    var tmpYatchu = 0

    
    
    var rollTime = 0
    
    mutating func rollDice(){
        clean()
        totalDice = []
        
        for _ in 0 ..< 5 - tmpSave.count{
            totalDice.append(Dice.randomDice())
        }
        possibleScoreUpdate()
    }
    
    
    mutating func clean(){
        tmponeScore = 0
        tmptwoScore = 0
        tmpthreeScore = 0
        tmpfourScore = 0
        tmpfiveScore = 0
        tmpsixScore = 0
        tmpChoiceScore = 0
        tmpFourOfAKind = 0
        tmpLargeStrait = 0
        tmpSmallStraight = 0
        tmpFullHouse = 0
        tmpYatchu = 0
    }
    
    func printPossibleOutcomes(){
        print(tmponeScore)
        print(tmptwoScore)
        print(tmpthreeScore)
        print(tmpfourScore)
        print(tmpfiveScore)
        print(tmpsixScore)
        print(tmpChoiceScore)
        print(tmpFourOfAKind)
        print(tmpLargeStrait)
        print(tmpSmallStraight) // 스몰 스트레이트만 좀 틀림.
        print(tmpFullHouse)
        print(tmpYatchu)

    }
    
    mutating func keepDice(index : Int){
        let dice = totalDice.remove(at: index)
        tmpSave.append(dice)
        
        print("total dices : \(totalDice)")
        print("saved dicesd : \(tmpSave)")
    }
    
    mutating func backToRoll(index : Int){
        let dice = tmpSave.remove(at: index)
        totalDice.append(dice)
    }
    
    
    mutating func possibleScoreUpdate(){
//        totalDice = currentDices + tmpSave

        for dice in totalDice{
            if dice == .one{
                tmponeScore = tmponeScore + dice.rawValue
            }else if dice == .two{
                tmptwoScore = tmptwoScore + dice.rawValue
            }else if dice == .three{
                tmpthreeScore = tmpthreeScore + dice.rawValue
            }else if dice == .four{
                tmpfourScore = tmpfourScore + dice.rawValue
            }else if dice == .five{
                tmpfiveScore = tmpfiveScore + dice.rawValue
            }else if dice == .six{
                tmpsixScore = tmpsixScore + dice.rawValue
            }
        }
        
        // tmpChoiceScore 계산.
        for dice in totalDice{
            tmpChoiceScore += dice.rawValue
        }
        
        // four of a kind 계산.  오류 남.
        var sameCount = 0
        var prevValue = totalDice[0].rawValue
        for dice in totalDice{
            if prevValue != dice.rawValue{
                sameCount = 0
            }else{
                sameCount += 1
            }
            prevValue = dice.rawValue
        }
        
        if sameCount == 4{
            tmpFourOfAKind = tmpChoiceScore
        }else{
            tmpFourOfAKind = 0
        }
        
        // full house count.
        if totalDice[0].rawValue == totalDice[1].rawValue && totalDice[1].rawValue ==  totalDice[2].rawValue && totalDice[3].rawValue == totalDice[4].rawValue{
            tmpFullHouse = (totalDice[0].rawValue * 3) + (totalDice[4].rawValue * 2)
        }else if totalDice[0].rawValue == totalDice[1].rawValue && totalDice[2].rawValue == totalDice[3].rawValue && totalDice[3].rawValue == totalDice[4].rawValue{
            tmpFullHouse = (totalDice[0].rawValue * 2) + (totalDice[4].rawValue * 3)
        }else{
            tmpFullHouse = 0
        }
        
        
        
//        // small straight
        var tmpArray : [Int] = []

        for card in totalDice{
            if !tmpArray.contains(card.rawValue){
                tmpArray.append(card.rawValue)
            }
        }
        var wrongCount = 0
        for tmp in tmpArray.indices{
            if tmp != tmpArray.count - 1{
                if tmpArray[tmp] + 1 != tmpArray[tmp + 1]{
                    wrongCount += 1
                }
            }
            
        }
        
        if wrongCount > 1{
            tmpSmallStraight = 0
        }else{
            tmpSmallStraight = tmpChoiceScore
        }
        
        
        // large straight
        for index in totalDice.indices{
            if index != totalDice.count - 1{
                if totalDice[index].rawValue + 1 != totalDice[index + 1].rawValue{
                    tmpLargeStrait = 0
                    break
                }else{
                    tmpLargeStrait += totalDice[index].rawValue
                }
            }
            
        }
        
        // yachu
        for index in totalDice.indices{
            if totalDice[index].rawValue != totalDice[index + 1].rawValue{
                tmpYatchu = 0
                break
            }else{
                tmpYatchu += totalDice[index].rawValue
            }
        }
        
        
        
        
        
        
        
    }
    
    
    
}
