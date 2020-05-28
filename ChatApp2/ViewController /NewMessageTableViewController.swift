//
//  NewMessageTableViewController.swift
//  ChatApp2
//
//  Created by David Saley on 5/10/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class NewMessageTableViewController: UITableViewController {
    static let shared = NewMessageTableViewController()
    
    var users: Array<User> = [User]()
    let cellIdentifire = String(describing: NewMessageTableViewCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftBurButtonItem()
        fetchUser()
        
        tableView.register(NewMessageTableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        
    }
    
    
    //MARK: - Fetch User(Получить пользователя)
    private func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (dataSnapshot) in
            
            if let dictionary = dataSnapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = dataSnapshot.key
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    //MARK: -  UI logic
    
    private func leftBurButtonItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    //MARK: - Buttons logic
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
}


//MARK: - Extension

extension NewMessageTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! NewMessageTableViewCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            MessageTableViewController.shared.showChatController(user: user)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}





