//
//  ViewController.swift
//  NavigationWithoutNavController
//
//  Created by Dev on 23/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func GoAhead(_ sender: UIButton) {
        let secondViewController = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
            // Push the new view controller onto the navigation stack
        
            navigationController?.pushViewController(secondViewController, animated: true)
    }
    
}
