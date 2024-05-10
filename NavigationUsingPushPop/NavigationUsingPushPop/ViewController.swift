//
//  ViewController.swift
//  NavigationUsingPushPop
//
//  Created by Dev on 23/10/2023.
//

import UIKit
//embedded in nav controller

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func PressButton(_ sender: UIButton) {
        
        // Instantiate the new view controller (let's call it NewViewController)
        let secondViewController = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController

        // Push the new view controller onto the navigation stack
        navigationController?.pushViewController(secondViewController, animated: true)

    }
    
}

//summary
//storyboard to storyboard
//@IBAction func PressButton(_ sender: UIButton) {
//    // Instantiate the new view controller (let's call it NewViewController)
//    let secondViewController = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
//
//    // Push the new view controller onto the navigation stack
//    navigationController?.pushViewController(secondViewController, animated: true)
//}

//prog to storyboard
//we need to create a storyboard with UIStoryboard as i have not embedded it in any navigation controller
//@objc func buttonTapped() {
//        // Instantiate the fourth view controller from the storyboard
//        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "YourStoryboardName" with your storyboard's name
//        if let fourthViewController = storyboard.instantiateViewController(withIdentifier: "FourthViewController") as? FourthViewController {
//            // Push the new view controller onto the navigation stack
//            navigationController?.pushViewController(fourthViewController, animated: true)
//        }
//    }


//storyboard to prog
//@IBAction func Goback(_ sender: UIButton) {
//    let fifthViewController = FifthViewController() // Instantiate your view controller
//    // Optionally, you can configure your view controller's properties here if needed.
//    // Present your view controller, for example:
//    self.navigationController?.pushViewController(fifthViewController, animated: true)
//}

//prog to prog
//@objc func buttonTapped2() {
//    // Handle button tap actions here
//    //programmatic
//    //fifth view was created programatically and no storyboard id was given for it
//    let fifthViewController = FifthViewController() // Instantiate your view controller
//    // Optionally, you can configure your view controller's properties here if needed.
//    // Present your view controller, for example:
//    self.navigationController?.pushViewController(fifthViewController, animated: true)
//}
