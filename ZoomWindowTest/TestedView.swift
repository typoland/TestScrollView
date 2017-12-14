//
//  TestedView.swift
//  ZoomWindowTest
//
//  Created by Łukasz Dziedzic on 13/12/2017.
//  Copyright © 2017 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit


class TestedView: NSView {
    
    var counter = 0
    var currentBounds:NSRect = NSMakeRect(0, 0, 0, 0)
    var firstClick:NSPoint = NSMakePoint(0, 0)
    var currentClick:NSPoint = NSMakePoint(0, 0)
    
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(TestedView.boundsWasChanged(_:)), name: NSView.boundsDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TestedView.somethingWasChanged(_:)), name: NSScrollView.didEndLiveScrollNotification, object: nil)
    }
    
    @objc func somethingWasChanged(_ notification:Notification) {
        Swift.print("end", (notification.object as! NSScrollView).documentVisibleRect)
        needsToDraw((notification.object as! NSScrollView).documentVisibleRect)
        needsDisplay = true
    }
    
    @objc func boundsWasChanged(_ notification:Notification) {
        if let newBounds =  (notification.object as? NSView)?.bounds {
            counter = 0
            currentBounds = newBounds
            needsToDraw(newBounds)
            
        }
    }
    override func mouseDown(with event: NSEvent) {
        
        firstClick = self.convert(event.locationInWindow, from: nil)
        Swift.print(firstClick)
    }
    override func mouseUp(with event: NSEvent) {
        currentClick = self.convert(event.locationInWindow, from: nil)
        
        let changeRect  = NSMakeRect(
            min(firstClick.x, currentClick.x),
            min(firstClick.y, currentClick.y),
            abs(currentClick.x-firstClick.x),
            abs(currentClick.y-firstClick.y))
        
        needsToDraw(changeRect)
        Swift.print(currentClick, changeRect)
        needsDisplay = true
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        let drawStartTime = Date()
        
        var rects: UnsafePointer<CGRect>? = nil
        var i:Int = 0
        getRectsBeingDrawn(&rects, count: &i)
        
        
        for rect in Array(UnsafeBufferPointer(start: rects, count:i)) {
            
            
            if currentBounds.intersects(rect) {
                Swift.print("in rect...")
                
                //Swift.print("counter:\t\(counter)\t\t\(dirtyRect) \(currentBounds.intersects(dirtyRect))")
                //NSColor.darkGray.set()
                NSColor(calibratedWhite: CGFloat(Double(arc4random_uniform(100))/500.0+0.2), alpha: 1).setFill()
                NSBezierPath(rect: dirtyRect).fill()
                let al:CGFloat  = 250
                var drawed = 0
                var missed = 0
                for x in 0 ... Int(self.bounds.width/al) {
                    for y in 0 ... Int(self.bounds.height/al) {
                        let bezier = NSBezierPath()
                        
                        bezier.move(to: NSMakePoint(CGFloat(y)*al, CGFloat(x)*al))
                        bezier.line(to: NSMakePoint(CGFloat(x)*al, CGFloat(y)*al))
                        if bezier.bounds.intersects(rect) {
                            let hue:CGFloat = CGFloat((x*16)  % 256) / 256
                            let saturation:CGFloat = CGFloat((y*10) % 128) / 128 + 128
                            NSColor(calibratedHue: hue, saturation: saturation, brightness: 1, alpha: 0.05).set()
                            bezier.lineWidth = 90
                            bezier.stroke()
                            drawed = drawed + 1
                        } else {
                            missed = missed + 1
                        }
                    }
                }
                let duration = NSDateInterval(start: drawStartTime, end: Date()).duration
                Swift.print(String(format : "\tcounter = %i,\ti = %i, \tduration %0.5f\tdrawed:%i\tmissed: %i\t TOTAL: %i", counter, i, duration, drawed, missed, drawed + missed))
            } 
            counter = counter+1
        }
        
    }
    
}
