//
//  ThirdViewController.swift
//  NavigationUsingPushPop
//
//  Created by Dev on 23/10/2023.
//

import UIKit

class FifthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure UI elements
            let label = UILabel()
            label.text = "Fifth"
            label.textAlignment = .center
            label.frame = CGRect(x: 50, y: 300, width: 200, height: 30)

        
        // Create and configure a UIButton
        let button = UIButton(type: .system)
        button.setTitle("go to first view", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 400, width: 200, height: 30)
        view.backgroundColor = UIColor.white
        
        let button2 = UIButton(type: .system)
        button2.setTitle("go back", for: .normal)
        button2.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
        button2.frame = CGRect(x: 100, y: 500, width: 200, height: 30)
        view.backgroundColor = UIColor.white
        // Add the UIButton to the view
        view.addSubview(button)
        view.addSubview(button2)
        view.addSubview(label)
    }
    
    @objc func buttonTapped() {
        // Handle button tap actions here
        //navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc func buttonTapped2() {
        // Handle button tap actions here
        //navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}
