//
//  ViewController.swift
//  ios-money-management
//
//  Created by nguyenthanhnhan on 02/02/1403 AP.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

    @IBOutlet weak var txt_username: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Debug
        print("Vào LoginViewController")
        
//        set title cho navigation
        self.navigationItem.title = "Login"
    }
    
    @IBAction func btn_password_tapped(_ sender: UIButton) {
        if sender.isSelected{
            sender.setImage(UIImage(named: "eye-solid"), for: .normal)
        }
        else{
            sender.setImage(UIImage(named: "eye-slash-solid"), for: .normal)
        }
        
//        Đảo ngược tính chất của ảnh button và textfield
        sender.isSelected = !sender.isSelected
        txt_password.isSecureTextEntry = !txt_password.isSecureTextEntry
    }
//    Hàm đăng nhập
    @IBAction func btn_login(_ sender: UIButton) {
        
      
        
        //        kiểm tra xem giá trị văn bản từ txt_email.text có nil hay không. Nếu nil, câu lệnh sẽ thực thi khối mã else.
        //        guard let name = txt_name.text else {return}
                guard let email = txt_username.text else {return}
                guard let password = txt_password.text else {return}

                
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        // Xử lý lỗi đăng nhập
                        print("Registration error: \(error.localizedDescription)")
                    } else if let authResult = authResult {
                       // Đăng nhập thành công, lấy ID của người dùng
                        let userId = authResult.user.uid
                        print("User login with ID: \(userId)")
                        
                    }
                }
        
        
    }
    

}

