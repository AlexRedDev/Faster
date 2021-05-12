//
//  Setting.swift
//  Faster
//
//  Created by Alex Cheipesh on 12.05.2021.
//

import Foundation

enum KeysUserDefaults {
    static let settingsGame = "settingGame"
}
struct SettingsGame: Codable {
    var timerState: Bool
    var timeForGame: Int
}

class Settings {
    
    static var shared = Settings()
    private let defaultSettings = SettingsGame(timerState: true, timeForGame: 30)
    
    var currentSettings: SettingsGame {
        get{
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.settingsGame) as? Data {
                return try! PropertyListDecoder().decode(SettingsGame.self, from: data)
            }
            if let data = try? PropertyListEncoder().encode(defaultSettings) {
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsGame)
            }
            return defaultSettings
        }
        set{
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsGame)
            }
        }
    }
}
