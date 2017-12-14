//
//  TestedScrollView.swift
//  ZoomWindowTest
//
//  Created by Łukasz Dziedzic on 13/12/2017.
//  Copyright © 2017 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import  AppKit

class TestedScrollView: NSScrollView {
    @objc fileprivate var documentWidthConstraint:NSLayoutConstraint?
   @objc fileprivate var documentHeightConstraint:NSLayoutConstraint?
    
    
    override func awakeFromNib() {
        if let docView:NSView = self.documentView as NSView! {
            docView.frame.size.width = CGFloat(canvasWidth)
            docView.frame.size.height = CGFloat( canvasHeight)
            documentWidthConstraint = NSLayoutConstraint(item: docView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: CGFloat(canvasWidth))
            documentHeightConstraint = NSLayoutConstraint(item: docView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: CGFloat(canvasHeight))
            docView.addConstraints([documentWidthConstraint!, documentHeightConstraint!])
        }
        didChangeValue(for: \TestedScrollView.canvasWidth)
        didChangeValue(for: \TestedScrollView.canvasHeight)
    }
   
    @objc var canvasWidth = 10000 {
        didSet {
            if let docView = documentView, let widthConstraint = documentWidthConstraint {
                 docView.frame = NSMakeRect(0,0, CGFloat(canvasWidth), docView.frame.height)
                widthConstraint.constant = CGFloat(canvasWidth)
            }
        }
        
    }
    
    @objc var canvasHeight = 10000 {
        didSet {
            if let docView = documentView, let heightConstraint = documentHeightConstraint {
                docView.frame = NSMakeRect(0,0, docView.frame.width, CGFloat(canvasHeight))
                 heightConstraint.constant = CGFloat(canvasHeight)
            }

        }

    }

}
