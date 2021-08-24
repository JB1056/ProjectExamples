//  Created by QFOUR DEVELOPMENT on 16/8/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI


// Global Variables to be modified for usability settings
public var titleFont : CGFloat = 22;
public var bodyFont : CGFloat = 16;
public var largeTitleFont : CGFloat = 34;
public var listFrameHeight : CGFloat = 60;
public var bigFontBool : Bool = false;
public var fontColour : Color = Color(red: 0.97, green: 0.97, blue: 0.97, opacity: 1.0);
public var lightModeBool : Bool = false;
public var textColour : Color = .white
public var backgroundColour : Color = Color(red: 0.235, green: 0.235, blue: 0.235, opacity: 0.95);
public var basicBG : Color = Color(red: 0.125, green: 0.125, blue: 0.125);

// Global Aurizon Colours
public var aurizonRed : Color = Color(red: 0.85, green: 0.07, blue: 0.07);
public var aurizonGreen : Color = Color(red: 0.258, green: 0.545, blue: 0.197);
public var aurizonOrange : Color = Color(red: 0.95, green: 0.37, blue: 0.07);
public var aurizonBlue : Color = Color(red: 0.227, green: 0.596, blue: 0.8);
public var aurizonTextWhite : Color = Color(red: 0.78, green: 0.78, blue: 0.78);
public var aurizonGreyOPC93 : Color = Color(red: 0.235, green: 0.235, blue: 0.235, opacity: 0.93);

// Tutorial variables
var tutorialActive : Bool = false
public var tutorialPageIndex: Int = 1
public let numPages = 7
public var swipeBool = false
public var navBool = false
public var exitBool = false
public var tutAcpt : Bool = false
public var tutStrt : Bool = false
public var navAnim : Bool = false
public var extAnim : Bool = false
public var swpAnim : Bool = false

// Info Bools
public var cameraInfo : Bool = false
public var hireInfo : Bool = false
public var overlayInfo : Bool = false
public var menuInfo : Bool = false
public var feedbackInfo : Bool = false
public var listInfo : Bool = false
public var settingsInfo : Bool = false

// Destination Index
func getDestination(indexValue: Int) -> AnyView {
    if indexValue == 1 { return AnyView(TutorialView()) }
    else if indexValue == 2 { return AnyView(ScanView()) }
    else if indexValue == 3 { return AnyView(HireView().environmentObject(showOverlay())) }
    else if indexValue == 4 { return AnyView(tutorialHireOverlay()) }
    else if indexValue == 5 {
        return AnyView(tutorialReturnButton("Leave a comment or suggestion (optional)...", text: HireOverlay.textFieldTextBinding, onCommit: {
            print("Final text: \(HireOverlay.textFieldText)")
        })) }
    else if indexValue == 6 { return AnyView(HireListView()) }
    else if indexValue == 7 { return AnyView(ProfileView()) }
    else if indexValue == 8 { return AnyView(TileMenuView()) }
    else {
        tutorialActive = false
        return AnyView(TileMenuView())
    }
}


// MULTI LINE TEXT FIELD
struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?
    
    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator
        
        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
        if nil != onDone {
            textField.returnKeyType = .done
        }
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        if uiView.window != nil, !uiView.isFirstResponder {
            //uiView.becomeFirstResponder()
        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }
    
    static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        
        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }
        
        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }
    
}
