//
//  ViewController.swift
//  EggTimer
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    @IBOutlet var screenTitle: UILabel!
    @IBOutlet var timerProgress: UIProgressView!
    
    let eggTimes = ["Soft": 5, "Medium": 7, "Hard": 12]
    var secondsRemaining = 0
    var timer = Timer()
    var alarmPlayer: AVAudioPlayer?
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        secondsRemaining = eggTimes[hardness]!.minToSeconds()
        
        // print("Hardness time is \(String(describing: secondsRemaining)) seconds")
        
        startCountdown(hardness)
    }
    
    fileprivate func startCountdown(_ hardness: String) {
        let oneSecondPercent = Float(1) / Float(secondsRemaining)
        
        timerProgress.progress = 0
        timer.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.secondsRemaining -= 1
            self.screenTitle.text = "\(hardness)\n\(self.secondsRemaining.formatToTime())"
            self.timerProgress.progress += oneSecondPercent
            
            // print(self.secondsRemaining)
            if self.secondsRemaining == 0 {
                timer.invalidate()
                self.screenTitle.text = "DONE"
                self.timerProgress.progress = 1
                self.playAlarm()
            }
        }
    }
    
    fileprivate func playAlarm() {
        let path = Bundle.main.path(forResource: "alarm_sound", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            alarmPlayer = try AVAudioPlayer(contentsOf: url)
            alarmPlayer?.play()
        } catch {
            print("Playing alarm exception")
        }
    }
}

extension Int {
    func minToSeconds() -> Int { return self * 60 }
    
    func formatToTime() -> String {
        let min = self / 60
        let sec = self - min * 60
        return "\(addLeadingZero(min)):\(addLeadingZero(sec))"
    }
    
    private func addLeadingZero(_ value: Int) -> String {
        if value < 10 {
            return "0\(value)"
        } else {
            return String(value)
        }
    }
}
