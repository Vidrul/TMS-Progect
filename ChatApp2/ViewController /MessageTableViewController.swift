

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth


class MessageTableViewController: UITableViewController {
    static var shared = MessageTableViewController()
    
    var messages:[Message] = [Message]()
    var messagesDictionary = [String: Message]()
    let cellIdentifire = String(describing: MessageTableViewControllerCell.self)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftBurButtonItem()
        rightBurButtonItem()
        checkIfUserIsLoggedIn()
        
        
        tableView.register(MessageTableViewControllerCell.self, forCellReuseIdentifier: cellIdentifire)
        
    }
    
    //MARK: - Check User
    private func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogut), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    //MARK: - FetchUseAndSetupNavBarTitle(выбор пользователей и настройки navBar заголовка)
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    //MARK: - Obser Messages
    
    private func obserUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message(dictionary: dictionary)
                    
                    if let chatPartnerId = message.chatPartherId() {
                        self.messagesDictionary[chatPartnerId] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort { (messages1, messages2) -> Bool in
                            if let messages1 = messages1.timestamp?.intValue, let messages2 = messages2.timestamp?.intValue {
                                return messages1 > messages2
                            }
                            return false
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    //MARK: - UI logic
    private func leftBurButtonItem () {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogut))
        
    }
    
    private func rightBurButtonItem() {
        let image = UIImage(named:"new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    
    func setupNavBarWithUser(user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        obserUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        navigationItem.titleView = titleView
        
        
    }
    
    
    
    //MARK: - BarButtonTap logic
    @objc private func handleLogut () {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        if let loginViewController = LoginViewController.viewControllerWithStoryboard() {
            loginViewController.modalPresentationStyle = .fullScreen
            
            MessageTableViewController.shared = self
            present(loginViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func handleNewMessage() {
        if let newMessageTableViewController = NewMessageTableViewController.viewControllerWithStoryboard() {
            let newController = UINavigationController(rootViewController: newMessageTableViewController)
            newController.modalPresentationStyle = .fullScreen
            MessageTableViewController.shared = self
            present(newController,animated: true,completion: nil)
        }
    }
    
    
    @objc func showChatController(user: User) {
        if let chatLoginController = ChatLoginController.viewControllerWithStoryboard() {
            navigationController?.pushViewController(chatLoginController, animated: true)
            chatLoginController.user = user
        }
    }
}


//MARK: - Extension

extension MessageTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: MessageTableViewControllerCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageTableViewControllerCell
        
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartherId = message.chatPartherId() else {return}
        
        let ref = Database.database().reference().child("users").child(chatPartherId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            let user = User(dictionary: dictionary)
            user.id = chatPartherId
            self.showChatController(user: user)
        }, withCancel: nil)
        
    }
    
    
}
