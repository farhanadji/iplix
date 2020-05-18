//
//  ProfileTableViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 22/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Firebase

protocol DelegateImagePicker {
    func showPicker(imagePicker: UIImagePickerController)
    func doneEditingAvatar(image: UIImage)
}

class ProfileTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var changeAvatarBtn: UIButton!
    let pickerController = UIImagePickerController()
    var delegate: DelegateImagePicker?
    var imagePicture: UIImage? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = ["public.image"]
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imagePicture = userPickedImage
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePicture = imageOriginal
        }
        
        guard let imageSelected = self.imagePicture else {
            print("Avatar is nil")
            return
        }
        
        delegate?.doneEditingAvatar(image: imageSelected)
        
        pickerController.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func changeBtnPressed(_ sender: UIButton) {
        delegate?.showPicker(imagePicker: self.pickerController)
    }
//    @IBAction func buttonPressed(_ sender: UIButton) {
//        if sender == changeAvatarBtn {
//            print("clicked change")
//            delegate?.showPicker(imagePicker: self.pickerController)
//        }
//    }
}
