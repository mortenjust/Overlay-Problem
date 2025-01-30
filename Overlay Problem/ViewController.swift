//
//  ViewController.swift
//  Overlay Problem
//
//  Created by Morten Petersen on 1/29/25.
//

import Cocoa
import SwiftUI
import SceneKit

class ViewController: NSViewController {
    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var customView: NSView!
    
    @objc func handleClick(sender: Any) {
        print("Click!" + String(Date().timeIntervalSince1970))
    }
    
    @objc func handlePan(sender: Any) {
        print("Pan!" + String(Date().timeIntervalSince1970))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add gesture recognizers
        let rec = NSClickGestureRecognizer(target: self, action: #selector(handleClick(sender: )) )
        let panRec = NSPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        
        customView.addGestureRecognizer(rec)
        customView.addGestureRecognizer(panRec)
        
        // set up a hosting view and add it to the view
        // this will block the gesture recognizers.
        let buttonView = ButtonView()
        let hostingView = NSHostingView(rootView: buttonView)
        
        hostingView.frame = self.view.bounds
        hostingView.autoresizingMask = [.height, .width]
        
        // Add it as a subview.
        // On Xcode 16, the gesture recognizers don't produce console messages an ymore
        // On Xcode 15, they do.
        view.addSubview(hostingView)
    }
    
    func createScene () -> SCNScene {
        let box = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 1)
        let node = SCNNode(geometry: box)
        let scene = SCNScene()
        scene.rootNode.addChildNode(node)
        return scene
    }
}




// The SwiftUI view
// Centered button in transparent view.
struct ButtonView: View {
    @State var count = 0
    
    var body: some View {
        ZStack {
            // Interactive button
            Button("SwiftUI Button \(count)") {
                count += 1
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


//// Using this instead of the NSHostingView does pass though all events
//class PassthroughHostingView<Content: View>: NSHostingView<Content> {
////    override func hitTest(_ point: NSPoint) -> NSView? {
////        // Return nil so events pass through this hosting view
////        // Unless you want certain subareas to capture the event.
////        return nil
////    }
//}
//
//
//// Doing this does solve some of the problems, but not all the time.
//class TransparentHostingView<Content: View>: NSHostingView<Content> {
//    override func hitTest(_ point: NSPoint) -> NSView? {
//        let view = super.hitTest(point)
//        // Allow passthrough if the hit test returns nil (no visible/interactive content)
//        return view == self ? nil : view
//    }
//}
