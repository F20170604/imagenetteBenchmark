//
//  main.swift
//  imagenetteBenchmark
//
//  Created by Ayush Agrawal on 28/05/20.
//  Copyright © 2020 Ayush Agrawal. All rights reserved.
//

import Foundation
import Benchmark

print("Hello, World!")


let newTrainPaths = createDataset(datasetType: "train", numImagesPerClass: 100)
let newValPaths = createDataset(datasetType: "val", numImagesPerClass: 100)

benchmark("PIL Image Load operation", settings: .iterations(5)) {
    loadImagenetteTrainingFiles()
}

Benchmark.main()

//let trainImages = loadImagenetteTrainingFiles()
//print("Train Image Tensors Shape: \(trainImages.0.shape)")
//print("Train Label Tensors Shape: \(trainImages.1.shape)")
