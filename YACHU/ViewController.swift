//
//  ViewController.swift
//  YACHU
//
//  Created by Yundong Lee on 2021/03/30.
//

import UIKit

class ViewController: UIViewController {
    
    // score label attributes.
    let attributedTextForTemp = [NSAttributedString.Key.foregroundColor : UIColor.gray]
    @IBOutlet weak var scoreBoardView: UIView!
    let attributedTextForScore = [NSAttributedString.Key.foregroundColor : UIColor.black]
    
    @IBOutlet weak var currentPlayerLabel: UILabel!
    @IBOutlet weak var numberOfTurnLeft: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet var scores: [UILabel]!
    @IBOutlet var savedDicesImageView: [UIImageView]!
    @IBOutlet var currentDicesImages: [UIImageView]!
    @IBOutlet weak var currentTurnCount: UILabel!
    
    @IBOutlet weak var keepBoard: UIView!
    @IBOutlet weak var outerBoard: UIView!
    @IBOutlet weak var innerBoard: UIView!
    
    @IBOutlet weak var constraint1: NSLayoutConstraint!
    @IBOutlet weak var constraint2: NSLayoutConstraint!
    @IBOutlet weak var constraint3: NSLayoutConstraint!
    
    
    private func updateConstraints(){
        let diceWidth = 50
        let a = (view.frame.width - 60 - 250)  / 4
        constraint1.constant = a
        constraint2.constant = a
        constraint3.constant = a
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show score segue"{
            if let destination = segue.destination as? ScoreViewController{
                destination.firstPlayer = firstPlayer
                destination.secondPlayer = secondPlayer
            }
        }
    }
    
    var firstPlayer = YachtModel()
    var secondPlayer = YachtModel()
    // model showing on screen.
    var currentPlayer = YachtModel()
    
    // dice ui update
    private func updateUI(){
        for index in 0..<5{
            currentDiceUIUpdate(at: index)
            savedDiceUIUpdate(at: index)
        }
    }
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPlayer = firstPlayer
        updateScore()
        numberOfTurnLeft.text = "3 Left"
        view.backgroundColor = UIColor(patternImage: UIImage(named: "board2.png") ?? UIImage())
        scoreBoardView.backgroundColor = UIColor(patternImage: UIImage(named: "board1.png") ?? UIImage())
        
        
        
        for dice in currentDicesImages{
            view.bringSubviewToFront(dice)
        }
        for dice in savedDicesImageView{
            view.bringSubviewToFront(dice)
        }
        
        updateConstraints()
        
        
        
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
                    let tap = UITapGestureRecognizer(target: self, action: #selector(scoreTap))
                    scores[index].addGestureRecognizer(tap)
                    scores[index].isUserInteractionEnabled = true
                    scores[index].attributedText = NSAttributedString(string: "\(currentPlayer.tmpScore[index])", attributes: attributedTextForTemp)
                }
            }
        }
        updateSubAndTotal()
    }
    
    private func updateSubAndTotal(){
        subTotal.text = "\(currentPlayer.subTotal)"
        total.text = "\(currentPlayer.totalScore)"
    }
    
    // total 이랑 subtotal 같이 변경하게 해야 됨
    
    
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
                            // 위치 계산 해야 겠네..
                            self.savedDicesImageView[index].frame = self.currentDicesImages[tmpIndex].frame
                        },
                        completion: { finished in
                            self.currentPlayer.backToRoll(index: index)
                            self.savedDicesImageView[index].frame = orignalFrame
                            self.updateUI()
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
                
                let fr = savedDicesImageView[tmpIndex].frame
                
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5,
                    delay: 0,
                    options: .curveLinear,
                    animations: {
                        // 위치 계산 해야 겠네..
                        self.currentDicesImages[index].frame = CGRect(x: 0 - self.innerBoard.frame.minX + fr.midX , y: 0 - self.innerBoard.frame.minY - 8 - self.keepBoard.frame.height + fr.minY, width: 50, height: 50)
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
    
    // MARK: need to make animation when turn changes.
    @objc func scoreTap(_ gesture : UITapGestureRecognizer){
        if let chosenScore = gesture.view as? UILabel{
            if let index = scores.firstIndex(of: chosenScore){
                currentPlayer.selectScore(at: index)
            }
        }
        
        updateScore() // 현재 턴에 대한 점수 변경
        updateUI()
        
        // 턴 변경
        nextTurn()
        
        numberOfTurnLeft.text = "3 Left"
        // 다음 턴에 대한 점수 보이기.
        updateScore()
    }
    
    

    
    private func nextTurn(){
        let playerTurnSlider = UIView(frame: view.midRect)
        let playerTurnLabel = UILabel(frame: CGRect(x: 0, y: 0, width: playerTurnSlider.frame.width, height: playerTurnSlider.frame.height))
        playerTurnLabel.textAlignment = .center
        playerTurnSlider.addSubview(playerTurnLabel)
        view.addSubview(playerTurnSlider)
        
        
        if currentPlayer === firstPlayer{
            currentPlayer = secondPlayer
            playerTurnSlider.backgroundColor = #colorLiteral(red: 0.8184140325, green: 0.933015883, blue: 0.3913968801, alpha: 1)
            currentPlayerLabel.text = "Second Player"
            playerTurnLabel.text = "Second Player's turn."
            UIView.animate(
                withDuration: 1,
                delay: 0,
                options: [.curveEaseIn],
                animations: {
                    playerTurnSlider.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                },
                completion: { finished in
                    UIView.animate(
                        withDuration: 1,
                        animations: {
                            playerTurnSlider.transform = .identity
                            playerTurnSlider.alpha = 0
                        },
                        completion: { finished in
                            playerTurnSlider.removeFromSuperview()
                        }
                    )
                }
            )
        }else{
            currentPlayer = firstPlayer
            playerTurnSlider.backgroundColor = #colorLiteral(red: 1, green: 0.740609467, blue: 1, alpha: 1)
            currentPlayerLabel.text = "First Player"
            playerTurnLabel.text = "First Player's turn."
            UIView.animate(
                withDuration: 1,
                delay: 0,
                options: [],
                animations: {
                    playerTurnSlider.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                },
                completion: { finished in
                    UIView.animate(
                        withDuration: 1,
                        animations: {
                            playerTurnSlider.transform = .identity
                            playerTurnSlider.alpha = 0
                        },
                        completion: { finished in
                            playerTurnSlider.removeFromSuperview()
                        }
                    )
                }
            )
        }
        currentTurnCount.text = "Turn : \(currentPlayer.currentTurn) / 12"
    }
    
    
    
    
    // Dice rolling part.
    // https://github.com/revolalex/IOS-SWIFT-Animation-RIsk-Dice 참고함.
    @IBAction func rollDice(_ sender: UIButton) {
        if currentPlayer.rollTime < 3{
            numberOfTurnLeft.text = "\(2 - currentPlayer.rollTime) Left"
            currentPlayer.rollDice()
            animate()
        }
        updateUI()
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



extension UIView{
    var midRect : CGRect{
        get{
            return CGRect(x: self.frame.midX - self.frame.width / 4, y: self.frame.midY - self.frame.height / 12, width: self.frame.width / 2, height: self.frame.height / 6)
        }
    }
}
