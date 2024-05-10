//
//  ViewController.swift
//  NavController
//
//  Created by Dev on 18/10/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemPink

        let button = UIButton(type: .system)
        button.setTitle("Nav one", for: .normal)
        button.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        // Change the text color to ensure visibility
        button.setTitleColor(.black, for: .normal)

        button.addTarget(self, action: #selector(navigateToViewControllerTwo), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.center = view.center
    }
    
    @objc func navigateToViewControllerTwo() {
        let secondVC = NavTwoViewController()
        navigationController?.pushViewController(secondVC, animated: true)
    }
}
