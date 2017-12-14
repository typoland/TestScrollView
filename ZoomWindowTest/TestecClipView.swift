//
//  TestecClipView.swift
//  ZoomWindowTest
//
//  Created by Łukasz Dziedzic on 14/12/2017.
//  Copyright © 2017 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit

class TestedClipView: NSClipView {
    override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
        //Swift.print ("ConstrainBoundsRect")
        var constrainedClipViewBounds = super.constrainBoundsRect(proposedBounds)
        
        guard let documentView = documentView as NSView! else {
            return constrainedClipViewBounds
        }
        
        let documentViewFrame = documentView.frame
        
        if documentViewFrame.width < proposedBounds.width {
            constrainedClipViewBounds.origin.x = floor((proposedBounds.width - documentViewFrame.width) / -2.0)
        }
        
        if documentViewFrame.height < proposedBounds.height {
            constrainedClipViewBounds.origin.y = floor((proposedBounds.height - documentViewFrame.height) / -2.0)
        }
        
        return constrainedClipViewBounds
    }
}
