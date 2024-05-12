
import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
//MARK: Properties
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var cornerTable: UIView!
    @IBOutlet weak var image: UIImageView!
    var settings:[[String:Any]] = [
        ["setting_name": "Account", "setting_icon": "iconWallet"],
        ["setting_name": "Setting", "setting_icon": "iconSetting"],
        ["setting_name": "Export Data", "setting_icon": "iconExport"],
        ["setting_name": "Logout", "setting_icon": "iconLogout"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //cau hinh cho avatar
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = true
        //rgba(173, 0, 255, 1)
        imageView.layer.borderColor = CGColor(red: 173/255, green: 0/255, blue: 255/255, alpha: 1)
        imageView.layer.cornerRadius = imageView.frame.height/2

        image.layer.cornerRadius = image.frame.height/2
        settingTableView.dataSource = self
        settingTableView.delegate = self
        
        cornerTable.layer.cornerRadius = 16
        cornerTable.layer.masksToBounds = true
    } 
    
    //MARK: implementing classes
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("selected: \(indexPath.row)")
        
//        Chuyển màn hình khi nhấn account wallet
        if indexPath.row == 0{
            //Lấy main.storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //        Lấy màn hình cần chuyển qua
            let view_controller = storyboard.instantiateViewController(withIdentifier: "AccountWallets")
            //        set title cho navigation
            view_controller.navigationItem.title = "Account"
            //        Đẩy màn hình vào hàng đợi... (chuyển màn hình)
            navigationController?.pushViewController(view_controller, animated: true)
            //        self.present(view_controller, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuse = "SettingCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuse, for: indexPath) as? SettingCell {
            if let imgStr = settings[indexPath.row]["setting_icon"], let nameStr = settings[indexPath.row]["setting_name"] {
                cell.selectionStyle = .none
                cell.settingImage.image = UIImage(named: imgStr as! String)
                cell.settingName.text = nameStr as? String
                return cell
            }
        }
        fatalError("Khong the return")
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
