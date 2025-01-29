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
        
        
        // set up a hosting view and add it to the view
        // this will block the gesture recognizers.
        let buttonView = ButtonView()
        let hostingView = TransparentHostingView(rootView: buttonView)
        
        hostingView.frame = self.view.bounds
        hostingView.autoresizingMask = [.height, .width]
        
        // Add it as a subview
        view.addSubview(hostingView)
        
        
        
//        let buttonView = ButtonView()
//           let hostingView = TransparentHostingView(rootView: buttonView)
//           
//           // Explicitly disable autoresizing mask
//           hostingView.translatesAutoresizingMaskIntoConstraints = false
//           
//           view.addSubview(hostingView)
//           
//           // Constrain to safe area or specific position
//           NSLayoutConstraint.activate([
//               hostingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//               hostingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//           ])
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
            // Primary transparent layer
//            Color.clear
//                .contentShape(Rectangle())
//                .allowsHitTesting(false)
            
            // Interactive button
            Button("SwiftUI Button \(count)") {
                count += 1
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background {
//            // Secondary transparent layer with passthrough
//            Color.clear
//                .ignoresSafeArea()
//                .allowsHitTesting(false)
//        }
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


class TransparentHostingView<Content: View>: NSHostingView<Content> {
    override func hitTest(_ point: NSPoint) -> NSView? {
        let view = super.hitTest(point)
        // Allow passthrough if the hit test returns nil (no visible/interactive content)
        return view == self ? nil : view
    }
}
