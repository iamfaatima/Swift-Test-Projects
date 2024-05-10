//
//  NavOneViewController.swift
//  NavigationControllerPractice
//
//  Created by Dev on 18/10/2023.
//

import UIKit

class NavOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton()
        button.setTitle("Nav one", for: .normal)
        button.addTarget(self, action: #selector(navigateToViewControllerTwo), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.center = view.center
    }
    
    @objc func navigateToViewControllerTwo(){
        let secondVC = NavTwoViewController()
        navigationController?.pushViewController(secondVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
