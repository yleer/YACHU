//
//  ViewController.swift
//  YACHU
//
//  Created by Yundong Lee on 2021/03/30.
//

import UIKit

class ViewController: UIViewController {
    var model = YachtModel()
    

    @IBOutlet var dices: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    @IBOutlet var savedCards: [UILabel]!
    
    func updateViewFromModel(){
        for index in dices.indices{
            dices[index].text = ""
        }
        for index in model.currentDice.indices{
            dices[index].isUserInteractionEnabled = true
            dices[index].text = String(model.currentDice[index].rawValue)
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapToKeep))
            dices[index].addGestureRecognizer(tap)
        }
        
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
    
    @objc func tapToRemove(_ gesture : UITapGestureRecognizer){
        if let chosenDice = gesture.view as? UILabel{
            if let index = savedCards.firstIndex(of: chosenDice){
                model.backToRoll(index: index)
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
