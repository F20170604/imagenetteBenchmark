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

let classNames = ["n01440764", "n02102040", "n02979186", "n03000684", "n03028079",
"n03394916", "n03417042", "n03425413", "n03445777", "n03888257"]

let datasetPath = "/Users/ayush517/subsetImagenette320"

let newTrainPaths = create320Dataset(datasetType: "train", numImagesPerClass: 100)
let newValPaths = create320Dataset(datasetType: "val", numImagesPerClass: 100)

benchmark("PIL Image Load operation", settings: .iterations(5)) {
    loadImagenetteTrainingFiles()
}

Benchmark.main()

//let trainImages = loadImagenetteTrainingFiles()
//print("Train Image Tensors Shape: \(trainImages.0.shape)")
//print("Train Label Tensors Shape: \(trainImages.1.shape)")
