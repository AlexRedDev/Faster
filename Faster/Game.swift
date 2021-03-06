//
//  Game.swift
//  Faster
//
//  Created by Alex Cheipesh on 12.05.2021.
//

import Foundation

enum StatusGame {
    case start
    case win
    case lose
}

class Game {
    
    struct Item {
        var title: String
        var isFound: Bool = false
        var isError: Bool = false
    }
    
    private let data = Array(1...99)
    private var countItems: Int
    private var timer: Timer?
    private var updateTimer: (StatusGame, Int) -> Void
    private var timeForGame: Int
    private var secondsGame: Int {
        didSet {
            if secondsGame == 0 {
                status = .lose
            }
            updateTimer(status, secondsGame)
        }
    }
    
    var items: [Item] = []
    var nextItem: Item?
    var isNewRecord = false
    var status: StatusGame = .start {
        didSet{
            if status != .start{
                if status == .win {
                    let newRecord = timeForGame - secondsGame
                    
                    let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
                    
                    if record == 0 || newRecord < record {
                        UserDefaults.standard.setValue(newRecord, forKey: KeysUserDefaults.recordGame)
                        isNewRecord = true
                    }
                }
                stopGame()
            }
        }
    }
    
    init(countItem: Int, updateTimer: @escaping (_ status: StatusGame, _ second: Int) -> Void) {
        
        self.countItems = countItem
        self.timeForGame = Settings.shared.currentSettings.timeForGame
        self.secondsGame = Settings.shared.currentSettings.timeForGame
        self.updateTimer = updateTimer
        
        setupGame()
    }
    
    private func setupGame() -> Void {
        isNewRecord = false
        
        var digits = data.shuffled()
        items.removeAll()
        while items.count <  countItems {
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
        
        nextItem = items.shuffled().first
        updateTimer(status, secondsGame)
        
        if Settings.shared.currentSettings.timerState {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                self?.secondsGame -= 1
            })
        }
        
    }
    
    func check(index: Int) -> Void {
        
        guard status == .start else { return }
        if items[index].title == nextItem?.title {
            
            items[index].isFound = true
            nextItem = items.shuffled().first(where: { Item in
                Item.isFound == false
            })
        } else {
            items[index].isError = true
        }
        if nextItem == nil {
            status = .win
        }
    }
    
    func stopGame() -> Void {
        timer?.invalidate()
        
    }
    
    func newGame() -> Void {
        status = .start
        self.secondsGame = self.timeForGame
        setupGame()
    }
}

extension Int {
    func secondsToString() -> String {
        let minut = self / 60
        let second = self % 60
        return String(format: "%d:%02d", minut, second)
    }
}
