//
//  PanGestureViewModifier.swift
//
//
//  Created by Nikolai Nobadi on 8/9/24.
//

import SwiftUI

// TODO: - Move to NnSwiftUIKit
struct PanGestureViewModifier: ViewModifier {
    let handleSwipeDirection: (PanGestureSwipDirection) -> Void
    
    func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let velocityY = gesture.velocity(in: gesture.view).y
        
        if velocityY < 0 {
            if -(velocityY / 5) > 60 {
                handleSwipeDirection(.up)
            }
        } else {
            if (velocityY / 5) > 40  {
                handleSwipeDirection(.down)
            }
        }
    }
    func body(content: Content) -> some View {
        content
            .background(
                CustomGesture {
                   handleGesture($0)
                }
            )
    }
}

public extension View {
    func handlingVerticalPanGesture(handleSwipeDirection: @escaping (PanGestureSwipDirection) -> Void) -> some View {
        modifier(PanGestureViewModifier(handleSwipeDirection: handleSwipeDirection))
    }
}

public enum PanGestureSwipDirection {
    case up, down
}

// MARK: - Gesture
fileprivate struct CustomGesture: UIViewRepresentable {
    private let gestureId = UUID().uuidString
    
    var onChange: (UIPanGestureRecognizer) -> Void
    
    func makeCoordinator() -> Coordinator {
        return .init(onChange: onChange)
    }
    
    func makeUIView(context: Context) -> some UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let superview = uiView.superview?.superview, !(superview.gestureRecognizers?.contains(where: { $0.name == gestureId }) ?? false) {
                let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))
                
                gesture.name = gestureId
                gesture.delegate = context.coordinator
                
                superview.addGestureRecognizer(gesture)
            }
        }
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onChange: (UIPanGestureRecognizer) -> Void
        
        init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onChange = onChange
        }
        
        @objc
        func gestureChange(gesture: UIPanGestureRecognizer) {
            onChange(gesture)
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
