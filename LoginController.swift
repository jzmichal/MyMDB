//
//  LoginController.swift
//  MyMDB
//
//  Created by Justin Michal on 1/13/19.
//  Copyright © 2019 Justin Michal. All rights reserved.
//

import UIKit
import Firebase
class LoginController: UIViewController {
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor =  UIColor(r: 10, g: 10, b:10)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    @objc func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    @objc func handleLogin() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().signIn(withEmail: username + "@gmail.com", password: password) { (user, error) in
            if error != nil{
                print(error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    @objc func handleRegister() {
        
        guard let email = emailAddressTextField.text, let password = passwordTextField.text, let username = usernameTextField.text, let retypepassword = retypepasswordTextField.text else {
            print("Form is not valid")
            return
        }
//        if password != retypepassword {
//            print("Passwords do not match")
//            return
//        }
        Auth.auth().createUser(withEmail: username + "@gmail.com", password: password) { (authResult, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let user = authResult?.user else { return }
            let ref = Firebase.Database.database().reference(fromURL: "https://mymdb-c3989.firebaseio.com/")
            let usersReference = ref.child("users").child(user.uid)
            let values = ["user": username, "email": email, "password": password]
            usersReference.updateChildValues(values) { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailAddressTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    let retypepasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Re-type Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let usernameSeparatorView: UIView = {
        let view =  UIView()
        view.backgroundColor = UIColor(r:220, g:220, b:220)
        view.translatesAutoresizingMaskIntoConstraints =  false
        return view
    }()
    let emailAddressSeparatorView: UIView = {
        let view =  UIView()
        view.backgroundColor = UIColor(r:220, g:220, b:220)
        view.translatesAutoresizingMaskIntoConstraints =  false
        return view
    }()
    let passwordSeparatorView: UIView = {
        let view =  UIView()
        view.backgroundColor = UIColor(r:220, g:220, b:220)
        view.translatesAutoresizingMaskIntoConstraints =  false
        return view
    }()
    
    let profileImageView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor(r: 50, g: 50, b: 50)
        tv.text = "My Movie Database"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = UIColor.orange
        tv.font = UIFont.boldSystemFont(ofSize: 24)
        tv.font = UIFont(name: "Zapfino" , size: 24)
        tv.isEditable = false
        return tv
    }()
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    @objc func handleLoginRegisterChange() {
        title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        //change height of inputs container, but HOW???
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ?
            100 : 150
        //toggle emailAddress textfield of usernameTextField
        emailAddressTextFieldHeightAnchor?.isActive = false
        emailAddressTextFieldHeightAnchor = emailAddressTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        emailAddressTextFieldHeightAnchor?.isActive = true
        //toggle retype password textfield
        retypePasswordTextFieldHeightAnchor?.isActive = false
        retypePasswordTextFieldHeightAnchor = retypepasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        retypePasswordTextFieldHeightAnchor?.isActive = true
        //make username textfield twice as large if on login screen
        usernametextFieldHeightAnchor?.isActive = false
        usernametextFieldHeightAnchor = usernameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        usernametextFieldHeightAnchor?.isActive = true
        //make password textfield twice as large if on login screen
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(r: 50, g: 50, b: 50)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        
    }
    func setupLoginRegisterSegmentedControl(){
        //need x,y height, width constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupProfileImageView() {
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -1).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive =  true
        
    }
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var emailAddressTextFieldHeightAnchor: NSLayoutConstraint?
    var usernameSeparatorHeightAnchor: NSLayoutConstraint?
    var retypePasswordTextFieldHeightAnchor: NSLayoutConstraint?
    var usernametextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    func setupInputsContainerView() {
        //need x,y height, width constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        
        inputsContainerView.addSubview(usernameTextField)
        inputsContainerView.addSubview(usernameSeparatorView)
        inputsContainerView.addSubview(emailAddressTextField)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(retypepasswordTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        inputsContainerView.addSubview(emailAddressSeparatorView)
        
        usernameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        usernametextFieldHeightAnchor = usernameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        usernametextFieldHeightAnchor?.isActive = true
        
        
        usernameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        usernameSeparatorView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        usernameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        usernameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        emailAddressTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailAddressTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        emailAddressTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailAddressTextFieldHeightAnchor = emailAddressTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        emailAddressTextFieldHeightAnchor?.isActive = true
        
        emailAddressSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailAddressSeparatorView.topAnchor.constraint(equalTo: emailAddressTextField.bottomAnchor).isActive = true
        emailAddressSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailAddressSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailAddressTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor =  passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
        
        passwordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        retypepasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        retypepasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        retypepasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        retypePasswordTextFieldHeightAnchor = retypepasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        retypePasswordTextFieldHeightAnchor?.isActive = true
        
    }
    func setupLoginRegisterButton() {
        //need x,y height, width constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive =  true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1/2).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive =  true
        
    }
    
    //override func preferredStatusBarStyle() -> UIStatusBarStyle {
       // return .lightContent
    //}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
