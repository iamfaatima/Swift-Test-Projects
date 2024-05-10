import UIKit

protocol FirstViewControllerDelegate: AnyObject {
    func didEnterUsername(_ username: String)
}

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    weak var delegate: FirstViewControllerDelegate?

    @IBAction func goToSecondScreen(_ sender: UIButton) {
        if let username = usernameTextField.text, !username.isEmpty {
            delegate?.didEnterUsername(username)

            let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
            secondViewController.delegate = self.delegate // Pass the delegate to the second view controller
            secondViewController.modalPresentationStyle = .fullScreen
            present(secondViewController, animated: true, completion: nil)
        } else {
            print("Please enter a username.")
        }
    }
}

extension ViewController: FirstViewControllerDelegate {
    func didEnterUsername(_ username: String) {
        print("Entered username in ViewController: \(username)")
    }
}
