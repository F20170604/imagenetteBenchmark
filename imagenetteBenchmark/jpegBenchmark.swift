//
//  jpegBenchmark.swift
//  imagenetteBenchmark
//
//  Created by Ayush Agrawal on 17/06/20.
//  Copyright © 2020 Ayush Agrawal. All rights reserved.
//

import Foundation
import TensorFlow

func getJPEGTensor(fromPath: URL, imageSize: Int) -> (Tensor<Float>, Int32) {
    //print(fromPath)
    let img = jpegImage(jpeg: fromPath)
    var imageTensor = img.resized(to: (imageSize, imageSize)).tensor / 255.0
    
    let label: Int32 = Int32(unwrappedLabelDict[parentLabel(url: fromPath)]!)
    
    imageTensor = imageTensor.reshaped(to: [1, imageSize, imageSize, 3])
    //print(imageTensor.shape)
    return (imageTensor, label)
}

func loadJPEGDataset(datasetPaths: [URL], imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>)  {
    
    var imageTensor: Tensor<Float>
    var labels: [Int32] = []
    
    var data = getJPEGTensor(fromPath: datasetPaths[0], imageSize: Int(imageSize))
    imageTensor = data.0
    labels.append(data.1)
    
    for path in datasetPaths[1..<datasetPaths.count] {
        //print(imagePath)
        data = getJPEGTensor(fromPath: path, imageSize: Int(imageSize))
        let tensor = data.0
        labels.append(data.1)
        imageTensor = Tensor(concatenating: [imageTensor, tensor], alongAxis: 0)
    }
    return (imageTensor, Tensor<Int32>(labels))
}

func loadJPEGImagenetteTrainingFiles(imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>) {
    let trainPaths = try! getURLS(datasetType: "train", imageSize: imageSize)
    return loadJPEGDataset(datasetPaths: trainPaths, imageSize: imageSize)
}

func loadJPEGImagenetteTestFiles(imageSize: Int32) -> (Tensor<Float>, Tensor<Int32>) {
    let valPaths = try! getURLS(datasetType: "val", imageSize: imageSize)
    return loadJPEGDataset(datasetPaths: valPaths, imageSize: imageSize)
}

// ------ After Remving steps 4 & 5 -------


func loadJPEGDataset2(datasetPaths: [URL], imageSize: Int32)  {
    
    for path in datasetPaths[0..<datasetPaths.count] {
        getJPEGTensor2(fromPath: path, imageSize: Int(imageSize))
    }
}

func getJPEGTensor2(fromPath: URL, imageSize: Int) {
    //print(fromPath)
    let img = jpegImage(jpeg: fromPath)
    let tensor = img.resized(to: (imageSize, imageSize)).tensor / 255.0
//    if Double.random < 0.01 {
//        let label: Int32 = Int32(unwrappedLabelDict[parentLabel(url: fromPath)]!)
//        showTensorImage(tensor, title: "\(label)", pltAxes: nil)
//    }
}

func loadJPEGImagenetteTrainingFiles2(imageSize: Int32) {
    let trainPaths = try! getURLS(datasetType: "train", imageSize: imageSize)
    return loadJPEGDataset2(datasetPaths: trainPaths, imageSize: imageSize)
}
