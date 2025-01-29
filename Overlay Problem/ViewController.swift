//
//  ViewController.swift
//  Overlay Problem
//
//  Created by Morten Petersen on 1/29/25.
//

import Cocoa
import SwiftUI

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an NSHostingView with the SwiftUI view
        let buttonView = ButtonView()
        let hostingView = NSHostingView(rootView: buttonView)
        
        hostingView.frame = self.view.bounds
        hostingView.autoresizingMask = [.height, .width]
        
        // Add it as a subview
        view.addSubview(hostingView)

    }
}


// centered button in view
struct ButtonView: View {
    @State var count = 0
    var body: some View {
        VStack {
            Text("Hello")
            HStack {
                Button("Swiftui Button" + String(count)) {
                    count += 1
                }
            }
            Text("Hello")
        }
        .background(Color.yellow)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

