//
//  NutrientViewController.swift
//  ShelfLife
//
//  Created by Sachin Panayil on 5/1/23.
//

import UIKit
import CoreData

class NutrientViewController: UIViewController {

    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var lblSuger: UILabel!
    @IBOutlet weak var lblFiber: UILabel!
    @IBOutlet weak var lblCarbo: UILabel!
    @IBOutlet weak var lblCholesterol: UILabel!
    @IBOutlet weak var lblPotassium: UILabel!
    @IBOutlet weak var lblSodium: UILabel!
    @IBOutlet weak var lblProtein: UILabel!
    @IBOutlet weak var lblFatSat: UILabel!
    @IBOutlet weak var lblFat: UILabel!
    @IBOutlet weak var lblServing: UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var name: String?
    var API_KEY = "f/1kF2MkQjJZk8xSCPajyg==9jRSnTN00vAml87s"
    
    //Handles Deleting Item
    @IBAction func actionRemove(_ sender: Any) {
        let alert = UIAlertController(title: "Are You Sure?", message: "Do you want to delete this ingredient?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .destructive) {_ in
            self.remove()
        }
        
        let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = name
        
        
    }
    
    //Sets Values Inside Cell from API
    override func viewWillAppear(_ animated: Bool) {
        loadData { foods in
            
            if !foods.isEmpty {
                let food = foods[0]
                self.lblCalories.text   = "\(food.calories)"
                self.lblServing.text    = "\(food.serving_size_g) g"
                self.lblFat.text        = "\(food.fat_total_g) g"
                self.lblFatSat.text     = "\(food.fat_saturated_g) g"
                self.lblProtein.text    = "\(food.protein_g) g"
                self.lblSodium.text     = "\(food.sodium_mg) mg"
                self.lblPotassium.text  = "\(food.potassium_mg) mg"
                self.lblCholesterol.text = "\(food.cholesterol_mg) mg"
                self.lblCarbo.text      = "\(food.carbohydrates_total_g) g"
                self.lblFiber.text      = "\(food.fiber_g) g"
                self.lblSuger.text      = "\(food.sugar_g) g"
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Message!", message: "No results found!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
                
                return
            }
        }
    }
    
    func remove() {
        guard let name = name else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ingredient")
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                managedContext.delete(data)
            }
            
            try managedContext.save()
            print("The row has been deleted.")
            
            self.dismiss(animated: true)
        } catch {
            print("Error: \(error)")
        }
    }
    
}

extension NutrientViewController {
    //Grabs Data from API
    func loadData(completion:@escaping ([Food]) -> ()) {
        progress.startAnimating()
        guard let name = name else { return }
        let query = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.api-ninjas.com/v1/nutrition?query="+query!)!
        var request = URLRequest(url: url)
        request.setValue(API_KEY, forHTTPHeaderField: "X-Api-Key")
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.progress.stopAnimating()
            }
            if (error != nil) {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "No Internet Connection!", preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
                
                return
            }
            
            let foods = try! JSONDecoder().decode([Food].self, from: data!)
            
            print(foods)
            DispatchQueue.main.async {
                completion(foods)
            }
        }.resume()
    }
}
