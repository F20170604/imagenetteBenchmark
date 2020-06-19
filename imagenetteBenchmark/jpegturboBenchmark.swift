//
//  jpegturboBenchmark.swift
//  imagenetteBenchmark
//
//  Created by Ayush Agrawal on 14/06/20.
//  Copyright © 2020 Ayush Agrawal. All rights reserved.
//

import TensorFlow
import Foundation

func getJPEGTurboTensor(fromPath: URL, imageSize: Int) -> (Tensor<Float>, Int32) {
    //print(fromPath)
    let img = jtImage(jpeg: fromPath)
    var imageTensor = img.resized(to: (imageSize, imageSize)).tensor / 255.0
    
    let label: Int32 = Int32(unwrappedLabelDict[parentLabel(url: fromPath)]!)
    
    imageTensor = imageTensor.reshaped(to: [1, imageSize, imageSize, 3])
    //print(imageTensor.shape)
    return (imageTensor, label)
}

func loadJPEGTurboDataset(datasetPaths: [URL], imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>)  {
    
    var imageTensor: Tensor<Float>
    var labels: [Int32] = []
    
    var data = getJPEGTurboTensor(fromPath: datasetPaths[0], imageSize: Int(imageSize))
    imageTensor = data.0
    labels.append(data.1)
    
    for path in datasetPaths[1..<datasetPaths.count] {
        //print(imagePath)
        data = getJPEGTurboTensor(fromPath: path, imageSize: Int(imageSize))
        let tensor = data.0
        labels.append(data.1)
        imageTensor = Tensor(concatenating: [imageTensor, tensor], alongAxis: 0)
    }
    return (imageTensor, Tensor<Int32>(labels))
}

func loadJPEGTurboImagenetteTrainingFiles(imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>) {
    let trainPaths = try! getURLS(datasetType: "train", imageSize: imageSize)
    return loadJPEGTurboDataset(datasetPaths: trainPaths, imageSize: imageSize)
}

func loadJPEGTurboImagenetteTestFiles(imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>) {
    let valPaths = try! getURLS(datasetType: "val", imageSize: imageSize)
    return loadJPEGTurboDataset(datasetPaths: valPaths, imageSize: imageSize)
}

// ------ After Remving steps 4 & 5 -------


func loadJPEGTurboDataset2(datasetPaths: [URL], imageSize: Int32)  {
    
    for path in datasetPaths[0..<datasetPaths.count] {
        getJPEGTurboTensor2(fromPath: path, imageSize: Int(imageSize))
    }
}

func getJPEGTurboTensor2(fromPath: URL, imageSize: Int) {
    //print(fromPath)
    let img = jtImage(jpeg: fromPath)
    let tensor = img.resized(to: (imageSize, imageSize)).tensor / 255.0
//    if Double.random < 0.01 {
//        let label: Int32 = Int32(unwrappedLabelDict[parentLabel(url: fromPath)]!)
//        showTensorImage(tensor, title: "\(label)", pltAxes: nil)
//    }
//    print(imageTensor.shape)
}

func loadJPEGTurboImagenetteTrainingFiles2(imageSize: Int32) {
    let trainPaths = try! getURLS(datasetType: "train", imageSize: imageSize)
    return loadJPEGTurboDataset2(datasetPaths: trainPaths, imageSize: imageSize)
}

public extension Double {
    static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
}

