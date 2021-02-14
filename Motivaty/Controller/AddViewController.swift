//
//  AddViewController.swift
//  Motivaty
//
//  Created by Robert Pelka on 01/02/2021.
//

import UIKit
import UserNotifications

class AddViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var picker  = UIPickerView()
    let emojis = [ "🚀", "💪", "📚", "🏋️", "🎸", "🧠", "💼", "🐶", "🐱", "🔥", "🥦", "🥗", "💻", "⏰", "🔧", "💊", "🚬", "🛏", "🔭", "🔬", "🖋"]
    var selectedEmojiRow = 0
    var isReminderSet = true
    var hour = 18
    var minute = 0
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var disableReminderButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        
        addButton.layer.cornerRadius = addButton.frame.size.height/2
        
        requestAuthForNotifications()
        
        // Dismiss iOS Keyboard when touching anywhere outside UITextField
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    func requestAuthForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if let e = error {
                print(e.localizedDescription)
            }
        }
    }
    
    func showPickerView(with tag: Int) {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = tag
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.95)
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        if (tag == 0) {
            picker.selectRow(selectedEmojiRow, inComponent: 0, animated: true)
        }
        if (tag == 1) {
            picker.selectRow(hour, inComponent: 0, animated: true)
            picker.selectRow(minute, inComponent: 1, animated: true)
        }
        self.view.addSubview(picker)
    }
    
    @IBAction func changeEmojiPressed(_ sender: UIButton) {
        showPickerView(with: 0)
    }
    
    @IBAction func timePressed(_ sender: UIButton) {
        showPickerView(with: 1)
    }
    
    @IBAction func disableReminderPressed(_ sender: UIButton) {
        isReminderSet = !isReminderSet
        if (isReminderSet) {
            let hourString = String(format: "%02d", hour)
            let minuteString = String(format: "%02d", minute)
            reminderButton.isEnabled = true
            reminderButton.setTitle("Everyday \(hourString):\(minuteString)", for: .normal)
            disableReminderButton.setTitle("Disable", for: .normal)
        }
        else {
            reminderButton.isEnabled = false
            reminderButton.setTitle("None", for: .normal)
            disableReminderButton.setTitle("Enable", for: .normal)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let title = titleField.text, !title.isEmpty {
            let newHabit = Habit(context: self.context)
            newHabit.title = title
            newHabit.emoji = emojis[selectedEmojiRow]
            // Setting notification
            if (isReminderSet) {
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = "\(emojis[selectedEmojiRow]) Reminder"
                notificationContent.body = title
                notificationContent.sound = .default
                notificationContent.badge = NSNumber(value: 1)
                
                var time = DateComponents()
                time.hour = hour
                time.minute = minute
                
                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
                let notificationID = UUID().uuidString
                newHabit.notificationID = notificationID
                let notificationRequest = UNNotificationRequest(identifier: notificationID, content: notificationContent, trigger: notificationTrigger)
                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                    if let e = error {
                        print(e.localizedDescription)
                    }
                }
            }
            
            saveContext()
            self.performSegue(withIdentifier: K.Segues.goBackToMain, sender: self)
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        }
        catch {
            print("Error saving context, \(error)")
        }
    }

}

//MARK: - UITextFieldDelegate

extension AddViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
            return false
    }
    
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if (pickerView.tag == 0) {
            return 1
        }
        else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            return emojis.count
        }
        else {
            if (component == 0) {
                return 25
            }
            else {
                return 60
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return emojis[row]
        }
        else {
            return String(format: "%02d", row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            selectedEmojiRow = row
            emojiLabel.text = emojis[row]
            pickerView.isHidden = true
        }
        else {
            if (component == 0) {
                hour = row
            }
            else {
                minute = row
                let hourString = String(format: "%02d", hour)
                let minuteString = String(format: "%02d", minute)
                reminderButton.setTitle("Everyday \(hourString):\(minuteString)", for: .normal)
                pickerView.isHidden = true
            }
        }
    }
    
}
