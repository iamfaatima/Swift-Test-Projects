//
//  ThirdViewController.swift
//  NavigationUsingPushPop
//
//  Created by Dev on 23/10/2023.
//

import UIKit

class ThirdViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure a UIButton
        let button = UIButton(type: .system)
        button.setTitle("go to storyboard", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 400, width: 200, height: 30)
        view.backgroundColor = UIColor.white
        
        let button2 = UIButton(type: .system)
        button2.setTitle("go to programatic storyboard", for: .normal)
        button2.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
        button2.frame = CGRect(x: 100, y: 500, width: 200, height: 30)
        view.backgroundColor = UIColor.white
        
        // Create and configure UI elements
            let label = UILabel()
            label.text = "Third"
            label.textAlignment = .center
            label.frame = CGRect(x: 50, y: 300, width: 200, height: 30)

        
        // Add the UIButton to the view
        view.addSubview(button)
        view.addSubview(button2)
        view.addSubview(label)
    }
    
    @objc func buttonTapped() {
            // Instantiate the fourth view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "YourStoryboardName" with your storyboard's name
            if let fourthViewController = storyboard.instantiateViewController(withIdentifier: "FourthViewController") as? FourthViewController {
                // Push the new view controller onto the navigation stack
                navigationController?.pushViewController(fourthViewController, animated: true)
            }
        }
    
    @objc func buttonTapped2() {
        // Handle button tap actions here
        //programmatic
        
        //fifth view was created programatically and no storyboard id was given for it
        let fifthViewController = FifthViewController() // Instantiate your view controller

        // Optionally, you can configure your view controller's properties here if needed.

        // Present your view controller, for example:
        self.navigationController?.pushViewController(fifthViewController, animated: true)
    }
}
