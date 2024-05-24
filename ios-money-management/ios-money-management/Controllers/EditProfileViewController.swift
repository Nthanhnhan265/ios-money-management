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
    
    @IBOutlet weak var txt_name: UITextField!
    var userProfile:UserProfile?

    override func viewDidLoad(){
        super.viewDidLoad()
        print("Vào EditProfileViewController")

        
        
        setFrontEnd()
    }
    func setFrontEnd()  {
        //cau hinh cho avatar
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = true
        //rgba(173, 0, 255, 1)
        imageView.layer.borderColor = CGColor(red: 173/255, green: 0/255, blue: 255/255, alpha: 1)
        imageView.layer.cornerRadius = imageView.frame.height/2
        image.layer.cornerRadius = image.frame.height/2
        if let userProfile = self.userProfile{
            if let avatar = userProfile.Avatar{
                image.image = avatar
            }
            txt_name.text = userProfile.Fullname

        }
        
    }
    
    @IBAction func btn_save_tapped(_ sender: UIBarButtonItem) {
        if let newName = txt_name.text, let newImage = image.image {
                Task {
                    do {
                        let avatarURL = try await Transaction.uploadImagesToStorage(images: [newImage])
                        if !avatarURL.isEmpty {
// Hàm cập nhật lại Fullname, avatarURL lên trên Firestore
                            UserProfile.updateUserProfile(UID: userProfile?.getUID ?? "", fullname: newName, avatarURL: avatarURL[0])
                            
//                            Cập nhật lại thông tin ở Local
                            //        Lấy userProfile đang nằm trong Tabbar controller
                            if let tabBarController = self.tabBarController as? TabHomeViewController {
                                tabBarController.userProfile?.Fullname = newName
                                tabBarController.userProfile?.Avatar = newImage
                                
                            }
                            navigationController?.popViewController(animated: true)
                        } else {
                            // Xử lý trường hợp không có URL ảnh
                        }
                    } catch {
                        // Xử lý lỗi nếu có
                        print("Error updating profile: \(error)")
                        let alertController = UIAlertController(title: "Error", message: "\(error).", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        else {
                // Xử lý trường hợp tên không hợp lệ hoặc không có ảnh mới
                print("Error: Invalid name or no new image")
            let alertController = UIAlertController(title: "Error", message: "Invalid name or no new image.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
            }
        
    }
    
    //nhan de mo uiimagepicker
    @IBAction func imageTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
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
