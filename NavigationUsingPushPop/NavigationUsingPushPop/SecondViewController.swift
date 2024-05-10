//
//  SecondViewController.swift
//  NavigationUsingPushPop
//
//  Created by Dev on 23/10/2023.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pressBackButton(_ sender: UIButton) {
        
        //third view was created programatically and no storyboard id was given for it
        let thirdViewController = ThirdViewController() // Instantiate your view controller

        // Optionally, you can configure your view controller's properties here if needed.

        // Present your view controller, for example:
        self.navigationController?.pushViewController(thirdViewController, animated: true)

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
