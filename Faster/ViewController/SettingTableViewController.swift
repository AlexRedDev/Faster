//
//  SettingTableViewController.swift
//  Faster
//
//  Created by Alex Cheipesh on 12.05.2021.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
}
