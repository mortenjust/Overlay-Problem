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
        
        // add gesture recognizers to the sceneview (so we can create our own camera control)
        let rec = NSClickGestureRecognizer(target: self, action: #selector(handleClick(sender: )) )
        let panRec = NSPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        
        customView.addGestureRecognizer(rec)
        customView.addGestureRecognizer(panRec)
        
        // set up the SwiftUI view as a subview of the view controller's view
        // once this hostingview is added, the gesture recognizers no longer work
        // it's as if the nshostingview/swiftui now swallows all events.
        let buttonView = ButtonView()
        let hostingView = NSHostingView(rootView: buttonView)
        
        hostingView.frame = self.view.bounds
        hostingView.autoresizingMask = [.height, .width]
        
        // Add it as a subview
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





// Centered button in transparent view.
struct ButtonView: View {
    @State var count = 0
    
    var body: some View {
        ZStack {
            
            // this has no effectÏ
            // Color.clear.allowsHitTesting(false)
            
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




// Using this instead of the NSHostingView does pass though all events
class PassthroughHostingView<Content: View>: NSHostingView<Content> {
//    override func hitTest(_ point: NSPoint) -> NSView? {
//        // Return nil so events pass through this hosting view
//        // Unless you want certain subareas to capture the event.
//        return nil
//    }
}
