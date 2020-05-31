//
//  stbImageBenchmark.swift
//  imagenetteBenchmark
//
//  Created by Ayush Agrawal on 31/05/20.
//  Copyright © 2020 Ayush Agrawal. All rights reserved.
//

import TensorFlow
import Foundation
import PythonKit

func getSTBImageTensor(fromPath: URL, imageSize: Int) -> (Tensor<Float>, Int32) {
    //print(fromPath)
    let img = Image(jpeg: fromPath)
    var imageTensor = img.resized(to: (imageSize, imageSize)).tensor / 255.0
    
    let classFolder = fromPath.absoluteString.components(separatedBy: "/")[7]
    //print(classFolder)
    var label: Int32 = -1

    for i in 0..<10 {
        if classFolder.contains(classNames[i]) {
            label = Int32(i)
            break
        }
    }
    
    //let outputSize = _TensorElementLiteral<Int32>(integerLiteral: Int32(imageSize))
    imageTensor = imageTensor.reshaped(to: [1, imageSize, imageSize, 3])
    //print(imageTensor.shape)
    return (imageTensor, label)
}

func loadSTBImageDataset(datasetPaths: [URL], imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>)  {
    
    var imageTensor: Tensor<Float>
    var labels: [Int32] = []
    
    var data = getSTBImageTensor(fromPath: datasetPaths[0], imageSize: Int(imageSize))
    imageTensor = data.0
    labels.append(data.1)
    
    for path in datasetPaths[1..<datasetPaths.count] {
        //print(imagePath)
        data = getSTBImageTensor(fromPath: path, imageSize: Int(imageSize))
        let tensor = data.0
        labels.append(data.1)
        imageTensor = Tensor(concatenating: [imageTensor, tensor], alongAxis: 0)
    }
    return (imageTensor, Tensor<Int32>(labels))
}

func loadSTBImageImagenetteTrainingFiles(imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>) {
    let trainPaths = try! getURLS(datasetType: "train", imageSize: imageSize)
    return loadSTBImageDataset(datasetPaths: trainPaths, imageSize: imageSize)
}

func loadSTBImageImagenetteTestFiles(imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>) {
    let valPaths = try! getURLS(datasetType: "val", imageSize: imageSize)
    return loadSTBImageDataset(datasetPaths: valPaths, imageSize: imageSize)
}
