//  Created by QFOUR DEVELOPMENT on 12/8/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation
import MLKit

struct ScanView: View {
    
    @State var showMenu = false
    @State var info = cameraInfo
    
    @ObservedObject private var viewModel = VehicleViewModel()
    
    var body: some View {
        
        // Asserts swipe navigation state
        let drag = DragGesture().onEnded {
            if $0.translation.height > -100 {
                withAnimation {
                    self.showMenu = true
                }
            }
            if $0.translation.height < -100 {
                withAnimation {
                    self.showMenu = false
                }
            }
        }
        
        return GeometryReader { geometry in
            ZStack() {
                ViewControllerWrapper(showMenu: self.$showMenu)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .disabled(self.showMenu ? true: false)
                    .background(Color.black)
                
                // Creates target widget to assist with camera aiming
                HStack{
                    VStack {
                        Rectangle().trim(from: 0.2, to: 0.3).rotation(Angle(degrees: Double(270)), anchor: .center).stroke(Color.white, lineWidth: 2).frame(width: geometry.size.width / 5, height: geometry.size.width / 5).zIndex(10)
                        
                        Rectangle().trim(from: 0.2, to: 0.3).rotation(Angle(degrees: Double(180)), anchor: .center).stroke(Color.white, lineWidth: 2).frame(width: geometry.size.width / 5, height: geometry.size.width / 5).zIndex(10)
                    }
                    Spacer()
                    VStack {
                        Rectangle().trim(from: 0.2, to: 0.3).rotation(Angle(degrees: Double(0)), anchor: .center).stroke(Color.white, lineWidth: 2).frame(width: geometry.size.width / 5, height: geometry.size.width / 5).zIndex(10)
                        
                        Rectangle().trim(from: 0.2, to: 0.3).rotation(Angle(degrees: Double(90)), anchor: .center).stroke(Color.white, lineWidth: 2).frame(width: geometry.size.width / 5, height: geometry.size.width / 5).zIndex(10)
                    }
                }.padding(50).zIndex(9)
                
                /// Tutorial Popup Card, disables menu changing
                if tutorialActive {
                    if self.info {
                        VStack {
                            Text("Aim Camera at Desired Vehicle Registration").font(.system(size: titleFont+6, weight: .semibold))
                            
                            Text("For Demonstration purposes, scanning has been disabled.").font(.system(size: bodyFont, weight: .semibold)).multilineTextAlignment(.center).padding()
                            
                            Text("Simply direct the camera at a valid registration and we will do the rest").font(.system(size: bodyFont)).multilineTextAlignment(.center)
                            
                            HStack{
                                Button(action: { self.info = false; cameraInfo = false; }) {
                                    Text("OK")
                                        .font(.system(size: bodyFont, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: UIScreen.main.bounds.width / 4, height: 42.0 )
                                        .background(RoundedRectangle(cornerRadius: 40)
                                            .foregroundColor(aurizonOrange)).padding()
                                }
                            }
                        }.frame(width: UIScreen.main.bounds.width * 4 / 5, height: 200)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .zIndex(10)
                    }
                    
                    Text("Aim Camera at Desired Vehicle Registration")
                        .font(.system(size: titleFont, weight: .bold))
                        .foregroundColor(.white).zIndex(9)
                    
                    // Initiate Tutorial Widget
                    TutorialFlow().zIndex(8)
                }
                
                if self.showMenu {
                    TileMenuView().transition(.move(edge: .top))
                }
                // Executes swipe navigation state
            }.gesture(drag)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}


// MARK: - ViewControllerWrapper
struct ViewControllerWrapper: UIViewControllerRepresentable {
    
    @Binding var showMenu: Bool
    
    typealias UIViewControllerType = CameraViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerWrapper>) -> ViewControllerWrapper.UIViewControllerType {
        return CameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewControllerWrapper.UIViewControllerType, context:
        UIViewControllerRepresentableContext<ViewControllerWrapper>) {
        //
    }
}

// MARK: - CameraView UIView Class (do not delete)

class CameraView : UIView {
    
}

// MARK: - ViewController

@objc(CameraViewController)
class CameraViewController: UIViewController {
    
    @ObservedObject private var viewModel = VehicleViewModel()
    private var regoTemp = ""
    private var isUsingFrontCamera = false
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private lazy var captureSession = AVCaptureSession()
    private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
    private var lastFrame: CMSampleBuffer?
    private var ipadRes : Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    private lazy var previewOverlayView: UIImageView = {
        
        precondition(isViewLoaded)
        let previewOverlayView = UIImageView(frame: .zero)
        previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
        previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return previewOverlayView
    }()
    
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return annotationOverlayView
    }()
    
    // MARK: - UIView Var
    // Assigns camera view as a variable
    var cameraView : CameraView {return self.view as! CameraView}
    
    // MARK: - UIViewController
    // Asserts and sets elements on successful generation of view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.fetchData()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        setUpPreviewOverlayView()
        setUpAnnotationOverlayView()
        setUpCaptureSessionOutput()
        setUpCaptureSessionInput()
    }
    
    // Loads Camera View
    override func loadView() {
        self.view = CameraView(frame: UIScreen.main.bounds)
    }
    
