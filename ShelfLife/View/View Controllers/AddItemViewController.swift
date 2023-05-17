//
//  AddItemViewController.swift
//  ShelfLife
//
//  Created by Sachin Panayil on 5/1/23.
//

import UIKit
import Photos
import CoreData

class AddItemViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivPhoto: UIImageView!
    
    var imageData: Data?
    let imagePicker = UIImagePickerController()
    
    @IBAction func actionAdd(_ sender: Any) {
        save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the image picker
        DispatchQueue.main.async {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.imagePicker.cameraCaptureMode = .photo
            self.imagePicker.allowsEditing = false
            _ = self.imagePicker.view
        }
 
        ivPhoto.borderAndCorner(cornerRadious: 30, borderWidth: 1.5, borderColor: UIColor(named: "app_green"))
        ivPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc func tapImage() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Alright", style: .default, handler: { (alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            handleCamera()
        }
        
    }
    
    func save() {
        guard  let name = tfName.text else {
            let alert = UIAlertController(title: "Error!", message: "Please enter name of igredient", preferredStyle: .alert)
            present(alert, animated: true)
            return
        }
        
        let date = datePicker.date
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Ingredient", in: managedContext)!
        let ingredient = NSManagedObject(entity: entity, insertInto: managedContext)
        
        ingredient.setValue(name, forKeyPath: "name")
        ingredient.setValue(date, forKey: "date")
        ingredient.setValue(imageData, forKey: "image")
        
        do {
            try managedContext.save()
            
            self.dismiss(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleCamera(){
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status{
        case .authorized:
            self.openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openCamera()
                }
            }
        case .denied, .restricted:
            return
            
        default:
            break
        }
    }
    
    func openCamera(){
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let chosenImage = info[.originalImage] as? UIImage {
            print(chosenImage)
            let data = chosenImage.jpegData(compressionQuality: 1)
            imageData = data
            if let image = UIImage(data: data ?? Data()) {
                self.ivPhoto.image = image
                self.ivPhoto.contentMode = .scaleAspectFill
            }
        }
    }
    
    // Handle canceling the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


