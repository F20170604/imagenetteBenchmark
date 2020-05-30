//
//  subsetImagenette.swift
//  imagenetteBenchmark
//
//  Created by Ayush Agrawal on 30/05/20.
//  Copyright © 2020 Ayush Agrawal. All rights reserved.
//

import Foundation
import PythonKit

let rnd = Python.import("random")
let os = Python.import("os")
let ospath = Python.import("os.path")
let destinationDirectory = "/Users/ayush517/subsetImagenette"

let originalDatasetPath = "/Users/ayush517/imagenette2-160"

func createDataset(datasetType: String, numImagesPerClass: Int32) -> PythonObject {
    
    rnd.seed(42)
    var totalImagesDone : Int32 = 0
    let finalList : PythonObject = []
    
    for name in classNames[0..<10] {
        
        let path = originalDatasetPath+"/\(datasetType)/\(name)"
        let batchFiles = glob.glob(path+"/*.JPEG")

        rnd.shuffle(batchFiles)
        var numberOfImagesDone : Int32 = 0
        
        for file in batchFiles {
            let imagePath = String(file) ?? ""
            let img = pilImage.open(imagePath)
            
            let channels = Python.len(img.getbands())
            
            let destinationPath = "\(destinationDirectory)/\(datasetType)/\(name)"
            
            do
            {
                try FileManager.default.createDirectory(atPath: destinationPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error as NSError
            {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
            let filename = ospath.basename(imagePath)
            let filePath = "\(destinationPath)/\(filename)"
            
            if channels == 3 {
                //print(imagePath)
                numberOfImagesDone = numberOfImagesDone + 1
                totalImagesDone = totalImagesDone + 1
                img.save(filePath)
                finalList.append(filePath)
            }
            if numberOfImagesDone == numImagesPerClass {
                break
            }
        }
    }
    //print(totalImagesDone)
    return finalList
}
