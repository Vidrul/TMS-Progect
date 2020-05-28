
import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

extension LoginViewController {
    
    //MARK: - Buttons logic
    
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
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (res, error) in
            
            guard let uid = res?.user.uid, error == nil else {
                return
            }
            
            //authenticated user
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print(error)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
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
            
            self.dismiss(animated: true, completion: nil)
            
        }
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
    
    
    //MARK: - TapGestureRecognizer logic
    
    @objc private func handleSelectProfileImageView() {
        print(123)
        
    }
    
}
