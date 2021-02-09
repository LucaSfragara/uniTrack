//
//  ProtonBaseViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 16/01/21.
//

import UIKit
import Foundation
import Proton

class ProtonBaseViewController: UIViewController {

    let editor = EditorView()
    let renderer = RendererView()
    var editorScrollView: UIScrollView!
    
    let commands: [(title: String, command: EditorCommand, highlightOnTouch: Bool)] = [
        //(title: "Panel", command: PanelCommand(), highlightOnTouch: false),
        (title: "List", command: ListCommand(), highlightOnTouch: false),
        (title: "Bold", command: BoldCommand(), highlightOnTouch: true),
        //(title: "TextBlock", command: TextBlockCommand(), highlightOnTouch: false),
    ]
    
    let listFormattingProvider = ListFormattingProvider()
    let commandExecutor = EditorCommandExecutor()
    var buttons = [UIButton]()

    lazy var doneBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapMainButton))
    lazy var editBarButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(didTapMainButton))

    var state: VCState?{
        didSet{
            switch state{
            case .editing:
                showEditor()
            case .notEditing:
                showRenderer()
            case .none:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupEditor()
        setupRenderer()
        
        state = .editing
        
        self.title = "Notes"
        self.navigationItem.largeTitleDisplayMode = .always
        editor.setFocus()
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapMainButton(){
//        switch state{
//        case .editing:
//            state = .notEditing
//        case .notEditing:
//            state = .editing
//        default:
//            break
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func showEditor(){
        
        editor.isHidden = false
        editorScrollView.isHidden = false
        renderer.isHidden = true
        
        //editor.attributedText = attributedText
        self.navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func showRenderer(){
        
        editorScrollView.isHidden = true
        editor.isHidden = true
        renderer.isHidden = false
        
        self.navigationItem.rightBarButtonItem = editBarButton
        
        //renderer.attributedText = attributedText
    }
    
    private func setupRenderer(){
        
        renderer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(renderer)

        renderer.translatesAutoresizingMaskIntoConstraints = false
        
        renderer.layer.borderColor = UIColor(named: "uniTrack Light Orange")?.cgColor
        renderer.layer.cornerRadius = 5
        renderer.layer.shadowColor = UIColor(named: "uniTrack Light BG Orange")?.cgColor
        renderer.layer.shadowOpacity = 1
        renderer.layer.shadowOffset = CGSize(width: 0, height: 0)
        renderer.layer.borderWidth = 2.0
        renderer.font = UIFont(name: "Inter", size: 15)!
    
        NSLayoutConstraint.activate([
            
            renderer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            renderer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            renderer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            renderer.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            renderer.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
        ])

    }
    
    private func setupEditor(){
        
        //Stack view setup
        editorScrollView = UIScrollView()
        editorScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.buttons = makeCommandButtons()
        for button in buttons {
            stackView.addArrangedSubview(button)
        }
        
        //view.addSubview(editorScrollView)
        //editorScrollView.addSubview(stackView)
        
        //Editor setup
        editor.listFormattingProvider = listFormattingProvider
        editor.registerProcessor(ListTextProcessor())
        
        editor.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editor)
        editor.layer.borderColor = UIColor(named: "uniTrack Light Orange")?.cgColor
        editor.layer.cornerRadius = 5
        editor.layer.shadowColor = UIColor(named: "uniTrack Light BG Orange")?.cgColor
        editor.layer.shadowOpacity = 1
        editor.layer.shadowOffset = CGSize(width: 0, height: 0)
        editor.layer.borderWidth = 2.0
        editor.font = UIFont(name: "Inter", size: 15)!
        
        NSLayoutConstraint.activate([
            
//            editorScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            editorScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            editorScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//
//            editorScrollView.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: 10),
//
//            stackView.widthAnchor.constraint(greaterThanOrEqualTo: editorScrollView.widthAnchor),
//            stackView.topAnchor.constraint(equalTo: editorScrollView.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: editorScrollView.bottomAnchor),
//            stackView.leadingAnchor.constraint(equalTo: editorScrollView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: editorScrollView.trailingAnchor),

            editor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            editor.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            editor.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            editor.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            editor.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
            
        ])

        editor.placeholderText = NSAttributedString(
            string: "Add here college essays prompts, questions, interviews, etc...",
            attributes: [
                .font: editor.font,
                .foregroundColor: UIColor(named: "uniTrack secondary label color"),
        ])
        
    }
    
    
    private func makeCommandButtons() -> [UIButton] {
        
        var buttons = [UIButton]()
        for (title, command, highlightOnTouch) in commands {
            
            let button = EditorCommandButton(command: command, highlightOnTouch: highlightOnTouch)
            button.setTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(runCommand(sender:)), for: .touchUpInside)

            button.layer.borderColor = UIColor(named: "uniTrack Blue")?.cgColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 10.0
            button.titleLabel?.font = UIFont(name: "Inter-semibold", size: 17)
            NSLayoutConstraint.activate([button.widthAnchor.constraint(equalToConstant: 70)])
            buttons.append(button)
        }
        return buttons
    }
    
    @objc
    private func runCommand(sender: EditorCommandButton) {
        if sender.highlightOnTouch {
            sender.isSelected.toggle()
        }
        if sender.titleLabel?.text == "Encode" {
            sender.command.execute(on: editor)
            return
        } else if sender.titleLabel?.text == "List" {
            if let command = sender.command as? ListCommand,
               let editor = editor.editorViewContext.activeEditorView{
                var attributeValue: String? = "listItemValue"
                if editor.contentLength > 0,
                    editor.attributedText.attribute(.listItem, at: min(editor.contentLength - 1, editor.selectedRange.location), effectiveRange: nil) != nil {
                    attributeValue = nil
                }
                command.execute(on: editor, attributeValue: attributeValue)
                return
            }
        }
        commandExecutor.execute(sender.command)
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

extension ProtonBaseViewController: EditorViewDelegate {
    func editor(_ editor: EditorView, didChangeSelectionAt range: NSRange, attributes: [NSAttributedString.Key: Any], contentType: EditorContent.Name) {
        guard let font = attributes[.font] as? UIFont else { return }

        buttons.first(where: { $0.titleLabel?.text == "Bold" })?.isSelected = font.isBold
        buttons.first(where: { $0.titleLabel?.text == "Italics" })?.isSelected = font.isItalics
    }

    func editor(_ editor: EditorView, didReceiveFocusAt range: NSRange) {
        print("Focussed: `\(editor.contentName?.rawValue ?? "<root editor>")` at depth: \(editor.nestingLevel)")
    }

    func editor(_ editor: EditorView, didChangeSize currentSize: CGSize, previousSize: CGSize) {
        print("Height changed from \(previousSize.height) to \(currentSize.height)")
    }
}

//MARK: CUSTOM TYPES
extension ProtonBaseViewController{
    enum VCState{
        case editing
        case notEditing
    }
}
