//
//  ContentView.swift
//  360AR
//
//  Created by Mohammad Azam on 8/8/22.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

class Coordinator {
    
    var arView: ARView?
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        
        guard let arView = arView else { return }
        let location = recognizer.location(in: arView)
        
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        if let result = results.first {
            
            let anchor = AnchorEntity(raycastResult: result)
            // load a teapot model 
            guard let model = try? ModelEntity.load(named: "teapot") else { return }
            anchor.addChild(model)
            arView.scene.addAnchor(anchor)
            
            /*
            let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [SimpleMaterial(color: UIColor.random(), isMetallic: true)])
            box.position = simd_float3(0, 0.5, 0)
            box.generateCollisionShapes(recursive: true)
            box.physicsBody = PhysicsBodyComponent()
            box.physicsBody?.mode = .dynamic
            anchor.addChild(box)
            arView.scene.addAnchor(anchor)
             */
        }
        
        /*
        if let entity = arView.entity(at: location) as? ModelEntity {
            entity.model?.materials = [SimpleMaterial(color: UIColor.random(), isMetallic: true)]
        } */
    }
    
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapped)))
        context.coordinator.arView = arView
      
        // create an entity
        let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [SimpleMaterial(color: .green, isMetallic: true)])
        
        box.generateCollisionShapes(recursive: true)
        box.physicsBody = PhysicsBodyComponent()
        box.physicsBody?.mode = .static
        
        
        let sphere = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.3), materials: [SimpleMaterial(color: .red, isMetallic: true)])
        sphere.position = simd_float3(0,0.5,0)
        
        // create an anchor
        let anchor = AnchorEntity(plane: .horizontal)
        
        anchor.addChild(box)
        //anchor.addChild(sphere)
        
        arView.scene.addAnchor(anchor)
        
        return arView
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
