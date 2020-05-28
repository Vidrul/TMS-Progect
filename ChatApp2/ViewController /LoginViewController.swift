//
//  ViewController.swift
//  ChatApp2
//
//  Created by David Saley on 5/7/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class LoginViewController: UIViewController {
    static let shared = LoginViewController()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextFiled: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextFiled: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextFiled: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "edit-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let loginRegisterSegmentControll: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Login", "Register"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.layer.borderColor = UIColor.white.cgColor
        segmentControl.selectedSegmentTintColor = UIColor.white
        segmentControl.layer.borderWidth = 0.5
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for:.normal)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentControl.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        segmentControl.selectedSegmentIndex = 1
        segmentControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return segmentControl
    }()
    
    let pickerController = UIImagePickerController()
    var inputsContainerViewHeighAnchor: NSLayoutConstraint?
    var nameTextFiledHeightAnchor: NSLayoutConstraint?
    var emailTextFiledHeightAnchor: NSLayoutConstraint?
    var passwordTextFiledHeightAnchor: NSLayoutConstraint?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        self.view.addSubview(inputsContainerView)
        self.view.addSubview(loginRegisterButton)
        self.view.addSubview(profileImageView)
        self.view.addSubview(loginRegisterSegmentControll)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegiterSegmentControl()
        pickerController.delegate = self
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: - Configure constraints
    
    private func setupInputsContainerView () {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeighAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeighAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextFiled)
        inputsContainerView.addSubview(nameSeparatorView)
        
        inputsContainerView.addSubview(emailTextFiled)
        inputsContainerView.addSubview(emailSeparatorView)
        
        inputsContainerView.addSubview(passwordTextFiled)
        
        //NameTextFiled
        nameTextFiled.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextFiled.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextFiled.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFiledHeightAnchor = nameTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFiledHeightAnchor?.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextFiled.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //EmailTextFiled
        emailTextFiled.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextFiled.topAnchor.constraint(equalTo: nameTextFiled.bottomAnchor).isActive = true
        emailTextFiled.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        emailTextFiledHeightAnchor = emailTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFiledHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextFiled.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //PasswordTextField
        passwordTextFiled.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextFiled.topAnchor.constraint(equalTo: emailTextFiled.bottomAnchor).isActive = true
        passwordTextFiled.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        passwordTextFiledHeightAnchor = passwordTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFiledHeightAnchor?.isActive = true
    }
    
    private func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.centerYAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 30).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentControll.topAnchor, constant: -15).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func setupLoginRegiterSegmentControl () {
        loginRegisterSegmentControll.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentControll.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentControll.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentControll.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    //MARK: - Buttons logic(Handles)
    
    @objc private func handleLoginRegister() {
        if loginRegisterSegmentControll.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    @objc private func handleRegister() {
        guard let email = emailTextFiled.text, let password = passwordTextFiled.text, let name = nameTextFiled.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(res, error) in
            guard let uid = res?.user.uid, error == nil else {
                return
            }
            
            //authenticated user
            let storageRef = Storage.storage().reference().child("Profile_Image").child(uid)
            
            guard let imageData = self.profileImageView.image?.jpegData(compressionQuality: 0.1) else {return}
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            storageRef.putData(imageData, metadata: metaData) { (metadata, error) in
                guard let _ = metadata, error == nil else {return}
                
                storageRef.downloadURL { (url, error) in
                    guard let url = url, error == nil else {return}
                    
                    let values = ["name": name, "email": email, "profileImageUrl": url.absoluteString]
                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                }
            }
        })
    }
    
    @objc private func handleLogin() {
        guard let email = emailTextFiled.text, let password = passwordTextFiled.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
           
            if let error = error {
                print(error)
                return
            }
            MessageTableViewController.shared.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - RegisterUserIntoDatabaseWithUID
    private func registerUserIntoDatabaseWithUID(uid: String,values: [String: AnyObject]) {
           let ref = Database.database().reference()
           let usersReference = ref.child("users").child(uid)
           
           usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            guard error == nil else {return}
            
            let user = User(dictionary: values)
            MessageTableViewController.shared.setupNavBarWithUser(user: user)
               self.dismiss(animated: true, completion: nil)
           })
       }
    
    //MARK: - SegmentControl logic
    
    @objc private func handleLoginRegisterChange () {
        let title = loginRegisterSegmentControll.titleForSegment(at: loginRegisterSegmentControll.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        inputsContainerViewHeighAnchor?.constant = loginRegisterSegmentControll.selectedSegmentIndex == 0 ? 100:150
        nameTextFiledHeightAnchor?.isActive = false
        nameTextFiledHeightAnchor = nameTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControll.selectedSegmentIndex == 0 ? 0:1 / 3)
        nameTextFiledHeightAnchor?.isActive = true
        
        emailTextFiledHeightAnchor?.isActive = false
        emailTextFiledHeightAnchor = emailTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControll.selectedSegmentIndex == 0 ? 1 / 2:1 / 3)
        emailTextFiledHeightAnchor?.isActive = true
        
        passwordTextFiledHeightAnchor?.isActive = false
        passwordTextFiledHeightAnchor = passwordTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControll.selectedSegmentIndex == 0 ? 1 / 2:1 / 3)
        passwordTextFiledHeightAnchor?.isActive = true
    }
    
    
}
