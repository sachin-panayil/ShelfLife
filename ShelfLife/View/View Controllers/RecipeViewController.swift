//
//  RecipeViewController.swift
//  ShelfLife
//
//  Created by Sachin Panayil on 5/1/23.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var lblRecipeCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var myRecipes: [MyRecipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.selectedIndex = 1
        
        //Initializes Cell in TableView
        let nib = UINib(nibName: "RecipeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RecipeCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    //Gets Data from Inital Function
    func fetchData() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Ingredient")
        
        do {
            var stringIngredients: [String] = []
            let ingredients = try managedContext.fetch(fetchRequest)
            for ingred in ingredients {
                stringIngredients.append(ingred.value(forKey: "name") as! String)
            }
            
            loadData(ingredientsName: stringIngredients) { recipes in
                self.myRecipes = []
                for recipe in recipes {
                    self.myRecipes.append(MyRecipe(title: recipe.title, image: recipe.image))
                }
                
                self.tableView.reloadData()
                self.lblRecipeCount.text = "You can create \(self.myRecipes.count) recipes!"
            }
            
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
        
        let recipe = myRecipes[indexPath.row]
        
        cell.lblName.text   = recipe.title
        
        // Downloading Images
        downloadImage(from: URL(string: recipe.image!)!, completion: { image in
            DispatchQueue.main.async {
                cell.ivPhoto.image  = image
            }
        })
        
        return cell
    }
    
}


extension RecipeViewController {
    //Grabs Data from API
    func loadData(ingredientsName: [String], completion:@escaping ([Recipe]) -> ()) {
        progress.startAnimating()
        var names = ""
        for name in ingredientsName {
            names += "\(name),"
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "https://"
        urlComponents.path = "api.spoonacular.com/recipes/findByIngredients"
        urlComponents.queryItems = [
            URLQueryItem(name: "apiKey", value: "e4c37e05afec448a9965a4e77c4427f9"),
            URLQueryItem(name: "ingredients", value: names)
        ]
        
        let query =  urlComponents.url?.absoluteString
        let url = URL(string: query!)!
        
        let request = URLRequest(url: url)
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
            
            let recipes = try! JSONDecoder().decode([Recipe].self, from: data!)
            print(recipes)
            DispatchQueue.main.async {
                completion(recipes)
            }
        }.resume()
    }
    
    //Handles Images from API
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in

            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let image = UIImage(data: data)
            completion(image)
        }
        task.resume()
    }
}


