//
//  RecordViewController.swift
//  Faster
//
//  Created by Alex Cheipesh on 20.05.2021.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
        if record != 0 {
            recordLabel.text = "Your Record - \(record)"
        } else {
            recordLabel.text = "Record not inst"
        }
    }
    


    @IBAction func closeVC(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
