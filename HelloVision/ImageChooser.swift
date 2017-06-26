//
//  ImageChooser.swift
//  HelloVision
//
//  Created by otti on 2017/06/25.
//  Copyright © 2017 Peng Guo. All rights reserved.
//

import UIKit

protocol ImageChooserDelegate {
    func imageChooser(picked: UIImage)
}

class ImageChooser: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var vc: UIViewController?
    var delegate: ImageChooserDelegate?
    
    func choose(viewController vc: UIViewController) {
        let dialog = UIAlertController(title: "", message: "Choose image", preferredStyle: .actionSheet)
        dialog.addAction(UIAlertAction(title: "Choose from photo library", style: .default, handler: self.chooseFromPhotoLibrary))
        dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.vc = vc
        vc.present(dialog, animated: true)
    }
    
    private func chooseFromPhotoLibrary(action: UIAlertAction){
        print("choose from photo library")
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.vc?.present(imagePicker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate?.imageChooser(picked: uiImage)
        }
        
        vc?.dismiss(animated: true)
    }
}
