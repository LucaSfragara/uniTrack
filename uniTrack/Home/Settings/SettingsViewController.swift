//
//  SettingsViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 22/01/21.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    private func sendEmail(){
        if MFMailComposeViewController.canSendMail(){
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["lucasfragara@gmail.com"])
            mail.setSubject("Hey Luca, regarding UniTrack...")
            present(mail, animated: true)
        }
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
//MARK: MAIL COMPOSER DELEGATE
extension SettingsViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK: TABLE VIEW DELEGATE AND DATASOURCE
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") else{fatalError("Could not deque settings cell")}
            
            cell.textLabel?.text = "Delete all data"
            cell.textLabel?.textColor = .red
            cell.textLabel?.font = UIFont(name: "Inter-medium", size: 18)
            
            return cell
        
        case 1:
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") else{fatalError("Could not deque settings cell")}
            
            cell.textLabel?.text = "Get in touch with the developer"
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont(name: "Inter-medium", size: 18)
            
            return cell
        
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{ // Delete all data
            let alertView = Utilities.createAlertView(title: "Delete all universities", message: "Are you sure you want to permanently delete all the data?"){
                DataManager.shared.deleteAllUniversities(completion: {result in
                    
                })
            }
            self.present(alertView, animated: true, completion: nil)
        }else if indexPath.section == 1 && indexPath.row == 0{ //Get in touch with developer
            sendEmail()
        }
    }
    
    
}
