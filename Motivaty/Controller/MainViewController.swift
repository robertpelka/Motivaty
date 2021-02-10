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
        checkIfHabitsDone()
        changeTitle()
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
    
    func checkIfHabitsDone() {
        for habit in habits {
            if let lastHabitDate = habit.doneDates?.allObjects.last {
                if let lastDate = (lastHabitDate as! HabitDate).date {
                    let lastDateStripped = stripTime(from: lastDate)
                    let today = stripTime(from: Date())
                    if (lastDateStripped == today) {
                        habit.isDone = true
                    }
                }
            }
            else {
                habit.isDone = false
            }
        }
        tableView.reloadData()
        changeTitle()
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
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habits[indexPath.row]
        
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
        checkIfHabitsDone()
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

