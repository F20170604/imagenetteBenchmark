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
let pilImage = Python.import("PIL.Image")

func getPILTensor(fromPath: String, imageSize: Int32) -> (Tensor<Float>, Int32) {
    let img = pilImage.open(fromPath)
    //print(fromPath)
    let image = np.array(img, dtype: np.float32) * (1.0 / 255)
    var imageTensor = Tensor<Float>(numpy: image)!
    let outputSize = _TensorElementLiteral<Int32>(integerLiteral: imageSize)
    
    imageTensor = imageTensor.expandingShape(at: 0)
    imageTensor = _Raw.resizeArea(images: imageTensor , size: [outputSize, outputSize])
    
    var label: Int32 = 0

    for i in 0..<10 {
        if fromPath.contains(classNames[i]) {
            label = Int32(i)
            break
        }
    }
    //print(imageTensor.shape)
    return (imageTensor, label)
}

func loadPILDataset(datasetPaths: [String], imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>)  {
    
    var imageTensor: Tensor<Float>
    var labels: [Int32] = []
    
    var data = getPILTensor(fromPath: datasetPaths[0], imageSize: imageSize)
    imageTensor = data.0
    labels.append(data.1)
    
    for path in datasetPaths[1..<datasetPaths.count] {
        //print(imagePath)
        data = getPILTensor(fromPath: path, imageSize: imageSize)
        let tensor = data.0
        labels.append(data.1)
        imageTensor = Tensor(concatenating: [imageTensor, tensor], alongAxis: 0)
    }
    return (imageTensor, Tensor<Int32>(labels))
}

func loadPILImagenetteTrainingFiles(imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>) {
    let trainPaths = try! getTrainPaths(imageSize: imageSize)
    return loadPILDataset(datasetPaths: trainPaths, imageSize: imageSize)
}

func loadPILImagenetteTestFiles(imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>) {
    let valPaths = try! getValPaths(imageSize: imageSize)
    return loadPILDataset(datasetPaths: valPaths, imageSize: imageSize)
}
