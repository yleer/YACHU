//
//  YachtModel.swift
//  YACHU
//
//  Created by Yundong Lee on 2021/03/30.
//

import Foundation

class YachtModel {
    var totalDice : [Dice] {
        get{
            return tmpSave + currentDice
        }
        set{
        }
    }
    var tmpSave : [Dice] = []
    // currentDice 는 5 - tmpSave
    var currentDice : [Dice] = []{
        didSet{
            currentDice.sort { (first, second) -> Bool in
                return first.rawValue < second.rawValue
            }
        }
    }
    
    var currentTurn = 1

    var actualScore : [Int?] = [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]
    var tmpScore = [0,0,0,0,0,0,0,0,0,0,0,0]
    var newTurn : Bool{
         get{
            for score in tmpScore{
                if score != 0{
                    return false
                }
            }
            currentTurn += 1
            return true
        }
    }
    
    var totalScore : Int {
        get{
            var tmpScore = 0
            for optionalScore in actualScore{
                if let score = optionalScore{
                    tmpScore += score
                }
            }
            return tmpScore
        }
    }
    var subTotal : Int{
        get{
            var tmpScore = 0
            for index in actualScore.indices{
                if index < 6{
                    if let score = actualScore[index]{
                        tmpScore += score
                    }
                }
            }
            return tmpScore
        }
    }
   
    
    var rollTime = 0
    
     func rollDice(){
        if rollTime < 3{
            clean()
            currentDice = []
            
            for _ in 0 ..< 5 - tmpSave.count{
                
                currentDice.append(Dice.randomDice())
            }
//            print(totalDice)
            possibleScoreUpdate()
            rollTime += 1
        }
    }
    
     func clean(){
        tmpScore = [0,0,0,0,0,0,0,0,0,0,0,0]
    }
        
     func selectScore(at index: Int){
        actualScore[index] = tmpScore[index]

        // end turn.
        rollTime = 0
        tmpSave = []
        totalDice = []
        clean()
        currentDice = []
    }
    
     func keepDice(index : Int){
        let dice = currentDice.remove(at: index)
        tmpSave.append(dice)
    }
    
     func backToRoll(index : Int){
        let dice = tmpSave.remove(at: index)
        currentDice.append(dice)
    }
}













// 이거 고치자.
extension YachtModel{
     func possibleScoreUpdate(){
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
        
        // four of a kind 계산.
        var fourOfAKindCountArray = [0,0,0,0,0,0]
        for dice in totalDice{
            if dice.rawValue == 1{
                fourOfAKindCountArray[0] += 1
            }else if dice.rawValue == 2{
                fourOfAKindCountArray[1] += 1
            }else if dice.rawValue == 3{
                fourOfAKindCountArray[2] += 1
            }else if dice.rawValue == 4{
                fourOfAKindCountArray[3] += 1
            }else if dice.rawValue == 5{
                fourOfAKindCountArray[4] += 1
            }else if dice.rawValue == 6{
                fourOfAKindCountArray[5] += 1
            }
        }
        
        if let indexOfFourSameDices = fourOfAKindCountArray.firstIndex(of: 4){
            tmpScore[7] = (indexOfFourSameDices + 1) * 4
            if let indexOfOneDice = fourOfAKindCountArray.firstIndex(of: 1){
                tmpScore[7] += indexOfOneDice + 1
            }
        }else{
            tmpScore[7] = 0
        }

        
//        // small straight
        var smallStraightArray = [0,0,0,0,0,0]
        
        for dice in totalDice{
            if dice.rawValue == 1{
                smallStraightArray[0] += 1
            }else if dice.rawValue == 2{
                smallStraightArray[1] += 1
            }else if dice.rawValue == 3{
                smallStraightArray[2] += 1
            }else if dice.rawValue == 4{
                smallStraightArray[3] += 1
            }else if dice.rawValue == 5{
                smallStraightArray[4] += 1
            }else if dice.rawValue == 6{
                smallStraightArray[5] += 1
            }
        }
        
        // 연속 4개 -> 1234, 2345, 3456
        
        if smallStraightArray[0] > 0 && smallStraightArray[1] > 0 && smallStraightArray[2] > 0 && smallStraightArray[3] > 0{
            tmpScore[8] = tmpScore[6]
        }else if smallStraightArray[4] > 0 && smallStraightArray[1] > 0 && smallStraightArray[2] > 0 && smallStraightArray[3] > 0{
            tmpScore[8] = tmpScore[6]
        }else if smallStraightArray[5] > 0 && smallStraightArray[4] > 0 && smallStraightArray[2] > 0 && smallStraightArray[3] > 0{
            tmpScore[8] = tmpScore[6]
        }else{
            tmpScore[8] = 0
        }
        
        
        // large straight
        var largeStraightArray = [0,0,0,0,0,0]
        for dice in totalDice{
            if dice.rawValue == 1{
                largeStraightArray[0] += 1
            }else if dice.rawValue == 2{
                largeStraightArray[1] += 1
            }else if dice.rawValue == 3{
                largeStraightArray[2] += 1
            }else if dice.rawValue == 4{
                largeStraightArray[3] += 1
            }else if dice.rawValue == 5{
                largeStraightArray[4] += 1
            }else if dice.rawValue == 6{
                largeStraightArray[5] += 1
            }
        }
        
        if largeStraightArray[0] > 0 && largeStraightArray[1] > 0 && largeStraightArray[2] > 0 && largeStraightArray[3] > 0 && largeStraightArray[4] > 0{
            tmpScore[9] = tmpScore[6]
        }else if largeStraightArray[1] > 0 && largeStraightArray[2] > 0 && largeStraightArray[3] > 0 && largeStraightArray[4] > 0 && largeStraightArray[5] > 0{
            tmpScore[9] = tmpScore[6]
        }else{
            tmpScore[9] = 0
        }
        

        // full house count. (total dice가 정렬된거라 가능함. 정렬 안된 배열이면 불가능.)
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
// 0       => 1 done
// 1       => 2 done
// 2       => 3 done
// 3       => 4 done
// 4       => 5 done
// 5       => 6 done
// 6       => choose done
// 7       => four of a kind done
// 8       => small straight done
// 9       => large straigt  done.
// 10      => full house.  고쳐야됨
// 11      => yachu done
//
