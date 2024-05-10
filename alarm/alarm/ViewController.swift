import UIKit
import SwipeCellKit// Import SwipeCellKit
class ViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    let tableView = UITableView()
    let searchBar = UISearchBar()
    let footerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    @objc func addReminderButtonTapped() {
        // Handle the "Add Reminder" button tap event here
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in your table
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.titleLabel.text = "Reminder \(indexPath.row)"
        cell.detailLabel.text = "Details about Reminder \(indexPath.row)"
        return cell
    }
    
    func setupUI(){
        // Set up the search bar
        searchBar.delegate = self
        searchBar.placeholder = "Search Reminders"
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1.0) // Sea-green shade
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = .white
        searchBar.isTranslucent = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        // Set up the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .clear // No background color
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        // Set up the footer view with sea-green background color
        footerView.backgroundColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1.0) // Sea-green shade
        footerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerView)

        // Add the "Add Reminder" button with a three-dot SF symbol
        let addButton = UIButton()
        addButton.setTitle("Add Reminder", for: .normal)
        addButton.tintColor = .white
        addButton.backgroundColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1.0) // Sea-green shade
        addButton.layer.cornerRadius = 8
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addReminderButtonTapped), for: .touchUpInside)
        footerView.addSubview(addButton)

        // Layout constraints
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),

            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60),

            addButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            addButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

class CustomTableViewCell: SwipeTableViewCell {
    let titleLabel = UILabel()
    let detailLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUI()
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
           contentView.backgroundColor = .clear // No background color
           contentView.layer.cornerRadius = 10
           contentView.layer.shadowColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 0.4).cgColor // Sea-green shadow
           contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
           contentView.layer.shadowRadius = 4
           contentView.layer.shadowOpacity = 1.0

           titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
           titleLabel.textColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1.0) // Sea-green color
           titleLabel.numberOfLines = 0

           detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
           detailLabel.textColor = .darkGray
           detailLabel.numberOfLines = 0

           addSubview(titleLabel)
           addSubview(detailLabel)

           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           detailLabel.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
               titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),

               detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
               detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
               detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
               detailLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
           ])
       }
   }

   // Implement SwipeTableViewCellDelegate methods
   extension CustomTableViewCell: SwipeTableViewCellDelegate {
       func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
           guard orientation == .right else { return nil }
           
           // Swipe action to print "Shipped" in the console
           let shippedAction = SwipeAction(style: .destructive, title: "Shipped") { action, indexPath in
               print("Shipped")
           }

           shippedAction.image = UIImage(systemName: "trash")
           
           return [shippedAction]
       }
   }
