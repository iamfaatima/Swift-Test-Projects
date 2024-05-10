//
//  FourthViewController.swift
//  NavigationUsingPushPop
//
//  Created by Dev on 23/10/2023.
//

import UIKit

class FourthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Goback(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        let fifthViewController = FifthViewController() // Instantiate your view controller
        // Optionally, you can configure your view controller's properties here if needed.
        // Present your view controller, for example:
        self.navigationController?.pushViewController(fifthViewController, animated: true)
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

