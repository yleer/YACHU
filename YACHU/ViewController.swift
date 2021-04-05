//
//  ViewController.swift
//  YACHU
//
//  Created by Yundong Lee on 2021/03/30.
//

import UIKit

class ViewController: UIViewController {
    
    var firstPlayer = YachtModel()
    var secondPlayer = YachtModel()
    
    var currentPlayer = YachtModel()
    
    
    // model.currentDice랑 currentDiceImages랑 sync
    private func currentDiceUIUpdate(at index : Int){
        if index <= currentPlayer.currentDice.count - 1{
            currentDicesImages[index].isUserInteractionEnabled = true
            currentDicesImages[index].isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapToKeep))
            currentDicesImages[index].addGestureRecognizer(tap)
            currentDicesImages[index].image = UIImage(named: "dice\(currentPlayer.currentDice[index].rawValue)")
        }else{
            currentDicesImages[index].isUserInteractionEnabled = false
            currentDicesImages[index].isHidden = true
        }
    }
    
    // model.savedDice랑 savedDicesImageView랑 sync
    private func savedDiceUIUpdate(at index : Int){
        if index <= currentPlayer.tmpSave.count - 1{
            savedDicesImageView[index].isHidden = false
            savedDicesImageView[index].isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapToRemove))
            savedDicesImageView[index].addGestureRecognizer(tap)
            savedDicesImageView[index].image = UIImage(named: "dice\(currentPlayer.tmpSave[index].rawValue)")
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
        currentPlayer = firstPlayer
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
        if currentPlayer.newTurn{
            for index in scores.indices{
                scores[index].isUserInteractionEnabled = false
                if let score = currentPlayer.actualScore[index]{
                    scores[index].attributedText = NSAttributedString(string: "\(score)", attributes: attributedTextForScore)
                }else{
                    scores[index].text = ""
                }
            }
        }
        // 새로운 턴 아니면 확정된 점수 기입하고 user interaction 없애기. 확정 아니면 tmpscore 점수 회색으로 표시.
        else{
            for index in scores.indices{
                if let score = currentPlayer.actualScore[index]{
                    scores[index].attributedText = NSAttributedString(string: "\(score)", attributes: attributedTextForScore)
                }else{
                    scores[index].isUserInteractionEnabled = true
                    scores[index].attributedText = NSAttributedString(string: "\(currentPlayer.tmpScore[index])", attributes: attributedTextForTemp)
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
                            self.currentPlayer.backToRoll(index: index)
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
                        self.currentPlayer.keepDice(index: index)
                        self.currentDicesImages[index].frame = orignalFrame
                        self.updateUI()
                    }
                )
            }
        }
    }

    
    private func updateUI(){
        for index in 0..<5{
            currentDiceUIUpdate(at: index)
            savedDiceUIUpdate(at: index)
        }
    }
    
    
    @objc func scoreTap(_ gesture : UITapGestureRecognizer){
        if let chosenScore = gesture.view as? UILabel{
            if let index = scores.firstIndex(of: chosenScore){
                currentPlayer.selectScore(at: index)
            }
        }
        subTotal.text = "\(currentPlayer.subTotal)"
        total.text = "\(currentPlayer.totalScore)"
        currentTurnCount.text = "Turn : \(currentPlayer.currentTurn) / 12"
        updateScore() // 현재 턴에 대한 점수 변경
        // 턴 변경
        if currentPlayer === firstPlayer{
            currentPlayer = secondPlayer
        }else{
            currentPlayer = firstPlayer
        }
        // 다음 턴에 대한 점수 보이기.
        updateScore()
    }
    
    
    
    
    
    
    // Dice rolling part.
    // https://github.com/revolalex/IOS-SWIFT-Animation-RIsk-Dice 참고함.
    @IBAction func rollDice(_ sender: UIButton) {
        if currentPlayer.rollTime < 3{
            currentPlayer.rollDice()
            animate()
        }
        
        for index in 0..<5{
            // MARK: need to change
            currentDiceUIUpdate(at: index)
            savedDiceUIUpdate(at: index)
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

