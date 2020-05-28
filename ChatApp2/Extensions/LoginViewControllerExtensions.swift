
import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

//MARK: - Extensions UIImagePickerControllerDelegate and UINavigationControllerDelegate

extension LoginViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func handleSelectProfileImageView() {
        let alertController = UIAlertController(title: "What to open", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] (_) in
             guard let self = self else { return }
            
            self.pickerController.allowsEditing = true
            self.pickerController.sourceType = .savedPhotosAlbum
            
            self.present(self.pickerController, animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImageView.image = image
        } else if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
        pickerController.dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
