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
    
    let folders = fromPath.components(separatedBy: "/")
    let classFolder = folders[folders.count-2]
    
    let label: Int32 = Int32(unwrappedLabelDict[classFolder]!)
    
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

// ------ Remving steps 4 & 5 -------

func loadPILTestFiles2(imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>) {
    let valPaths = try! getValPaths(imageSize: imageSize)
    return loadPILDataset(datasetPaths: valPaths, imageSize: imageSize)
}

func loadPILDataset2(datasetPaths: [String], imageSize: Int32)  {
    for path in datasetPaths[0..<datasetPaths.count] {
        getPILTensor2(fromPath: path, imageSize: imageSize)
    }
}

func getPILTensor2(fromPath: String, imageSize: Int32) {
    let img = pilImage.open(fromPath)
    //print(fromPath)
    let image = np.array(img, dtype: np.float32) * (1.0 / 255)
    var imageTensor = Tensor<Float>(numpy: image)!
    let outputSize = _TensorElementLiteral<Int32>(integerLiteral: imageSize)
    
    imageTensor = imageTensor.expandingShape(at: 0)
    imageTensor = _Raw.resizeArea(images: imageTensor , size: [outputSize, outputSize])
}

func loadPILImagenetteTrainingFiles2(imageSize: Int32) {
    let trainPaths = try! getTrainPaths(imageSize: imageSize)
    loadPILDataset2(datasetPaths: trainPaths, imageSize: imageSize)
}