    // Initiates Session
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSession()
    }
    
    // Terminates Session
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = cameraView.bounds
    }
    
    // MARK: - Text Recognition + Camera
    private func recognizeTextOnDevice(in image: VisionImage, width: CGFloat, height: CGFloat) {
        var recognizedText: MLKit.Text
        
        // Attempt to recognise text on screen
        do {
            recognizedText = try TextRecognizer.textRecognizer().results(in: image)
        } catch let error {
            print("Failed to recognize text with error: \(error.localizedDescription).")
            return
        }
        
        // Display Camera Preview
        DispatchQueue.main.sync {
            self.updatePreviewOverlayView()
            self.removeDetectionAnnotations()
            
            // Disable scanning if tutorial is active
            if !tutorialActive {
                
                // update sheet contents
                if Registration.currentRego != regoTemp {
                    let child = UIHostingController(rootView: Sheet())
                    let parent = self
                    child.view.translatesAutoresizingMaskIntoConstraints = false
                    child.view.frame = parent.view.bounds
                    parent.view.addSubview(child.view)
                    parent.addChild(child)
                    regoTemp = Registration.currentRego
                }
                
                // Check if rego exists within system and show hiring page if it does
                for block in recognizedText.blocks {
                    for line in block.lines {
                        for element in line.elements {
                            for vehicle in viewModel.vehicles {
                                // Check if scanned contents match database
                                if element.text == vehicle.plate {
                                    Registration.currentRego = element.text
                                    Registration.isSheetShowing = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func setUpCaptureSessionOutput() {
        sessionQueue.async {
            self.captureSession.beginConfiguration()
            // When performing latency tests to determine ideal capture settings,
            // run the app in 'release' mode to get accurate performance metrics
            if (self.ipadRes) {
                self.captureSession.sessionPreset = AVCaptureSession.Preset.medium
            }
            else{
                self.captureSession.sessionPreset = AVCaptureSession.Preset.iFrame960x540
            }
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [
                (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
            ]
            output.alwaysDiscardsLateVideoFrames = true
            let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
            output.setSampleBufferDelegate(self, queue: outputQueue)
            guard self.captureSession.canAddOutput(output) else {
                print("Failed to add capture session output.")
                return
            }
            self.captureSession.addOutput(output)
            self.captureSession.commitConfiguration()
        }
    }
    
    private func setUpCaptureSessionInput() {
        sessionQueue.async {
            let cameraPosition: AVCaptureDevice.Position = self.isUsingFrontCamera ? .front : .back
            guard let device = self.captureDevice(forPosition: cameraPosition) else {
                print("Failed to get capture device for camera position: \(cameraPosition)")
                return
            }
            do {
                self.captureSession.beginConfiguration()
                let currentInputs = self.captureSession.inputs
                for input in currentInputs {
                    self.captureSession.removeInput(input)
                }
                
                let input = try AVCaptureDeviceInput(device: device)
                guard self.captureSession.canAddInput(input) else {
                    print("Failed to add capture session input.")
                    return
                }
                self.captureSession.addInput(input)
                self.captureSession.commitConfiguration()
            } catch {
                print("Failed to create capture device input: \(error.localizedDescription)")
            }
        }
    }
    
    private func startSession() {
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    private func stopSession() {
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
    }
    
    private func setUpPreviewOverlayView() {
        cameraView.addSubview(previewOverlayView)
        NSLayoutConstraint.activate([
            previewOverlayView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            previewOverlayView.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
            previewOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            previewOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            
        ])
    }
    
    private func setUpAnnotationOverlayView() {
        cameraView.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
            annotationOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            annotationOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            annotationOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            annotationOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
        ])
    }
    
    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if #available(iOS 10.0, *) {
            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .unspecified
            )
            return discoverySession.devices.first { $0.position == position }
        }
        return nil
    }
    
    // Removes Live translation text to remove clutter on screen
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
    
    // Update the overlay preview with buffered frames
    private func updatePreviewOverlayView() {
        guard let lastFrame = lastFrame,
            let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
            else {
                return
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return
        }
        let rotatedImage = UIImage(cgImage: cgImage, scale: Constant.originalScale, orientation: .right)
        if isUsingFrontCamera {
            guard let rotatedCGImage = rotatedImage.cgImage else {
                return
            }
            let mirroredImage = UIImage(
                cgImage: rotatedCGImage, scale: Constant.originalScale, orientation: .leftMirrored)
            previewOverlayView.image = mirroredImage
        } else {
            previewOverlayView.image = rotatedImage
        }
    }
    
    private func convertedPoints(
        from points: [NSValue]?, width: CGFloat, height: CGFloat) -> [NSValue]? {
        return points?.map {
            let cgPointValue = $0.cgPointValue
            let normalizedPoint = CGPoint(x: cgPointValue.x / width, y: cgPointValue.y / height)
            let cgPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
            let value = NSValue(cgPoint: cgPoint)
            return value
        }
    }
    
    private func normalizedPoint(
        fromVisionPoint point: VisionPoint,
        width: CGFloat,
        height: CGFloat
    ) -> CGPoint {
        let cgPoint = CGPoint(x: point.x, y: point.y)
        var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
        normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
        return normalizedPoint
    }
}

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        // Buffer used to preload camera view controller
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            else {
                print("Failed to get image buffer from sample buffer.")
                return
        }
        
        lastFrame = sampleBuffer
        let visionImage = VisionImage(buffer: sampleBuffer)
        let orientation = UIUtilities.imageOrientation(
            fromDevicePosition: isUsingFrontCamera ? .front : .back)
        
        visionImage.orientation = orientation
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        
        recognizeTextOnDevice(in: visionImage, width: imageWidth, height: imageHeight)
    }
}

// MARK: - Constants
// Provides constant variables used to communicate with API
private enum Constant {
    static let videoDataOutputQueueLabel = "com.google.mlkit.visiondetector.VideoDataOutputQueue"
    static let sessionQueueLabel = "com.google.mlkit.visiondetector.SessionQueue"
    static let originalScale: CGFloat = 3.0
    
}
