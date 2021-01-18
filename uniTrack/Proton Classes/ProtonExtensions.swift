//
//  ProtonExtensions.swift
//  uniTrack
//
//  Created by Luca Sfragara on 16/01/21.
//

import Foundation
import UIKit
import Proton

class EditorCommandButton: UIButton {
    let command: EditorCommand

    let highlightOnTouch: Bool

    init(command: EditorCommand, highlightOnTouch: Bool) {
        self.command = command
        self.highlightOnTouch = highlightOnTouch
        super.init(frame: .zero)
        titleLabel?.font = UIButton(type: .system).titleLabel?.font
        isSelected = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            setTitleColor(isSelected ? .white : UIColor(named: "uniTrack Blue"), for: .normal)
            
            backgroundColor = isSelected ? UIColor(named: "uniTrack Blue") : .systemBackground
        }
    }
}

class BoldCommand: FontTraitToggleCommand {
    public init() {
        super.init(name: CommandName("_BoldCommand"), trait: .traitBold)
    }
}

class FontTraitToggleCommand: EditorCommand {
    public let trait: UIFontDescriptor.SymbolicTraits

    public let name: CommandName

    public init(name: CommandName, trait: UIFontDescriptor.SymbolicTraits) {
        self.name = name
        self.trait = trait
    }

    public func execute(on editor: EditorView) {
        let selectedText = editor.selectedText
        if editor.isEmpty || editor.selectedRange == .zero {
            guard let font = editor.typingAttributes[.font] as? UIFont else { return }
            editor.typingAttributes[.font] = font.toggled(trait: trait)
            return
        }

        if selectedText.length == 0 {
            guard let font = editor.attributedText.attribute(.font, at: editor.selectedRange.location - 1, effectiveRange: nil) as? UIFont else { return }
            editor.typingAttributes[.font] = font.toggled(trait: trait)
            return
        }

        guard let initFont = selectedText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else {
            return
        }

        editor.attributedText.enumerateAttribute(.font, in: editor.selectedRange, options: .longestEffectiveRangeNotRequired) { font, range, _ in
            if let font = font as? UIFont {
                let fontToApply = initFont.contains(trait: trait) ? font.removing(trait: trait) : font.adding(trait: trait)
                editor.addAttribute(.font, value: fontToApply, at: range)
            }
        }
    }
}


class ListFormattingProvider: EditorListFormattingProvider {
    let listLineFormatting: LineFormatting = LineFormatting(indentation: 25, spacingBefore: 0)
    let sequenceGenerators: [SequenceGenerator] =
        [NumericSequenceGenerator(),
         DiamondBulletSequenceGenerator(),
         SquareBulletSequenceGenerator()]

    func listLineMarkerFor(editor: EditorView, index: Int, level: Int, previousLevel: Int, attributeValue: Any?) -> ListLineMarker {
        let sequenceGenerator = self.sequenceGenerators[(level - 1) % self.sequenceGenerators.count]
        return sequenceGenerator.value(at: index)
    }
}
