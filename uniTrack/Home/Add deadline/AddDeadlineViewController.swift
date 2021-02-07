//
//  AddDeadlineViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 14/12/20.
//

import UIKit

class AddDeadlineViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: DesignableButton!
    @IBOutlet weak private var mainView: DesignableView!
    
    weak var delegate: addDeadlineButtonDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        titleTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        
        self.mainView.layer.cornerRadius = 15
        self.mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        super.viewDidLoad()
        datePicker.minimumDate = Date() //you can't pick a date that is earlier than the current one
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIControl.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIControl.keyboardWillHideNotification, object: nil)
        
        addButton.disableButton()
        titleTextField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        titleTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        
        guard let title = titleTextField.text, title.isEmpty == false else{
            return
        }
        delegate?.didPressAddDeadline(title: title, date: datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleTextChanged(){
        if let text = titleTextField.text, text.isEmpty == false{
            addButton.enableButton()
        }else{
            addButton.disableButton()
        }
    }
    
    @objc private func handleKeyboardWillShow(notification: NSNotification){
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
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

protocol addDeadlineButtonDelegate: class{
    
    func didPressAddDeadline(title: String, date: Date)
}

//MARK: TEXTFIELD DELEGATE
extension AddDeadlineViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
