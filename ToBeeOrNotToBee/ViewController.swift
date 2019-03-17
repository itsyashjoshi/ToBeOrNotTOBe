//
//  ViewController.swift
//  ToBeeOrNotToBee
//
//  Created by Yash Joshi on 15/03/19.
//  Copyright © 2019 Yash Joshi. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    // initialise imagepicker controller
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        // Allow user to edit or not
        imagePicker.allowsEditing = false
    
        
    }
    //process after picking image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //pick selected image as UIImage
        if let imageSelected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        imageView.image = imageSelected
            //convert UIImage to CIImage so that we can use it with model
            guard let finalImage = CIImage(image: imageSelected) else {
                fatalError("Couldn't convert to CIImage!!")
            }
            //proocess the selected image on model via func created below as detect
            detect(image: finalImage)
        }
        //dismiss imagePicker
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    func detect(image: CIImage) {
        //This part processes image in the model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        //after success of the above process
        let request = VNCoreMLRequest(model: model) { (request, error ) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model Failed")
            }
           // print(result)
            
            if let firstResult = result.first {
                if firstResult.identifier.contains("pizza"){
                    self.navigationItem.title = "Pizza🤪"
                } else {
                    self.navigationItem.title = "Not Pizza 😥"
                }
            }
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
        try! handler.perform([request])
        } catch {
            print(error)
        }
    }
    //This is for using Camera
    @IBAction func camera(_ sender: UIBarButtonItem) {
      present(imagePicker, animated: true, completion: nil)
        imagePicker.sourceType = .camera
    }
    
    //This is for using Photo Library
    @IBAction func Library(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        imagePicker.sourceType = .photoLibrary
    }
    
}

