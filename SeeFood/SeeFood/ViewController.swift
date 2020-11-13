//
//  ViewController.swift
//  SeeFood
//
//  Created by Laura Ghiorghisor on 21/06/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        // or .camera
        imagePicker.allowsEditing = true
     
    }
    
    // delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            guard let ciiimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to ciimage")
            }
            detect(image: ciiimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    
    
    func detect(image: CIImage) {
        // this is where we use the model
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading coreml model failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image ")
            }
            print (results)
            var found = false
            var keyword = ""
            
            for result in results {
//                result.identifier.contains("\(keyword)") &&
                if result.confidence > 0.1 {
                    found = true
                    keyword = result.identifier
                    break
                }
            }
            
            if found {
                self.navigationItem.title = "\(keyword.capitalized)!"
            } else {
                self.navigationItem.title = "Not a \(keyword)..."
            }
//            if let firstResult = results.first {
//                if firstResult.identifier.contains("flower") {
//                    self.navigationItem.title = "Flower!"
//                } else {
//                     self.navigationItem.title = "not a fall!"
//                }
            }
            
            
            
            
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print (error)
        }
        
        
    }
    @IBAction func cameraDidPress(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    


}

