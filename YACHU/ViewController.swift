//
//  ViewController.swift
//  YACHU
//
//  Created by Yundong Lee on 2021/03/30.
//

import UIKit

class ViewController: UIViewController {
    var model = YachtModel()
    
    let attributedTextForTemp = [NSAttributedString.Key.foregroundColor : UIColor.gray]
    let attributedTextForScore = [NSAttributedString.Key.foregroundColor : UIColor.black]
    
    @IBOutlet var scores: [UILabel]!
    @IBOutlet var savedCards: [UILabel]!
    @IBOutlet var dices: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        
        for score in scores{
            score.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(scoreTap))
            score.addGestureRecognizer(tap)
        }
    }
    
    @objc func scoreTap(_ gesture : UITapGestureRecognizer){
        if let chosenScore = gesture.view as? UILabel{
            if let index = scores.firstIndex(of: chosenScore){
                print(index)
                model.selectScore(at: index)
            }
        }
        updateViewFromModel()
    }
    
    private func currentDiceUpdate(){
        for index in dices.indices{
            dices[index].text = ""
        }
        for index in model.currentDice.indices{
            dices[index].isUserInteractionEnabled = true
            dices[index].text = String(model.currentDice[index].rawValue)
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapToKeep))
            dices[index].addGestureRecognizer(tap)
        }

    }
    
    private func savedDiceUpdate(){
        for index in savedCards.indices{
            savedCards[index].text = ""
            savedCards[index].isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapToRemove))
            savedCards[index].addGestureRecognizer(tap)
        }
        for index in model.tmpSave.indices{
            savedCards[index].text = String(model.tmpSave[index].rawValue)
        }
    }
    
    private func updateScore(){
        if model.newTurn{
            for index in scores.indices{
                if model.actualScore[index] != nil{
                    scores[index].attributedText = NSAttributedString(string: String(model.actualScore[index]!), attributes: attributedTextForScore)
                }else{
                    scores[index].text = ""
                }
                
            }
        }else{
            for index in scores.indices{
                if model.actualScore[index] != nil{
                    scores[index].isUserInteractionEnabled = false
                    scores[index].attributedText = NSAttributedString(string: String(model.actualScore[index]!), attributes: attributedTextForScore)
                        
                }else{
                    scores[index].attributedText = NSAttributedString(string: String(model.tmpScore[index]), attributes: attributedTextForTemp)
                }
            }
        }
        
    }
    
    
    func updateViewFromModel(){
        // 주사위 돌릴 주사위들
        currentDiceUpdate()
        // 저장한 주사위들
        savedDiceUpdate()
        // 번호 누르면 데이터 입력하기
        updateScore()
    }
    
    @objc func tapToRemove(_ gesture : UITapGestureRecognizer){
        if let chosenDice = gesture.view as? UILabel{
            if chosenDice.text != ""{
                if let index = savedCards.firstIndex(of: chosenDice){
                    model.backToRoll(index: index)
                }
            }
        }
        updateViewFromModel()
    }
    
    @objc func tapToKeep(_ gesture : UITapGestureRecognizer){
        if let chosenDice = gesture.view as? UILabel{
            if let index = dices.firstIndex(of: chosenDice){
                model.keepDice(index: index)
            }
        }
        updateViewFromModel()
    }

    
    @IBAction func rollDice(_ sender: UIButton) {
        model.rollDice()
//        model.printPossibleOutcomes()
        updateViewFromModel()
    }
}

// 내일은 좀 주사위 돌리기 가능하게 하기. 스몰스트레이트 해결하기.
