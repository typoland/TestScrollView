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
    var clickTime = Date()
    
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
        clickTime = Date()
        refresh()
    }
    
    override func mouseDragged(with event: NSEvent) {
        currentClick = self.convert(event.locationInWindow, from: nil)
        refresh()
    }
    
    override func mouseUp(with event: NSEvent) {
        currentClick = self.convert(event.locationInWindow, from: nil)
        refresh()
    }
    
    func refresh () {
        let changeRect  = NSMakeRect(
            min(firstClick.x, currentClick.x),
            min(firstClick.y, currentClick.y),
            abs(currentClick.x-firstClick.x),
            abs(currentClick.y-firstClick.y))
        
        needsToDraw(changeRect)
        let duration = NSDateInterval(start: clickTime, end: Date()).duration
        //Swift.print(String(format: "\t  ____ \tduration: %0.6f ", duration))
        clickTime = Date()
        //Swift.print(currentClick, changeRect)
        
        needsDisplay = true
    }
    override func draw(_ dirtyRect: NSRect) {
        //let drawStartTime = Date()
        
        var rects: UnsafePointer<CGRect>? = nil
        var i:Int = 0
        getRectsBeingDrawn(&rects, count: &i)
        
        //it looks getRectsBeingDrawn gives always only one rect and it's identical as dirtyRect
        
        for rect in Array(UnsafeBufferPointer(start: rects, count:i)) {
            
            //if currentBounds.intersects(rect) {
            if needsToDraw(rect) {
                NSColor(calibratedWhite: CGFloat(Double(arc4random_uniform(100))/500.0+0.2), alpha: 1).setFill()
                NSBezierPath(rect: dirtyRect).fill()
                let reductor:CGFloat  = 250
                var drawed = 0
                var missed = 0
                for x in 0 ... Int(self.bounds.width/reductor) {
                    for y in 0 ... Int(self.bounds.height/reductor) {
                        let bezier = NSBezierPath()
                        bezier.move(to: NSMakePoint(CGFloat(y)*reductor, CGFloat(x)*reductor))
                        bezier.line(to: NSMakePoint(CGFloat(x)*reductor, CGFloat(y)*reductor))
                        
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
               /*
                let duration = NSDateInterval(start: drawStartTime, end: Date()).duration
                Swift.print(String(format : "\tcounter = %i,\ti = %i, \tduration %0.6f\tdrawed objects:%i\tmissed objects: %i\t TOTAL: %i objects", counter, i, duration, drawed, missed, drawed + missed))
            } else {
                let duration = NSDateInterval(start: drawStartTime, end: Date()).duration
                Swift.print(String(format: "\tcounter = %i\t  ____ \tduration: %0.6f ", counter, duration))
             */
            }
            counter = counter+1
           
        }
        
    }
    
}
