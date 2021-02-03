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
        if habits.count == 1 {
            firstLabel.text = "Hi Robert, there is 1 thing to do today"
        }
        else {
            firstLabel.text = "Hi Robert, there are \(habits.count) things to do today"
        }
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
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

