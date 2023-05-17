//
//  Enums.swift
//  ShelfLife
//
//  Created by Sachin Panayil on 5/1/23.
//

import UIKit

enum Storyboards: String {
    case Main = "Main"
}

enum ViewControllers: String {
    case TabbarViewController = "TabbarViewController"
    case AddItemViewController = "AddItemViewController"
    case NutrientViewController = "NutrientViewController"
    
    public func getViewController(storyBoard: Storyboards) -> UIViewController{
        let storyboard = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: self.rawValue)
        return initialViewController
    }
    
}

