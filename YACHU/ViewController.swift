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
//    @IBOutlet var savedDices: [UILabel]!
    @IBOutlet var savedDicesImageView: [UIImageView]!
    @IBOutlet var currentDicesImages: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        
        initDiceImages()
        
        for score in scores{
            score.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(scoreTap))
            score.addGestureRecognizer(tap)
        }
    }
    
    private func initDiceImages(){
        for index in currentDicesImages.indices{
            currentDicesImages[index].image = UIImage.init(named: "dice\(index + 1)")
        }
    }
    
    
    func updateViewFromModel(){
        currentDiceUpdate()
        savedDiceUpdate()
        updateScore()
        
    }
    
    // currentDices들 (roll 할것들) update.
    private func currentDiceUpdate(){
        for index in currentDicesImages.indices{
            currentDicesImages[index].isUserInteractionEnabled = true
            currentDicesImages[index].image = UIImage()
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapToKeep))
            currentDicesImages[index].addGestureRecognizer(tap)
        }
        
        for index in model.currentDice.indices{
            currentDicesImages[index].image = UIImage(named: "dice\(model.currentDice[index].rawValue)")
        }
    }
    // savedDices (tmp dices) update.
    private func savedDiceUpdate(){
        for index in savedDicesImageView.indices{
            savedDicesImageView[index].isUserInteractionEnabled = true
            savedDicesImageView[index].image = UIImage()
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapToRemove))
            savedDicesImageView[index].addGestureRecognizer(tap)
        }
        
        for index in model.tmpSave.indices{
            savedDicesImageView[index].image = UIImage(named: "dice\(model.tmpSave[index].rawValue)")
        }
    }
    
    //
    private func updateScore(){
        // 새로운 턴이면 확정된 점수는 점수 기입하고 아닌 것들은 "" 으로 점수 기입.
        if model.newTurn{
            for index in scores.indices{
                if model.actualScore[index] != nil{
                    scores[index].attributedText = NSAttributedString(string: String(model.actualScore[index]!), attributes: attributedTextForScore)
                }else{
                    scores[index].text = ""
                }
                
            }
        }
        // 새로운 턴 아니면 확정된 점수 기입하고 user interaction 없애기. 확정 아니면 tmpscore 점수 회색으로 표시.
        
        // MARK: User interaction 고쳐야 됨.
        else{
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

    
    @objc func tapToRemove(_ gesture : UITapGestureRecognizer){
        if let chosenDice = gesture.view as? UIImageView{
            if chosenDice.image != UIImage(){
                if let index = savedDicesImageView.firstIndex(of: chosenDice){
                    model.backToRoll(index: index)
                }
            }
        }
        updateViewFromModel()
    }
    
    @objc func tapToKeep(_ gesture : UITapGestureRecognizer){
        if let chosenDice = gesture.view as? UIImageView{
            if let index = currentDicesImages.firstIndex(of: chosenDice){
                model.keepDice(index: index)
            }
        }
        updateViewFromModel()
    }
    
    @objc func scoreTap(_ gesture : UITapGestureRecognizer){
        if let chosenScore = gesture.view as? UILabel{
            if let index = scores.firstIndex(of: chosenScore){
                model.selectScore(at: index)
            }
        }
        updateViewFromModel()
    }

    
    @IBAction func rollDice(_ sender: UIButton) {
        model.rollDice()
        updateViewFromModel()
    }
}

