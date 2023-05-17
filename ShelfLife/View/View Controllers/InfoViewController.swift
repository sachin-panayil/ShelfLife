//
//  InfoViewController.swift
//  ShelfLife
//
//  Created by Sachin Panayil on 5/15/23.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var btnEnter: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnEnter.roundCorners(corners: .allCorners, radius: btnEnter.bounds.height / 2)
    }

}
