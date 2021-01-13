//
//  NotesViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 12/01/21.
//

import UIKit
import Proton

class NotesViewController: UIViewController {

    let editorView = EditorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditorView()
        self.title = "Notes"
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.largeTitleDisplayMode = .automatic
        editorView.setFocus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupEditorView(){
        
        editorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editorView)
        editorView.layer.borderColor = UIColor.systemBlue.cgColor
        editorView.layer.borderWidth = 1.0
        editorView.registerProcessor(ListTextProcessor())
        NSLayoutConstraint.activate([
            editorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            editorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            editorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            editorView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            editorView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])

        editorView.placeholderText = NSAttributedString(
            string: "This is a placeholder text that flows into the next line",
            attributes: [
                .font: editorView.font,
                .foregroundColor: UIColor.tertiaryLabel,
        ])
        
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
