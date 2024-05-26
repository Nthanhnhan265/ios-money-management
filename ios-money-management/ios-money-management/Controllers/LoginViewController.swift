//
// ViewController.swift
// ios-money-management
//
// Created by nguyenthanhnhan on 02/02/1403 AP.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    //    MARK: @IBOutlet
    @IBOutlet weak var txt_username: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    
    
    
    
    
    //    MARK: Load lần đầu
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Debug
        print("Vào LoginViewController")
        
        // set title cho navigation
        self.navigationItem.title = "Login"
        
        // Set up trước tài khoản và mật khẩu
        txt_password.text = "admin@gmail.com"
        txt_username.text = "admin@gmail.com"
//                txt_username.text = "ng.t.ann2003@gmail.com"
//                txt_password.text = "112233"

        
    }
    //    MARK: IBAction
    /// TA: Show password
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
    /// TA: Hàm đăng nhập
    @IBAction func btn_login(_ sender: UIButton) {
        // kiểm tra xem giá trị văn bản có nil hay không. Nếu nil, câu lệnh sẽ thực thi khối mã else.
        guard let email = txt_username.text else {return}
        guard let password = txt_password.text else {return}
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Eror: \(error)")
                // Hiện ra cảnh báo cho người dùng
                let alertController = UIAlertController(title: "Error", message: "Login error.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return // Thoát khỏi hàm nếu không hợp lệ
            } else if let authResult = authResult {
                // Đăng nhập thành công, lấy ID của người dùng
                let userId = authResult.user.uid
                print("User login with ID: \(userId)")
                UserDefaults.standard.set(userId, forKey: "UID")
                
                Task{
                    //                    Gọi hàm lấy userProfile từ UID
                    if let userProfile = await UserProfile.getUserProfine(UID: userId){
                        //                Lấy màn hình main storyboard
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        //                Lấy controller TabHomeController
                        let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarHomeController") as! TabHomeViewController
                        
                        //                Cho màn hình full màn hình
                        vc.modalPresentationStyle = .fullScreen
                        //                        Gán giá trị controller là userProfile
                        vc.userProfile = userProfile
                        self.present(vc, animated: true )
                        //                        Xoá mật khẩu
                        self.txt_password.text = nil
                    }
                }
            }
        }
    }
}
