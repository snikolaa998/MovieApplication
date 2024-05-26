//
//  Toast.swift
//  MovieApp
//
//  Created by Nikola Savic on 26.5.24..
//

import SwiftUI

public struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double
    var width: Double
    
    public init(
        style: ToastStyle,
        message: String,
        duration: Double = 3,
        width: Double = 320
    ) {
        self.style = style
        self.message = message
        self.duration = duration
        self.width = width
    }
}

public enum ToastStyle {
    case info
}

public extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .info:
            return Color.primaryBackground
        }
    }
}

public struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: 4)
                }
                    .animation(.spring(), value: toast)
            )
            .onChange(of: toast) { value in
                showToast()
            }
    }
    
    @ViewBuilder public func mainToastView() -> some View {
        if let toast = toast {
            VStack(spacing: 0) {
                ToastView(
                    style: toast.style,
                    message: toast.message,
                    width: toast.width
                ) {
                    dismissToast()
                }
                Spacer()
            }
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}

public extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
