//
//  EmojiKeyboardView.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-03-02.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit
import ISEmojiView

class EmojiKeyboardView: UIView, ISEmojiViewDelegate {
    
    @IBOutlet weak var emojiKeyboardField: UITextField! {
        didSet {
            let emojiKeyboard = ISEmojiView(frame: CGRectMake(0,0, frame.size.width,216))
            emojiKeyboard.delegate = self
            emojiKeyboardField.inputView = emojiKeyboard
            
        }
    }
    
    func emojiView(emojiView: ISEmojiView!, didPressDeleteButton deletebutton: UIButton!) {
//        if (self.textView.text.length > 0) {
//            NSRange lastRange = [self.textView.text rangeOfComposedCharacterSequenceAtIndex:self.textView.text.length-1];
//            self.textView.text = [self.textView.text substringToIndex:lastRange.location];
//        }

        }
    
    func emojiView(emojiView: ISEmojiView!, didSelectEmoji emoji: String!) {
        //self.textView.text = [self.textView.text stringByAppendingString:emoji];
    }
    
    
}
