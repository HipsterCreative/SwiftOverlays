//
//  WaitVC.swift
//  Example
//
//  Created by Peter Prokop on 17/10/14.
//
//

import UIKit

class OverlayExampleVC: UIViewController {
    enum ExampleType {
        case Wait
        case WaitWithText
        case TextOnly
        case ImageAndText
        case AnnoyingNotification
        case BlockingWait
        case BlockingWaitWithText
    }
    
    @IBOutlet var annoyingNotificationView: UIView?
    
    var type: ExampleType = .Wait

    var beginTimer: NSTimer?
    var endTimer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.begin()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let beginTimer = beginTimer {
            beginTimer.invalidate()
        }
        
        if let endTimer = endTimer {
            endTimer.invalidate()
        }
        
        SwiftOverlays.removeAllBlockingOverlays()
    }
    
    // MARK: begin/end
    func begin() {
        switch (type) {
        case .Wait:
            self.showWaitOverlay()
            // Or SwiftOverlays.showCenteredWaitOverlay(self.view)
            
        case .WaitWithText:
            let text = "Please wait..."
            self.showWaitOverlayWithText(text)
            // Or SwiftOverlays.showCenteredWaitOverlayWithText(self.view, text: text)
        
        case .TextOnly:
            let text = "This is a text-only overlay...\n...spanning several lines"
            self.showTextOverlay(text)
            // Or SwiftOverlays.showTextOverlay(self.view, text: text)
            
            return
            
        case .ImageAndText:
            let image = PPSwiftGifs.animatedImageWithGIFNamed("Loading")
            let text = "Overlay\nWith cool GIF!"
            self.showImageAndTextOverlay(image!, text: text)
            // Or SwiftOverlays.showImageAndTextOverlay(self.view, image: image!, text: text)
            
            return
            
        case .AnnoyingNotification:
            NSBundle.mainBundle().loadNibNamed("AnnoyingNotification", owner: self, options: nil)
            annoyingNotificationView!.frame.size.width = self.view.bounds.width;
            
            UIViewController.showNotificationOnTopOfStatusBar(annoyingNotificationView!, duration: 5)
            // Or SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(annoyingNotificationView!, duration: 5)
            
            return
            
        case .BlockingWait:
            SwiftOverlays.showBlockingWaitOverlay()
            
        case .BlockingWaitWithText:
            SwiftOverlays.showBlockingWaitOverlayWithText("This is blocking overlay!")
        }
        
        if let endTimer = endTimer {
            endTimer.invalidate()
        }
        
        endTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "end", userInfo: nil, repeats: false)
    }
    
    func end() {
        switch (type) {
        case .Wait, .WaitWithText, .TextOnly, .ImageAndText:
            SwiftOverlays.removeAllOverlaysFromView(self.view)
            
        case .BlockingWait, .BlockingWaitWithText:
            SwiftOverlays.removeAllBlockingOverlays()
            
        case .AnnoyingNotification:
            return
        }
        
        
        if let beginTimer = beginTimer {
            beginTimer.invalidate()
        }
        
        beginTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "begin", userInfo: nil, repeats: false)
    }
}