//
//  NavTwoViewController.swift
//  NavController
//
//  Created by Dev on 18/10/2023.
//

import UIKit

class NavTwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemPink
        let button = UIButton()
        button.setTitle("Nav back", for: .normal)
        button.addTarget(self, action: #selector(navigateToViewControllerOne), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.center = view.center
    }
    
    @objc func navigateToViewControllerOne(){
        //let firstVC = ViewController()
        navigationController?.popViewController(animated: true)
    }


}
