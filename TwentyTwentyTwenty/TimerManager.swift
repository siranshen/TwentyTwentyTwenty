//
//  TimerManager.swift
//  TwentyTwentyTwenty
//
//  Created by Siran on 4/21/24.
//

import Foundation
import SwiftUI
import UserNotifications

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int
    @Published var timerIsRunning = false
    @Published var timerMode: TimerMode = .work

    @Published var workInterval: Int {
        didSet {
            UserDefaults.standard.set(workInterval, forKey: "workInterval")
        }
    }
    @Published var restInterval: Int {
        didSet {
            UserDefaults.standard.set(restInterval, forKey: "restInterval")
        }
    }
    
    var timer: Timer?
    
    enum TimerMode {
        case work
        case rest
    }
    
    init() {
        let workInterval = UserDefaults.standard.integer(forKey: "workInterval") != 0 ? UserDefaults.standard.integer(forKey: "workInterval") : 20 * 60
        self.workInterval = workInterval
        self.timeRemaining = workInterval
        self.restInterval = UserDefaults.standard.integer(forKey: "restInterval") != 0 ? UserDefaults.standard.integer(forKey: "restInterval") : 20
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { granted, error in
            if granted {
                print("Notifications allowed")
            } else if let error = error {
                print("Notifications denied: \(error.localizedDescription)")
            }
        }
    }

    func setWorkInterval(minutes: Int) {
        workInterval = minutes * 60
        if timerMode == .work {
            reset()
        }
    }
    
    func setRestInterval(seconds: Int) {
        restInterval = seconds
        if timerMode == .rest {
            reset()
        }
    }
    
    func start() {
        timerIsRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.timerIsRunning = false
                if self.timerMode == .work {
                    self.sendNotification()
                }
                self.timeRemaining = self.timerMode == .work ? self.restInterval : self.workInterval
                self.timerMode = self.timerMode == .work ? .rest : .work
                self.start() // Automatically start the next session
            }
        }
    }
    
    func pause() {
        timer?.invalidate()
        timerIsRunning = false
    }
    
    func reset() {
        timer?.invalidate()
        timerIsRunning = false
        timerMode = .work
        timeRemaining = workInterval
    }
    
    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time to rest"
        content.body = "Your timer is up."
        content.interruptionLevel = .timeSensitive

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
