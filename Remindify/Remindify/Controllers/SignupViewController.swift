
import UIKit
import MBProgressHUD

final class SignupViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    lazy var buttonHorizontalMargin = textFieldHorizontalMargin / 2
    let buttonImageDimension: CGFloat = 18
    lazy var buttonVerticalMargin = (buttonHeight - buttonImageDimension) / 2
    let critterViewDimension: CGFloat = 160
    let critterViewTopMargin: CGFloat = 70
    let textFieldHeight: CGFloat = 37
    let textFieldHorizontalMargin: CGFloat = 16.5
    let textFieldSpacing: CGFloat = 22
    let textFieldTopMargin: CGFloat = 38.8
    let textFieldWidth: CGFloat = 206
    
    lazy var buttonHeight: CGFloat = textFieldHeight
    lazy var buttonWidth: CGFloat = (textFieldHorizontalMargin / 2) + 18
    lazy var buttonFrame: CGRect = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
    
    lazy var critterViewFrame: CGRect = {
           CGRect(x: 0, y: 0, width: critterViewDimension, height: critterViewDimension)
       }()
        
    lazy var critterView = CritterView(frame: critterViewFrame)
    
    lazy var showHidePasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageEdgeInsets = UIEdgeInsets(top: buttonVerticalMargin, left: 0, bottom: buttonVerticalMargin, right: buttonHorizontalMargin)
        button.frame = buttonFrame
        button.tintColor = .text
        button.setImage(#imageLiteral(resourceName: "Password-show"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "Password-hide"), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = createTextField(text: "Email")
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = createTextField(text: "Password")
        textField.isSecureTextEntry = true
        textField.returnKeyType = .go
        textField.rightView = showHidePasswordButton
        showHidePasswordButton.isHidden = true
        return textField
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = createTextField(text: "Name")
        textField.keyboardType = .default
        textField.returnKeyType = .next
        return textField
    }()
    
    lazy var confirmPasswordTextField: UITextField = {
        let textField = createTextField(text: "Confirm Password")
        textField.isSecureTextEntry = true
        textField.returnKeyType = .go
        //textField.rightView = showHidePasswordButton
        //showHidePasswordButton.isHidden = true
        return textField
    }()
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Incorrect password"
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Signup", for: .normal)
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Button Tap Functionality
    
    @objc func loginButtonTapped() {
        //navigate to login
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    @objc func signupButtonTapped() {
        if nameTextField.text == "" {
            DispatchQueue.main.async {
                self.warningLabel.isHidden = false
                self.warningLabel.text = "Name is required"
            }
            return
        }

        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {
            return
        }

        if password == confirmPassword {
            // Show loading indicator
            let loadingIndicator = MBProgressHUD.showAdded(to: view, animated: true)
            loadingIndicator.mode = .indeterminate
            loadingIndicator.label.text = "Signing up..."

            FirebaseService.shared.createUserWithEmail(name, email: email, password: password) { result in
                // Hide loading indicator
                MBProgressHUD.hide(for: self.view, animated: true)

                switch result {
                case .success(let user):
                    print("User registration successful. User: \(user?.email ?? "")")

                    // Navigate to home
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeReminderTableViewController") as! HomeReminderTableViewController
                    self.navigationController?.pushViewController(homeViewController, animated: true)

                case .failure(let error):
                    print("User registration failed. Error: \(error.localizedDescription)")

                    // Show error message
                    DispatchQueue.main.async {
                        self.warningLabel.isHidden = false
                        self.warningLabel.text = "\(error.localizedDescription)"
                    }
                }
            }
        } else {
            self.warningLabel.isHidden = false
            self.warningLabel.text = "Password and Confirm Password do not match"
        }
    }

    
    let notificationCenter: NotificationCenter = .default
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let deadlineTime = DispatchTime.now() + .milliseconds(100)

        if textField == emailTextField || textField == nameTextField {
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                let fractionComplete = self.fractionComplete(for: textField)
                self.critterView.startHeadRotation(startAt: fractionComplete)
                self.passwordDidResignAsFirstResponder()
            }
        } else if textField == passwordTextField || textField == confirmPasswordTextField {
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.critterView.isShy = true
                self.showHidePasswordButton.isHidden = false
            }
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            passwordTextField.resignFirstResponder()
            passwordDidResignAsFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            critterView.stopHeadRotation()
        }
        if textField == nameTextField {
            critterView.stopHeadRotation()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard !critterView.isActiveStartAnimating else { return }

        let fractionComplete = self.fractionComplete(for: textField)
        critterView.updateHeadRotation(to: fractionComplete)

        if textField == emailTextField || textField == nameTextField {
            if let text = textField.text {
                critterView.isEcstatic = text.contains("@")
            }
        }
    }

    
    // MARK: -
    
    func setUpView() {
        navigationItem.hidesBackButton = true
        view.backgroundColor = .dark
        
        view.addSubview(critterView)
        setUpCritterViewConstraints()
        
        view.addSubview(nameTextField)
        setUpNameTextFieldConstraints()
        
        view.addSubview(emailTextField)
        setUpEmailTextFieldConstraints()
        
        view.addSubview(passwordTextField)
        setUpPasswordTextFieldConstraints()
        
        view.addSubview(confirmPasswordTextField)
        setUpConfirmPasswordTextFieldConstraints()
        
        view.addSubview(warningLabel)
        setUpWarningLabelConstraints()
        
        view.addSubview(loginButton)
        setUpLoginButtonConstraints()
        
        view.addSubview(signupButton)
        setUpSignupButtonConstraints()
        
        
        setUpGestures()
        setUpNotification()
        debug_setUpDebugUI()
    }
    
    func setUpNameTextFieldConstraints() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: textFieldWidth).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: critterView.bottomAnchor, constant: textFieldSpacing).isActive = true
    }

    func setUpEmailTextFieldConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: textFieldWidth).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: textFieldSpacing).isActive = true
    }

    func setUpPasswordTextFieldConstraints() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: textFieldWidth).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: textFieldSpacing).isActive = true
    }

    func setUpConfirmPasswordTextFieldConstraints() {
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        confirmPasswordTextField.widthAnchor.constraint(equalToConstant: textFieldWidth).isActive = true
        confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: textFieldSpacing).isActive = true
    }

    func setUpWarningLabelConstraints() {
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 8).isActive = true
        warningLabel.font = UIFont.systemFont(ofSize: 12)
        warningLabel.adjustsFontSizeToFitWidth = true
        warningLabel.minimumScaleFactor = 0.5 // Adjust this value as needed
    }

    func setUpLoginButtonConstraints() {
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60).isActive = true
        loginButton.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 16).isActive = true
    }

    func setUpSignupButtonConstraints() {
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60).isActive = true
        signupButton.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 16).isActive = true
    }

    
    func setUpCritterViewConstraints() {
        critterView.translatesAutoresizingMaskIntoConstraints = false
        critterView.heightAnchor.constraint(equalToConstant: critterViewDimension).isActive = true
        critterView.widthAnchor.constraint(equalTo: critterView.heightAnchor).isActive = true
        critterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        critterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: critterViewTopMargin).isActive = true
    }
    
    func fractionComplete(for textField: UITextField) -> Float {
        guard let text = textField.text, let font = textField.font else { return 0 }
        let textFieldWidth = textField.bounds.width - (2 * textFieldHorizontalMargin)
        return min(Float(text.size(withAttributes: [NSAttributedString.Key.font : font]).width / textFieldWidth), 1)
    }
    
    func stopHeadRotation() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        critterView.stopHeadRotation()
        passwordDidResignAsFirstResponder()
    }
    
    func passwordDidResignAsFirstResponder() {
        critterView.isPeeking = false
        critterView.isShy = false
        showHidePasswordButton.isHidden = true
        showHidePasswordButton.isSelected = false
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }
    
    func createTextField(text: String) -> UITextField {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: textFieldWidth, height: textFieldHeight))
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.07
        view.tintColor = .dark
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.spellCheckingType = .no
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let frame = CGRect(x: 0, y: 0, width: textFieldHorizontalMargin, height: textFieldHeight)
        view.leftView = UIView(frame: frame)
        view.leftViewMode = .always
        
        view.rightView = UIView(frame: frame)
        view.rightViewMode = .always
        
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        view.textColor = .text
        
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.disabledText,
            .font : view.font!
        ]
        
        view.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
        
        return view
    }
    
    // MARK: - Gestures
    
    func setUpGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc   func handleTap() {
        stopHeadRotation()
    }
    
    // MARK: - Actions
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isPasswordVisible = sender.isSelected

        passwordTextField.isSecureTextEntry = !isPasswordVisible
        confirmPasswordTextField.isSecureTextEntry = !isPasswordVisible

        critterView.isPeeking = isPasswordVisible

        // 🎩✨ Magic to fix cursor position when toggling password visibility for passwordTextField
        if let textRange = passwordTextField.textRange(from: passwordTextField.beginningOfDocument, to: passwordTextField.endOfDocument), let password = passwordTextField.text {
            passwordTextField.replace(textRange, withText: password)
        }

        // 🎩✨ Magic to fix cursor position when toggling password visibility for confirmPasswordTextField
        if let textRange = confirmPasswordTextField.textRange(from: confirmPasswordTextField.beginningOfDocument, to: confirmPasswordTextField.endOfDocument), let confirmPassword = confirmPasswordTextField.text {
            confirmPasswordTextField.replace(textRange, withText: confirmPassword)
        }
    }

    
    // MARK: - Notifications
    
    func setUpNotification() {
        notificationCenter.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc   func applicationDidEnterBackground() {
        stopHeadRotation()
    }
    
    // MARK: - Debug Mode
    
    let isDebugMode = false
    
    lazy var dubug_activeAnimationSlider = UISlider()
    
    func debug_setUpDebugUI() {
        guard isDebugMode else { return }
        
        let animateButton = UIButton(type: .system)
        animateButton.setTitle("Activate", for: .normal)
        animateButton.setTitleColor(.white, for: .normal)
        animateButton.addTarget(self, action: #selector(debug_activeAnimation), for: .touchUpInside)
        
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Neutral", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.addTarget(self, action: #selector(debug_neutralAnimation), for: .touchUpInside)
        
        let validateButton = UIButton(type: .system)
        validateButton.setTitle("Ecstatic", for: .normal)
        validateButton.setTitleColor(.white, for: .normal)
        validateButton.addTarget(self, action: #selector(debug_ecstaticAnimation), for: .touchUpInside)
        
        dubug_activeAnimationSlider.tintColor = .light
        dubug_activeAnimationSlider.isEnabled = false
        dubug_activeAnimationSlider.addTarget(self, action: #selector(debug_activeAnimationSliderValueChanged(sender:)), for: .valueChanged)
        
        let stackView = UIStackView(
            arrangedSubviews:
                [
                    animateButton,
                    resetButton,
                    validateButton,
                    dubug_activeAnimationSlider
                ]
        )
        stackView.axis = .vertical
        stackView.spacing = 5
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc   func debug_activeAnimation() {
        critterView.startHeadRotation(startAt: dubug_activeAnimationSlider.value)
        dubug_activeAnimationSlider.isEnabled = true
    }
    
    @objc   func debug_neutralAnimation() {
        stopHeadRotation()
        dubug_activeAnimationSlider.isEnabled = false
    }
    
    @objc   func debug_ecstaticAnimation() {
        critterView.isEcstatic.toggle()
    }
    
    @objc   func debug_activeAnimationSliderValueChanged(sender: UISlider) {
        critterView.updateHeadRotation(to: sender.value)
    }
}
