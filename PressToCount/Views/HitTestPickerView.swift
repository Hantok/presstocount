//
//  HitTestPickerView.swift
//  PressToCount
//
//  Created by Roman on 7/11/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit

protocol HitTestDelegate: class {
    func hitTestCalledForView(_ view: UIView)
}

class HitTestPickerView: UIPickerView {
    
    var hitTestDelegate: HitTestDelegate!
    
    override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder : Bool {
        return super.canBecomeFirstResponder
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        hitTestDelegate.hitTestCalledForView(self)
        return super.hitTest(point, with: event)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
