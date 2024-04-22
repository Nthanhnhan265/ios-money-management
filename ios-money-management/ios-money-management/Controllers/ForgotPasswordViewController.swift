//
//  ForgotPasswordViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 22/04/2024.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var btn_Continue: UIButton!
    @IBOutlet weak var btn_SentOTP: UIButton!
    @IBOutlet weak var txt_otp: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("Vào ForgotPasswordViewController")
        
        self.navigationItem.title = "Forgot Password"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_SentOTP_tapped(_ sender: UIButton) {
        
        
        guard let email = txt_email.text else{return}
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                print("SEND OTP")
            }
            else
            {
                guard let error = error else{return}

                print(error)
            }
        }
        
        
    }
    
}
