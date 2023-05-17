//
//  HomeViewController.swift
//  ShelfLife
//
//  Created by Sachin Panayil on 5/1/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var ingredients: [NSManagedObject] = []
    
    //Adds Item
    @IBAction func actionAdd(_ sender: Any) {
        let vc = ViewControllers.AddItemViewController.getViewController(storyBoard: .Main)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
    
    //Implements Cell
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    //Calls CoreData Items
    func fetchData() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Ingredient")
        
        do {
            ingredients = try managedContext.fetch(fetchRequest)
            lblItemCount.text = "You have \(ingredients.count) food items logged!"
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    //Creates Rows Based on Count in CoreData
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    //Sets Values in Cells Based on CoreData
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        
        cell.selectionStyle = .none
        
        let greenColor = UIColor(named: "app_green")
        cell.lblDate.textColor = greenColor
        cell.lblDayLeft.textColor = greenColor
        
        let ingredient = ingredients[indexPath.row]
        
        let name = ingredient.value(forKeyPath: "name") as? String
        let date = ingredient.value(forKey: "date") as? Date
        let imageData = ingredient.value(forKey: "image") as? Data
        let image = UIImage(data: imageData ?? Data())
        
        cell.ivItem.image = image
        cell.lblName.text = name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: date ?? Date())
        
        cell.lblDate.text = dateString
        
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.day], from: currentDate, to: date ?? Date())
        
        if let days = components.day {
            cell.lblDayLeft.text = "\(days) Days Left!"
            if days <= 2 {
                cell.lblDate.textColor = .red
                cell.lblDayLeft.textColor = .red
            }
        } else {
            print("Error: Unable to calculate the difference in days")
        }
        return cell
    }
    
    //Handles Clicking on Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewControllers.NutrientViewController.getViewController(storyBoard: .Main) as! NutrientViewController
        let name = ingredients[indexPath.row].value(forKey: "name") as? String
        vc.name = name
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
}


extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed.modalPresentationStyle == .formSheet {
            // Handle form sheet dismissal
            self.fetchData()
            return nil
        }
        return nil
    }
}

