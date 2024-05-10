//
//  EditProfileViewController.swift
//  ios-money-management
//
//  Created by nguyenthanhnhan on 21/02/1403 AP.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageView: UIView!
    

    override func viewDidLoad(){
        super.viewDidLoad()

        //cau hinh cho avatar
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = true
        //rgba(173, 0, 255, 1)
        imageView.layer.borderColor = CGColor(red: 173/255, green: 0/255, blue: 255/255, alpha: 1)
        imageView.layer.cornerRadius = imageView.frame.height/2
        image.layer.cornerRadius = image.frame.height/2
    }
    //nhan de mo uiimagepicker
    @IBAction func imageTapped(_ sender: Any) {
        var imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
                    image.image = pickedImage // Hiển thị hình ảnh đã chọn trên imageView
                }
                
                dismiss(animated: true, completion: nil)
    }
}
