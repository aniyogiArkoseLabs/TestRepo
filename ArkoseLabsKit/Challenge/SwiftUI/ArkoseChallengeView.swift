//
//  Enforcement.swift
//  ArkoseLabsKit
//
//  Created by Avik Niyogi on 18/11/22.
//

import SwiftUI

public struct ArkoseChallengeView: View {
    @Binding public var isPresented : Bool
    public var delegate: ArkoseChallengeDelegate
    private var cancelButtonTitle: String?
    private var resetButtonTitle: String?
    public init(isPresented: Binding<Bool>,
                delegate: ArkoseChallengeDelegate,
                cancelButtonTitle: String? = "Cancel",
                resetButtonTitle: String? = nil) {
        self._isPresented = isPresented
        self.delegate = delegate
        self.cancelButtonTitle = cancelButtonTitle
        self.resetButtonTitle = resetButtonTitle
    }
    public var body: some View {
        VStack {
        }.compatibleFullScreen(isPresented: $isPresented) {
            //let vc = ChallengeViewControllerRepresentable(delegate: delegate, type: .alert)
            let vc = ChallengeViewControllerRepresentable(delegate: delegate,
                                                          cancelButtonTitle: cancelButtonTitle,
                                                          resetButtonTitle: resetButtonTitle)
            vc.background(BackgroundBlurView().edgesIgnoringSafeArea(.all))
        }
    }
}
extension View {
    func compatibleFullScreen<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(FullScreenModifier(isPresented: isPresented, builder: content))
    }
}

struct FullScreenModifier<V: View>: ViewModifier {
    let isPresented: Binding<Bool>
    let builder: () -> V
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content.fullScreenCover(isPresented: isPresented, content: builder)
        } else {
            content.sheet(isPresented: isPresented, content: builder)
        }
    }
}
struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
            view.alpha = 0.5
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
