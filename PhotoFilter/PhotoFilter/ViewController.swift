//
//  ViewController.swift
//  PhotoFilter
//
//  Created by Kirti Parghi on 5/20/19.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = imageView?.image, let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return
        }
        
        //To avoid blocking main thread
        //GPU and CPU are available in device
        //GPU is recommended to do any image processing or performing complex graphics tasks
        let openGLContext = EAGLContext(api: .openGLES2)!
        let context = CIContext(eaglContext: openGLContext)
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(1, forKey: kCIInputIntensityKey)

        // uncomment it to check normal sepia effect on image
//        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
//            let filteredImage = UIImage(ciImage: output)
//            imageView?.image = filteredImage
//        }
//
//        else {
//            print("image filtering failed")
//        }
        
        if let sepiaOutput = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let exposureFilter = CIFilter(name: "CIExposureAdjust")
            exposureFilter?.setValue(sepiaOutput, forKey: kCIInputImageKey)
            exposureFilter?.setValue(1, forKey: kCIInputEVKey)
            
            if let exposureOutput = exposureFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let output = context.createCGImage(exposureOutput, from: exposureOutput.extent)!
                let result = UIImage(cgImage: output)
                imageView?.image = result
            }
        }
    }
}

