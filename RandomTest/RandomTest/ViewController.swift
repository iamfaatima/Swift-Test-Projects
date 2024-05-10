import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
           super.viewDidLoad()

           // Create and add contacts programmatically
           let contacts = createContactViews()
           setupContactScrollView(contacts: contacts)
       }

       private func createContactViews() -> [ContactView] {
           var contactViews = [ContactView]()

           // Example data for 10 contacts
           let contactsData = [
               ("John Doe", "congrats"),
               ("Jane Smith", "congrats"),
               ("Alice Johnson", "congrats"),
               ("Bob Williams", "congrats"),
               ("Eva Davis", "congrats"),
               ("Michael Brown", "congrats"),
               ("Olivia Wilson", "congrats"),
               ("Daniel Lee", "congrats"),
               ("Sophia Turner", "congrats"),
               ("Matthew Harris", "congrats")
           ]

           for (name, imageName) in contactsData {
               let contactView = ContactView()
               contactView.nameLabel.text = name
               contactView.profileImageView.image = UIImage(named: imageName)
               contactViews.append(contactView)
           }

           return contactViews
       }

    private func setupContactScrollView(contacts: [ContactView]) {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10)
        ])

        var previousContactView: ContactView?

        for contact in contacts {
            scrollView.addSubview(contact)

            NSLayoutConstraint.activate([
                contact.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contact.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contact.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                contact.heightAnchor.constraint(equalToConstant: 80), // Adjust the height as needed
            ])

            if let previousContactView = previousContactView {
                NSLayoutConstraint.activate([
                    contact.topAnchor.constraint(equalTo: previousContactView.bottomAnchor, constant: 10)
                ])
            } else {
                NSLayoutConstraint.activate([
                    contact.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10)
                ])
            }

            previousContactView = contact
        }

        if let lastContact = contacts.last {
            NSLayoutConstraint.activate([
                lastContact.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
        }
    }


   }
import UIKit

class ContactView: UIView {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50 // Adjust the radius as needed
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white // Set a white background color
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let tickButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "checkmark.circle.fill") // Adjust the image as needed
        button.setImage(image, for: .normal)
        button.tintColor = .green // Adjust the color as needed
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(tickButton)
        
        // Layout constraints
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        tickButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100), // Adjust the width as needed
            profileImageView.heightAnchor.constraint(equalToConstant: 100), // Adjust the height as needed
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tickButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 2), // Adjust the spacing
            tickButton.centerXAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            tickButton.widthAnchor.constraint(equalToConstant: 20), // Adjust the width as needed
            tickButton.heightAnchor.constraint(equalToConstant: 20) // Adjust the height as needed
        ])
    }
}
