//
//  MainViewController.swift
//  Motivaty
//
//  Created by Robert Pelka on 30/01/2021.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var habits = [Habit]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.layer.cornerRadius = 30
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.Cell.cellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.cellIdentifier)
        
        loadHabits()
        refreshHabits()
    }
    
    func loadHabits() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        do {
            habits = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context, \(error.localizedDescription)")
        }
    }
    
    func refreshHabits() {
        DispatchQueue.main.async {
            self.checkIfHabitsDone()
            self.countStreak()
            self.changeTitle()
        }
    }
    
    func checkIfHabitsDone() {
        for habit in habits {
            habit.isDone = false
            if let lastHabitDate = habit.doneDates?.allObjects.last {
                if let lastDate = (lastHabitDate as! HabitDate).date {
                    let lastDateStripped = stripTime(from: lastDate)
                    let today = stripTime(from: Date())
                    if (lastDateStripped == today) {
                        habit.isDone = true
                    }
                }
            }
        }
        tableView.reloadData()
        changeTitle()
    }
    
    func countStreak() {
        for habit in habits {
            var streak = 0
            var day = Date()
            if let habitDates = habit.doneDates?.allObjects {
                for habitDate in habitDates.reversed() {
                    if let date = (habitDate as! HabitDate).date {
                        let dayStripped = stripTime(from: day)
                        let dateStripped = stripTime(from: date)
                        if (dayStripped == dateStripped) {
                            streak += 1
                        }
                        else {
                            break
                        }
                        let dayComponent = DateComponents(day: -1)
                        if let dayMinusDay = Calendar.current.date(byAdding: dayComponent, to: day) {
                            day = dayMinusDay
                        }
                    }
                }
            }
            habit.streak = Int64(streak)
        }
    }
    
    func stripTime(from originalDate: Date) -> Date? {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: originalDate)
        let date = Calendar.current.date(from: components)
        return date
    }
    
    func changeTitle() {
        var habitsLeft = 0
        for habit in habits {
            if (!habit.isDone) {
                habitsLeft += 1
            }
        }
        
        let more = (habits.count != habitsLeft) ? " more" : ""
        
        if (habitsLeft == 0 && habits.count > 0) {
            firstLabel.text = "You did everything!\nNow it’s time to play!"
            secondLabel.text = "Come back tomorrow"
            imageView.image = UIImage(named: K.Images.happyDog)
        }
        else {
            secondLabel.text = "Just do it already"
            imageView.image = UIImage(named: K.Images.dog)
        }
        
        if (habits.count == 0) {
            firstLabel.text = "Hi Robert, add some things to do"
            secondLabel.text = "Press plus button"
        }
        else if (habitsLeft == 1) {
            firstLabel.text = "Hi Robert, there is 1\(more) thing to do today"
        }
        else if (habitsLeft > 1) {
            firstLabel.text = "Hi Robert, there are \(habitsLeft)\(more) things to do today"
        }
    }
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.loadHabits()
                self.tableView.reloadData()
            }
        }
    }
    
}

//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let habit = habits[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.cellIdentifier, for: indexPath) as! ToDoCell
        cell.emojiLabel.text = habit.emoji
        cell.titleLabel.text = habit.title
        cell.doneImage.image = habit.isDone ? UIImage(named: K.Images.done) : UIImage(named: K.Images.notDone)
        cell.streakImage.image = (habit.streak < 13) ? UIImage(named: "streak\(habit.streak)") : UIImage(named: "streak13")
        cell.streakLabel.text = (habit.streak == 1) ? "1 day streak" : "\(habit.streak) days streak"
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habits[indexPath.row]
        print("SELECT")
        if (!habit.isDone) {
            let newHabitDate = HabitDate(context: self.context)
            newHabitDate.date = Date()
            newHabitDate.doneHabit = habit
        }
        else {
            let delete = habit.doneDates?.allObjects.last as! NSManagedObject
            context.delete(delete)
        }
        
        saveContext()
        refreshHabits()
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

