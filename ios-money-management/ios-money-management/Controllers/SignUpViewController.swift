//
//  SignUpViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 21/04/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class SignUpViewController: UIViewController {
    //input
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    //    button
    @IBOutlet weak var btn_SignUp: UIButton!
    @IBOutlet weak var btn_google: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        Debug
        print("Vào SignUpViewController")
        
        //        Set title cho navigation
        self.navigationItem.title = "Sign Up"
        
        //        Name
        txt_name.layer.borderColor = UIColor.black.cgColor
        txt_name.layer.borderWidth = 0.5
        txt_name.layer.cornerRadius = 10.0
        
        //        Email
        txt_email.layer.borderColor = UIColor.black.cgColor
        txt_email.layer.borderWidth = 0.5
        txt_email.layer.cornerRadius = 10.0
        //        Password
        txt_password.layer.borderColor = UIColor.black.cgColor
        txt_password.layer.borderWidth = 0.5
        txt_password.layer.cornerRadius = 10.0
        
        //        Button đăng ký bằng Google
        btn_google.layer.borderColor = UIColor.black.cgColor
        btn_google.layer.borderWidth = 0.5
        btn_google.layer.cornerRadius = 5.0
        
        
        
        
        
        
        
        
        
        
        
    }
    
    @IBAction func btn_check_tapped(_ sender: UIButton) {
        //        Mac dinh hinh anh
        
        if sender.isSelected{
            sender.setImage(UIImage(named: "checkbox_false"), for: .normal)
        }
        else{
            sender.setImage(UIImage(named: "checkbox_true"), for: .normal)
        }
        sender.isSelected = !sender.isSelected
        
    }
    
    @IBAction func btn_ShowPassword_tapped(_ sender: UIButton) {
        if sender.isSelected{
            sender.setImage(UIImage(named: "eye-slash-solid"), for: .normal)
            
        }
        else{
            sender.setImage(UIImage(named: "eye-solid"), for: .normal)
        }
        sender.isSelected = !sender.isSelected
        txt_password.isSecureTextEntry = !txt_password.isSecureTextEntry
    }
    
    
    @IBAction func btn_SignUp_Click(_ sender: UIButton) {
        //        kiểm tra xem giá trị văn bản từ txt_email.text có nil hay không. Nếu nil, câu lệnh sẽ thực thi khối mã else.
        //        guard let name = txt_name.text else {return}
        guard let email = txt_email.text else {return}
        guard let password = txt_password.text else {return}
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { [self] (authResult, error) in
            if let error = error {
                // Xử lý lỗi đăng ký
                print("Registration error: \(error.localizedDescription)")
            } else if let authResult = authResult {
                // Đăng ký thành công, lấy ID của người dùng
                let userId = authResult.user.uid
                
                //                Tạo 1 đối tượng userProfile
                if let fullname = txt_name.text{
                    let userProfile = UserProfile(UID: userId, fullname: fullname)
                    Task {
                        do {
//                            Tạo userProfile mới
                             try await UserProfile.createUserProfile(userProfile: userProfile)
                            
//                            Tạo ví mới mặc định cho người dùng
                            try await Wallet.createNewWallet(UID: userId, balance: 0, image: "cash", name: "Tiền mặt")
                        } catch {
                            print("Tạo userProfile thất bại")
                        }
                    }
                    
                    
                    print("User created with ID: \(userId)")
                    
                }
            }
            
        }
        navigationController?.popViewController(animated: true)
        
    }
}
