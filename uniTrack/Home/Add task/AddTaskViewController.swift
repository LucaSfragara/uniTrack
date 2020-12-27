//
//  AddTaskViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 14/12/20.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var textTextField: UITextField!
    @IBOutlet weak private var addButton: DesignableButton!
    

    weak var delegate: AddTaskButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIControl.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIControl.keyboardWillHideNotification, object: nil)
        
        addButton.disableButton()
        titleTextField.becomeFirstResponder()
        titleTextField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        // Do any additional setup after loading the view.
    }

    @objc private func handleKeyboardWillShow(notification: NSNotification){
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        self.view.frame.origin.y -= keyboardSize.height
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    
    @objc private func handleTextChanged(){
        if let text = titleTextField.text, text.isEmpty == false{
            addButton.enableButton()
        }else{
            addButton.disableButton()
        }
    }
    @IBAction func didTapAddTask(_ sender: Any) {
        guard let title = titleTextField.text, let text = textTextField.text else{return}
        delegate?.didPressAddTask(title: title, text: text)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

protocol AddTaskButtonDelegate: class{
    func didPressAddTask(title: String, text: String?)
}
