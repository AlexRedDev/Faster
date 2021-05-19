//
//  GameViewController.swift
//  Faster
//
//  Created by Alex Cheipesh on 12.05.2021.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var newGame: UIButton!
    
    private lazy var game = Game(countItem: buttons.count, updateTimer: { [weak self] (status, second) in
        
        guard let self = self else {return}
        
        self.TimerLabel.text = second.secondsToString()
        self.updateInfoGame(with: status)
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        game.stopGame()
    }
    private func setupScreen(){
        for index in game.items.indices {
            buttons[index].setTitle(game.items[index].title, for: .normal)
            buttons[index].alpha = 1
            buttons[index].isEnabled = true
        }
        nextDigit.text = game.nextItem?.title
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else {
            return
        }
        game.check(index: buttonIndex)
        updateUI()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }
    private func updateUI() {
        for index in game.items.indices {

            buttons[index].alpha = game.items[index].isFound ? 0 : 1
            buttons[index].isEnabled = !game.items[index].isFound
            
            if game.items[index].isError {
                
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = .red
                } completion: { [weak self] _ in
                    self?.buttons[index].backgroundColor = .white
                    self?.game.items[index].isError = false
                }

            }
        }
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status: StatusGame) {
        switch status {
        case .start:
            statusLabel.text = "Game Start"
            statusLabel.textColor = .black
            newGame.isHidden = true
        case .win:
            statusLabel.text = "You win"
            statusLabel.textColor = .green
            newGame.isHidden = false
            if game.isNewRecord  == true {
                showAlert()
            } else {
                showAlertActionSheet()
            }
        case .lose:
            statusLabel.text = "You lose"
            statusLabel.textColor = .red
            newGame.isHidden = false
            showAlertActionSheet()
            
        }
    }
    
    private func showAlert() {
        
        let alert = UIAlertController(title: "Congratulation", message: "New record", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    private func showAlertActionSheet() {
        let alert = UIAlertController(title: "What you want do", message: nil, preferredStyle: .actionSheet)
        let newGame = UIAlertAction(title: "New Game", style: .default){ [weak self]
            _ in
            self?.game.newGame()
            self?.setupScreen()
        }
        
        let showRecord = UIAlertAction(title: "Show Record", style: .default) { [weak self]_ in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        
        let menuAction = UIAlertAction(title: "Main Menu", style: .destructive) {[weak self]_ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(newGame)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = statusLabel
        }
     
        present(alert, animated: true, completion: nil)
    }
}
