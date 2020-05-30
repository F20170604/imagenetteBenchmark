//
//  pilBenchmark.swift
//  imagenetteBenchmark
//
//  Created by Ayush Agrawal on 28/05/20.
//  Copyright © 2020 Ayush Agrawal. All rights reserved.
//

import TensorFlow
import Foundation
import PythonKit

let np = Python.import("numpy")
let glob = Python.import("glob")
let pil = Python.import("PIL")
let pilImage = Python.import("PIL.Image")
let pilImageOps = Python.import("PIL.ImageOps")

let datasetPath = "/Users/ayush517/subsetImagenette"

let classNames = ["n01440764", "n02102040", "n02979186", "n03000684", "n03028079",
"n03394916", "n03417042", "n03425413", "n03445777", "n03888257"]

func getTensor(fromPath: String) -> (Tensor<Float>, Int32) {
    let img = pilImage.open(fromPath)
    let image = np.array(img, dtype: np.float32) * (1.0 / 255)
    var imageTensor = Tensor<Float>(numpy: image)!
    
    //print(imageTensor.shape.rank)
    
    if imageTensor.shape.rank != 3 {
        return (imageTensor, -1)
    }
    
    imageTensor = imageTensor.expandingShape(at: 0)
    imageTensor = _Raw.resizeArea(images: imageTensor , size: [160, 160])
    
    var label: Int32 = 0

    for i in 0..<10 {
        if fromPath.contains(classNames[i]) {
            label = Int32(i)
            break
        }
    }
    
    return (imageTensor, label)
}

func loadDataset(datasetType: String) -> (Tensor<Float>, Tensor<Int32>)  {
    
    var imageTensor: Tensor<Float>
    var labels: [Int32] = []
    
    var path = "\(datasetPath)/\(datasetType)/n01440764"
    
    var imagePath = String(glob.glob(path+"/*.JPEG")[0])!
    //print(imagePath)
    var data = getTensor(fromPath: imagePath)
    imageTensor = data.0
    labels.append(data.1)
    
    for name in classNames[0..<10] {
        path = datasetPath+"/\(datasetType)/\(name)"
        let batchFiles = glob.glob(path+"/*.JPEG")

        for file in batchFiles {
            imagePath = String(file) ?? ""
            print(imagePath)
            data = getTensor(fromPath: imagePath)
            if data.1 == -1 {
                continue
            }
            let tensor = data.0
            labels.append(data.1)
            imageTensor = Tensor(concatenating: [imageTensor, tensor], alongAxis: 0)
        }
    }
    return (imageTensor, Tensor<Int32>(labels))
}

func loadImagenetteTrainingFiles() -> (Tensor<Float>, Tensor<Int32>) {
    return loadDataset(datasetType: "train")
}

func loadImagenetteTestFiles() -> (Tensor<Float>, Tensor<Int32>) {
    return loadDataset(datasetType: "val")
}
