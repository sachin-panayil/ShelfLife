//
//  StartViewController.swift
//  ShelfLife
//
//  Created by Sachin Panayil on 5/1/23.
//

import UIKit

class StartViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var btnEnter: UIButton!
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lblLive: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func actionEnter(_ sender: Any) {
        let vc = ViewControllers.TabbarViewController.getViewController(storyBoard: .Main)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnEnter.roundCorners(corners: .allCorners, radius: btnEnter.bounds.height / 2)
        
        //Displays User Default
        if let userName = UserDefaults.standard.string(forKey: "name"), !userName.isEmpty {
            nameLabel.text = userName
        } else {
            nameLabel.text = "First Time Visitor!"
        }
        
        // Do any additional setup after loading the view.
    }
    
    //Animation Code Block
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.ivLogo.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                self.lblLive.alpha = 1
            }) { (true) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.welcomeLabel.alpha = 1
                }) { (true) in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.nameLabel.alpha = 1
                    }) { (true) in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.btnEnter.alpha = 1
                        })
                    }
                }
            }
        }
    }
    
}
