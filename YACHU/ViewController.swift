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
            // sync with model.
            for index in 0..<5{
                currentDiceUIUpdate(at: index)
                savedDiceUIUpdate(at: index)
            }
        }
    }
    
    
    // model.currentDice랑 currentDiceImages랑 sync
    private func currentDiceUIUpdate(at index : Int){
        if index <= model.currentDice.count - 1{
            currentDicesImages[index].isUserInteractionEnabled = true
            currentDicesImages[index].isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapToKeep))
            currentDicesImages[index].addGestureRecognizer(tap)
            currentDicesImages[index].image = UIImage(named: "dice\(model.currentDice[index].rawValue)")
        }else{
            currentDicesImages[index].isUserInteractionEnabled = false
            currentDicesImages[index].isHidden = true
        }
    }
    
    // model.savedDice랑 savedDicesImageView랑 sync
    private func savedDiceUIUpdate(at index : Int){
        if index <= model.tmpSave.count - 1{
            savedDicesImageView[index].isHidden = false
            savedDicesImageView[index].isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapToRemove))
            savedDicesImageView[index].addGestureRecognizer(tap)
            savedDicesImageView[index].image = UIImage(named: "dice\(model.tmpSave[index].rawValue)")
        }else{
            savedDicesImageView[index].isHidden = true
            savedDicesImageView[index].isUserInteractionEnabled = false
        }
    }
    
    
    // score label attributes.
    let attributedTextForTemp = [NSAttributedString.Key.foregroundColor : UIColor.gray]
    let attributedTextForScore = [NSAttributedString.Key.foregroundColor : UIColor.black]
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet var scores: [UILabel]!
    @IBOutlet var savedDicesImageView: [UIImageView]!
    @IBOutlet var currentDicesImages: [UIImageView]!
    @IBOutlet weak var currentTurnCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateScore()
        initUIs()
    }
    
    private func initUIs(){
        // init dice images.
        for index in currentDicesImages.indices{
            currentDicesImages[index].image = UIImage.init(named: "dice\(index + 1)")
        }
        // init score UIs
        for score in scores{
            let tap = UITapGestureRecognizer(target: self, action: #selector(scoreTap))
            score.addGestureRecognizer(tap)
        }
    }
    
    
    private func updateScore(){
        // 새로운 턴이면 확정된 점수는 점수 기입하고 아닌 것들은 "" 으로 점수 기입.
        if model.newTurn{
            for index in scores.indices{
                scores[index].isUserInteractionEnabled = false
                if let score = model.actualScore[index]{
                    scores[index].attributedText = NSAttributedString(string: "\(score)", attributes: attributedTextForScore)
                }else{
                    scores[index].text = ""
                }
            }
        }
        // 새로운 턴 아니면 확정된 점수 기입하고 user interaction 없애기. 확정 아니면 tmpscore 점수 회색으로 표시.
        else{
            for index in scores.indices{
                if let score = model.actualScore[index]{
                    scores[index].attributedText = NSAttributedString(string: "\(score)", attributes: attributedTextForScore)
                }else{
                    scores[index].isUserInteractionEnabled = true
                    scores[index].attributedText = NSAttributedString(string: "\(model.tmpScore[index])", attributes: attributedTextForTemp)
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
        subTotal.text = "\(model.subTotal)"
        total.text = "\(model.totalScore)"
        currentTurnCount.text = "Turn : \(model.currentTurn) / 12"
        updateScore()
    }
    
    
    
    
    
    
    // Dice rolling part.
    // https://github.com/revolalex/IOS-SWIFT-Animation-RIsk-Dice 참고함.
    @IBAction func rollDice(_ sender: UIButton) {
        if model.rollTime < 3{
            model.rollDice()
            animate()
            
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
            self.updateScore()
            
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

