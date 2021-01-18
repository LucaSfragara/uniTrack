//
//  NotesViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 12/01/21.
//

import UIKit
import Proton

class NotesViewController: ProtonBaseViewController {

    var university: University?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let university = university else{return}
        
        guard let notes = university.notes else{//Deal with this notes being nil
            super.state = .editing //Shows editor
            super.editor.attributedText = NSAttributedString(string: "")
            return
        }
        
        if notes.string.isEmpty{ //deal with notes being emptykkk
            super.state = .editing //Shows editor
            super.editor.attributedText = NSAttributedString(string: "")
        }else{
            super.state = .notEditing //Shows renderer
            super.renderer.attributedText = university.notes!
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didTapMainButton() {
        super.didTapMainButton()
        
        if super.state == .editing{
            
            updateNotes(attributedText: super.editor.attributedText)
            self.university?.notes = super.editor.attributedText
            self.renderer.attributedText = self.university?.notes ?? NSAttributedString(string: "") //update text on renderer
            super.state = .notEditing
            
        }else{
            
            self.editor.attributedText = self.university?.notes ?? NSAttributedString(string: "") //update text on editor
            super.state = .editing
            
        }
        
        
    }
    
    private func updateNotes(attributedText: NSAttributedString){
        guard let university = university else{
            return
        }
        DataManager.shared.updateUniversity(universityToUpdate: university, updateValues: ["notes": attributedText]){ result in
            switch result{
            case .success(let university):
                super.state = .notEditing
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
}

