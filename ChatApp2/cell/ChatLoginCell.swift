//
//  ChatLoginCell.swift
//  ChatApp2
//
//  Created by David Saley on 5/21/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class ChatLoginCell: UICollectionViewCell {
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.textColor = .white
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    var bubbleWidthAncorn: NSLayoutConstraint?
    var bubbleViewRightAncorn: NSLayoutConstraint?
    var bubbleViewLeftAncorn: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bubbleViewConstraints()
        textViewConstraints()
        profileImageViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Constraints
    
    private func bubbleViewConstraints() {
        addSubview(bubbleView)
        
        bubbleViewRightAncorn = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        bubbleViewRightAncorn?.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAncorn = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAncorn?.isActive = true
        
        bubbleViewLeftAncorn = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant: 8)
        
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    
    private func textViewConstraints() {
        addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    private func profileImageViewConstraints() {
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
}
