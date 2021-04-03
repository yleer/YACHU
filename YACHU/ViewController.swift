//
//  ViewController.swift
//  YACHU
//
//  Created by Yundong Lee on 2021/03/30.
//

import UIKit

class ViewController: UIViewController {
    var model = YachtModel(){
        didSet{
            for index in 0..<5{
                // model.currentDice랑 currentDiceImages랑 sync
                if index <= model.currentDice.count - 1{
                    print(index)
                    currentDicesImages[index].isUserInteractionEnabled = true
                    currentDicesImages[index].isHidden = false
                }else{
                    currentDicesImages[index].isUserInteractionEnabled = false
                    currentDicesImages[index].isHidden = true
                }
                
                
                // model.savedDice랑 savedDicesImageView랑 sync
                if index <= model.tmpSave.count - 1{
                    savedDicesImageView[index].isHidden = false
                    savedDicesImageView[index].isUserInteractionEnabled = true
                }else{
                    savedDicesImageView[index].isHidden = true
                    savedDicesImageView[index].isUserInteractionEnabled = false
                }
            }
        }
    }
    
    
    
    let attributedTextForTemp = [NSAttributedString.Key.foregroundColor : UIColor.gray]
    let attributedTextForScore = [NSAttributedString.Key.foregroundColor : UIColor.black]
    
    @IBOutlet var scores: [UILabel]!
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
                    let orignalFrame = savedDicesImageView[index].frame
                    
                    var tmpIndex = 0
                    for empty in currentDicesImages.indices{
                        if currentDicesImages[empty].isHidden{
                            tmpIndex = empty
                            break
                        }
                    }
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.5,
                        delay: 0,
                        options: .curveLinear,
                        animations: {
                            self.savedDicesImageView[index].frame = self.currentDicesImages[tmpIndex].frame
                        },
                        completion: { finished in
                            self.model.backToRoll(index: index)
                            self.updateViewFromModel()
                            self.savedDicesImageView[index].frame = orignalFrame
                        }
                    )
                }
            }
        }
    }
    
    
    @objc func tapToKeep(_ gesture : UITapGestureRecognizer){
        if let chosenDice = gesture.view as? UIImageView{
            if let index = currentDicesImages.firstIndex(of: chosenDice){
                let orignalFrame = currentDicesImages[index].frame
                var tmpIndex = 0
                for empty in savedDicesImageView.indices{
                    if savedDicesImageView[empty].isHidden{
                        tmpIndex = empty
                        break
                    }
                }
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5,
                    delay: 0,
                    options: .curveLinear,
                    animations: {
                        self.currentDicesImages[index].frame = self.savedDicesImageView[tmpIndex].frame
                    },
                    completion: { finished in
                        self.model.keepDice(index: index)
                        self.updateViewFromModel()
                        self.currentDicesImages[index].frame = orignalFrame
                    }
                )
            }
        }
    }
    
    
    
    
    
    @objc func scoreTap(_ gesture : UITapGestureRecognizer){
        if let chosenScore = gesture.view as? UILabel{
            if let index = scores.firstIndex(of: chosenScore){
                model.selectScore(at: index)
            }
        }
        updateViewFromModel()
    }
    
    
    
    
    
    
    // Dice rolling part.
    // https://github.com/revolalex/IOS-SWIFT-Animation-RIsk-Dice 참고함.
    @IBAction func rollDice(_ sender: UIButton) {
        if model.rollTime < 3{
            model.rollDice()
            animate()
            updateViewFromModel()
        }
    }
    
    private func animate(){
        diceAnimation()
        animateDice()
    }
    
    private func diceAnimation(){
        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                for dice in self.currentDicesImages{
                    dice.transform = CGAffineTransform(scaleX: 5, y: 5)
                    dice.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    dice.transform = CGAffineTransform(translationX: 50, y: 0)
                }
            }){
                finished in
            
                UIView.animate(withDuration: 0.4) {
                    for dice in self.currentDicesImages{
                        dice.transform = .identity
                    }
                }
            
        }
    }
    
    private let diceAttackArray = [UIImage(named: "dice1"), UIImage(named: "dice2"), UIImage(named: "dice3"), UIImage(named: "dice4"), UIImage(named: "dice5"), UIImage(named: "dice6")]
    
    private func animateDice(){
        for dice in currentDicesImages{
            dice.animationImages = (diceAttackArray.shuffled() as! [UIImage])
            dice.animationDuration = 1
            dice.animationRepeatCount = 2
            dice.startAnimating()
        }
    }
    
}


//model의 currnetDice와 vc의 currentDice sync하자.
