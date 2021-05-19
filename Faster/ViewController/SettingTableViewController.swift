//
//  SettingTableViewController.swift
//  Faster
//
//  Created by Alex Cheipesh on 12.05.2021.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    @IBOutlet weak var switchTimer: UISwitch!
    @IBOutlet weak var timeGameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadSetting()
    }
    func loadSetting() {
        timeGameLabel.text = "\(Settings.shared.currentSettings.timeForGame) sec"
        switchTimer.isOn = Settings.shared.currentSettings.timerState
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SelectTimeVC":
            if let vc = segue.destination as? SelectTimeViewController {
                vc.data = [10, 20, 30, 40, 50, 60, 80, 90, 100, 110, 120]
            }
        default:
            break
        }
    }
    @IBAction func changeTimerState(_ sender: UISwitch) {
        Settings.shared.currentSettings.timerState = sender.isOn
    }
    @IBAction func resetSettings(_ sender: Any) {
        Settings.shared.resetSetting()
        loadSetting()
    }
}


