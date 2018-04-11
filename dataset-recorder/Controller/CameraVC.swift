//
//  CameraVC.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 24/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit
import AVFoundation


class CameraVC: UIViewController {
    
    var flashMode: AVCaptureDevice.FlashMode = .off

    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var flashButton: UIBarButtonItem!
    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Prepare camera
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFlashState()
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCameraViewTapped))
        tap.numberOfTapsRequired = 1
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        let backCamera = AVCaptureDevice.default(for: .video)!
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            cameraOutput = AVCapturePhotoOutput()
            if captureSession.canAddOutput(cameraOutput) {
                captureSession.addOutput(cameraOutput!)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.connection?.videoOrientation = .portrait
                
                previewLayer.frame = cameraView.layer.bounds
                cameraView.layer.addSublayer(previewLayer!)
                cameraView.addGestureRecognizer(tap)
                captureSession.startRunning()
            }
        } catch {
            debugPrint(error)
        }
    }
    
    // Load flash state from user defaults
    private func loadFlashState() {
        let defaults = UserDefaults.standard
        if let mode = AVCaptureDevice.FlashMode(rawValue: defaults.integer(forKey: "FlashMode")) {
            flashMode = mode
        } else {
            flashMode = .off
        }
        updateFlashButtonTitle(mode: flashMode)
    }
    
    // Take photo when view tapped
    @objc func onCameraViewTapped() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        settings.flashMode = flashMode
        
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // Got to ImageVC
    func presentImageEditor(_ image: UIImage) {
        if let imageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageId") as? ImageVC {
            imageVC.image = image
            present(imageVC, animated: false, completion: nil)
        }
    }
    
    // Go back to DatasetVC
    @IBAction func onBackTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "datasetVC")
        present(vc, animated: false, completion: nil)
    }
    
    // Switch flash button
    @IBAction func flashButtonTapped(_ sender: Any) {
        if flashMode == .on {
            flashMode = .auto
        } else if flashMode == .auto {
            flashMode = .off
        } else {
            flashMode = .on
        }
        updateFlashButtonTitle(mode: flashMode)
        let defaults = UserDefaults.standard
        defaults.set(flashMode.rawValue, forKey: "FlashMode")
    }
    
    // Set flash mode and update label
    func updateFlashButtonTitle(mode: AVCaptureDevice.FlashMode) {
        switch mode {
        case .off:
            flashButton.title = "Flash OFF"
            break
        case .on:
            flashButton.title = "Flash ON"
            break
        case .auto:
            flashButton.title = "Flash AUTO"
            break
        }
    }
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error)
        } else {
            let photoData = photo.fileDataRepresentation()
            let image = UIImage(data: photoData!)
            presentImageEditor(image!)
        }
    }
}
