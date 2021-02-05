//
//  SettingsViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 22/01/21.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    
    let githubUrl = URL(string: "https://github.com/LucaSfragara/uniTrack")! //uniTrack github page
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func didPressDeleteAllData(){
        let alertView = Utilities.createAlertView(title: "Delete all universities", message: "Are you sure you want to permanently delete all the data?"){
            DataManager.shared.deleteAllUniversities(completion: {result in
                
            })
        }
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction private func didPressSendMail(){
        sendEmail()
    }
    
    @IBAction private func didPressGithub(){
        UIApplication.shared.open(githubUrl, options: [:], completionHandler: nil)
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

