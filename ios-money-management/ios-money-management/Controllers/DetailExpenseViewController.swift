



//  DetailExpenseViewController.swift
//  ios-money-management
//
//  Created by nguyenthanhnhan on 16/02/1403 AP.
//

import UIKit

class DetailExpenseViewController: UIViewController {

    //MARK: properties
    var transaction:Transaction? = nil
    
    @IBOutlet weak var borderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setFrontEnd()
        
        
    }
    func setFrontEnd(){
        //set background for navigation controller
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 253/255, green: 74/255, blue: 92/255, alpha: 1);
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //custom border of UIVIew
        borderView.layer.borderColor = CGColor(red: 241/250, green: 241/250, blue: 250/250, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func deleteTransaction(_ sender: UIBarButtonItem) {
        self.showConfirmDialog();
    }
    
    // Function to display the confirm dialog
    func showConfirmDialog() {
        let alertController = UIAlertController(title: "Delete transaction", message: "Are you sure you want to delete this transaction?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            // Perform deletion action here
            print("transaction deleted")
        }
        alertController.addAction(deleteAction)
        
        // Configure presentation style as custom
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
