//
//  YachtModel.swift
//  YACHU
//
//  Created by Yundong Lee on 2021/03/30.
//

import Foundation

struct YachtModel {
    // totalDice
    var totalDice : [Dice] = []
    var tmpSave : [Dice] = []
    // currentDice 는 5 - tmpSave
    var currentDice : [Dice] = []{
        didSet{
            currentDice.sort { (first, second) -> Bool in
                return first.rawValue < second.rawValue
            }
        }
    }

    var actualScore : [Int?] = [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]
    var tmpScore = [0,0,0,0,0,0,0,0,0,0,0,0]
    var newTurn : Bool{
        get{
            for score in tmpScore{
                if score != 0{
                    return false
                }
            }
            return true
        }
    }
   
    
    var rollTime = 0
    
    mutating func rollDice(){
        if rollTime < 3{
            clean()
            currentDice = []
            
            for _ in 0 ..< 5 - tmpSave.count{
                currentDice.append(Dice.randomDice())
            }
            totalDice = currentDice + tmpSave
            possibleScoreUpdate()
            rollTime += 1
        }
    }
    
    
    mutating func clean(){
        tmpScore = [0,0,0,0,0,0,0,0,0,0,0,0]
    }
    
    func printPossibleOutcomes(){
        for score in tmpScore{
            print(score)
        }
    }
    
    mutating func selectScore(at index: Int){
        actualScore[index] = tmpScore[index]
        
        // end turn.
        rollTime = 0
        tmpSave = []
        totalDice = []
        clean()
        currentDice = []
    }
    
    mutating func keepDice(index : Int){
        let dice = currentDice.remove(at: index)
        tmpSave.append(dice)
    }
    
    mutating func backToRoll(index : Int){
        let dice = tmpSave.remove(at: index)
        currentDice.append(dice)
    }
}














extension YachtModel{
    mutating func possibleScoreUpdate(){
        for dice in totalDice{
            if dice == .one{
                tmpScore[0] = tmpScore[0] + dice.rawValue
            }else if dice == .two{
                tmpScore[1] = tmpScore[1] + dice.rawValue
            }else if dice == .three{
                tmpScore[2] = tmpScore[2] + dice.rawValue
            }else if dice == .four{
                tmpScore[3] = tmpScore[3] + dice.rawValue
            }else if dice == .five{
                tmpScore[4] = tmpScore[4] + dice.rawValue
            }else if dice == .six{
                tmpScore[5] = tmpScore[5] + dice.rawValue
            }
        }
        
        // tmpChoiceScore 계산.
        for dice in totalDice{
            tmpScore[6] += dice.rawValue
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
            tmpScore[7] = tmpScore[6]
        }else{
            tmpScore[7] = 0
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
            tmpScore[8] = 0
        }else{
            tmpScore[8] = tmpScore[6]
        }
        
        
        // large straight
        for index in totalDice.indices{
            if index != totalDice.count - 1{
                if totalDice[index].rawValue + 1 != totalDice[index + 1].rawValue{
                    tmpScore[9] = 0
                    break
                }else{
                    tmpScore[9] += totalDice[index].rawValue
                }
            }
            
        }
        
        // full house count.
        if totalDice[0].rawValue == totalDice[1].rawValue && totalDice[1].rawValue ==  totalDice[2].rawValue && totalDice[3].rawValue == totalDice[4].rawValue{
            tmpScore[10] = (totalDice[0].rawValue * 3) + (totalDice[4].rawValue * 2)
        }else if totalDice[0].rawValue == totalDice[1].rawValue && totalDice[2].rawValue == totalDice[3].rawValue && totalDice[3].rawValue == totalDice[4].rawValue{
            tmpScore[10] = (totalDice[0].rawValue * 2) + (totalDice[4].rawValue * 3)
        }else{
            tmpScore[10] = 0
        }

        
        // yachu
        for index in totalDice.indices{
            if index < totalDice.count - 1 {
                if totalDice[index].rawValue != totalDice[index + 1].rawValue{
                    tmpScore[11] = 0
                    break
                }else{
                    tmpScore[11] += totalDice[index].rawValue
                }
            }
        }
    }
}



//index 기준
//
// 0       => 1
// 1       => 2
// 2       => 3
// 3       => 4
// 4       => 5
// 5       => 6
// 6       => choose
// 7       => four of a kind
// 8       => small straight
// 9       => large straigt
// 10      => full house
// 11      => yachu
//
//
//

