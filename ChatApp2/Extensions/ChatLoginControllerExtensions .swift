
import UIKit
import FirebaseAuth

extension  ChatLoginController: UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = messages[indexPath.row].text {
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        return NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndetifire, for: indexPath) as! ChatLoginCell
        
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        cell.bubbleWidthAncorn?.constant = estimateFrameForText(text: message.text!).width + 32
        
        return cell
    }
    
    
    //MARK: - Setup Cell
    
    private func setupCell(cell: ChatLoginCell, message: Message) {
        if let profileImageUrl = user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = .systemBlue
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAncorn?.isActive = true
            cell.bubbleViewLeftAncorn?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = .systemGray5
            cell.textView.textColor = .black
            
            cell.bubbleViewRightAncorn?.isActive = false
            cell.bubbleViewLeftAncorn?.isActive = true
            cell.profileImageView.isHidden = false
        }
    }
}
