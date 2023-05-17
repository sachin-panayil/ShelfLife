//
//  SettingsViewController.swift
//  ShelfLife
//
//  Created by Sachin Panayil on 5/15/23.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        nameTextField.roundCorners(corners: .allCorners, radius: nameTextField.bounds.height / 2)
        
        //Sets Placeholder Text to UserDEfault if Available
        if let savedValue = UserDefaults.standard.string(forKey: "name") {
            nameTextField.placeholder = savedValue
        }
    }

    //Creates UserDefault for Name
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = nameTextField.text, !text.isEmpty {
            UserDefaults.standard.set(text, forKey: "name")
            textField.placeholder = text
        }
    }
}
