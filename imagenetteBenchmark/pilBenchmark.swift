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

func loadDataset(datasetPaths: [String]) -> (Tensor<Float>, Tensor<Int32>)  {
    
    var imageTensor: Tensor<Float>
    var labels: [Int32] = []
    
    var data = getTensor(fromPath: datasetPaths[0])
    imageTensor = data.0
    labels.append(data.1)
    
    for path in datasetPaths[1..<datasetPaths.count] {
        //print(imagePath)
        data = getTensor(fromPath: path)
        let tensor = data.0
        labels.append(data.1)
        imageTensor = Tensor(concatenating: [imageTensor, tensor], alongAxis: 0)
    }
    return (imageTensor, Tensor<Int32>(labels))
}

func test(datasetType: String) throws -> [URL] {
    let path = datasetPath+"/\(datasetType)"
    let url = URL(string: path)!
    //print(url)
    let dirContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
    //print(dirContents)
    var urls: [URL] = []
    for directoryURL in dirContents {
        let subdirContents = try FileManager.default.contentsOfDirectory(
            at: directoryURL, includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles])
        //print(subdirContents)
        urls += subdirContents
    }
    return urls
}

func getTrainPaths() throws -> [String] {
    let urls = try test(datasetType: "train")
    return urls.map{$0.absoluteString.components(separatedBy: "//")[1]}
}

func getValPaths() throws -> [String] {
    let urls = try test(datasetType: "val")
    return urls.map{$0.absoluteString.components(separatedBy: "//")[1]}
}

func loadImagenetteTrainingFiles() -> (Tensor<Float>, Tensor<Int32>) {
    let trainPaths = try! getTrainPaths()
    return loadDataset(datasetPaths: trainPaths)
}

func loadImagenetteTestFiles() -> (Tensor<Float>, Tensor<Int32>) {
    let valPaths = try! getValPaths()
    return loadDataset(datasetPaths: valPaths)
}
