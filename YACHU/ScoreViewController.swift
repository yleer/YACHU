//
//  ScoreViewController.swift
//  YACHU
//
//  Created by Yundong Lee on 2021/04/06.
//

import UIKit

class ScoreViewController: UIViewController {
    // first player info
    var firstPlayer : YachtModel?
    @IBOutlet var firstPlayerScoreLabels: [UILabel]!
    @IBOutlet weak var firstPlayerSubTotal: UILabel!
    @IBOutlet weak var firstPlayerTotal: UILabel!
    // second player info
    var secondPlayer : YachtModel?
    @IBOutlet var secondPlayerScoreLabels: [UILabel]!
    @IBOutlet weak var secondPlayerSubTotal: UILabel!
    @IBOutlet weak var secondPlayerTotal: UILabel!
    
    @IBOutlet weak var viewToShowBackGroubd: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewToShowBackGroubd.backgroundColor = UIColor(patternImage: UIImage(named: "board2.png") ?? UIImage())
        view.backgroundColor = UIColor(patternImage: UIImage(named: "board2.png") ?? UIImage())
        updateScore()
    }
    
    
    @IBAction func backToMainVC() {
        dismiss(animated: true)
    }
    
    private func updateScore(){
        if let player = firstPlayer{
            for index in firstPlayerScoreLabels.indices{
                if let score = player.actualScore[index]{
                    firstPlayerScoreLabels[index].text = "\(score)"
                }else{
                    firstPlayerScoreLabels[index].text = ""
                }
            }
        }
        if let player = secondPlayer{
            for index in secondPlayerScoreLabels.indices{
                if let score = player.actualScore[index]{
                    secondPlayerScoreLabels[index].text = "\(score)"
                }else{
                    secondPlayerScoreLabels[index].text = ""
                }
            }
        }
    }
}
