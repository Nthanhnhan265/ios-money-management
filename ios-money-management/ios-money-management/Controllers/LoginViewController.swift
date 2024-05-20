//
// ViewController.swift
// ios-money-management
//
// Created by nguyenthanhnhan on 02/02/1403 AP.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    
    @IBOutlet weak var txt_username: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Debug
        print("Vào LoginViewController")
        
        // set title cho navigation
        self.navigationItem.title = "Login"
        
        // Set up trước tài khoản và mật khẩu
        //        txt_username.text = "ngthanhnhan265.xb@gmail.com"
        //        txt_password.text = "nhannhan"
//        txt_password.text = "admin@gmail.com"
//        txt_username.text = "admin@gmail.com"
        txt_password.text = "nta@gmail.com"
        txt_username.text = "nta@gmail.com"
    }
    
    @IBAction func btn_password_tapped(_ sender: UIButton) {
        if sender.isSelected{
            sender.setImage(UIImage(named: "eye-solid"), for: .normal)
        }
        else{
            sender.setImage(UIImage(named: "eye-slash-solid"), for: .normal)
        }
        
        // Đảo ngược tính chất của ảnh button và textfield
        sender.isSelected = !sender.isSelected
        txt_password.isSecureTextEntry = !txt_password.isSecureTextEntry
    }
    // Hàm đăng nhập
    @IBAction func btn_login(_ sender: UIButton) {
        // kiểm tra xem giá trị văn bản từ txt_email.text có nil hay không. Nếu nil, câu lệnh sẽ thực thi khối mã else.
        // guard let name = txt_name.text else {return}
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
                UserDefaults.standard.set(userId, forKey: "UID")
                
                Task{
                    if let userProfile = await UserProfile.getUserProfine(UID: userId){
                        //                Lấy màn hình main storyboard
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        //                Lấy controller TabHomeController
                        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarHomeController") as! TabHomeViewController
                        
                        //                Cho màn hình Home full màn hình
                        homeViewController.modalPresentationStyle = .fullScreen
                        homeViewController.userProfile = userProfile
                        //
                        self.present(homeViewController, animated: true )
                        
                        //                self.navigationController?.navigationBar.isHidden = true
                        //                 self.navigationController?.pushViewController(homeViewController, animated: true)
                    }
                    
                    
                    
                    
                    //                //                Lấy màn hình main storyboard
                    //                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    //                //                Lấy controller TabHomeController
                    //                let homeViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarHomeController") as! TabHomeViewController
                    //
                    //                //                Cho màn hình Home full màn hình
                    //                homeViewController.modalPresentationStyle = .fullScreen
                    //
                    //                //
                    //                self.present(homeViewController, animated: true )
                    //
                    //                //                self.navigationController?.navigationBar.isHidden = true
                    //                //                 self.navigationController?.pushViewController(homeViewController, animated: true)
                    
                    
                    
                    
                    
                    
                }
            }
        }
        
        
    }
    
    
}

