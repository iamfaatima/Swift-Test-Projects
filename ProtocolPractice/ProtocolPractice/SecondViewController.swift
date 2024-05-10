import UIKit

class SecondViewController: UIViewController, FirstViewControllerDelegate {

    @IBOutlet weak var usernameLabel: UILabel!

    weak var delegate: FirstViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backToFirstScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    func didEnterUsername(_ username: String) {
        DispatchQueue.main.async {
            self.usernameLabel.text = "Welcome, \(username)!"
        }
        print("Username in SecondViewController: \(username)")
    }
}
