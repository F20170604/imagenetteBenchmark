//
//  main.swift
//  imagenetteBenchmark
//
//  Created by Ayush Agrawal on 28/05/20.
//  Copyright © 2020 Ayush Agrawal. All rights reserved.
//

import Foundation

print("Hello, World!")

//let trainImages = loadImagenetteTrainingFiles()
//print("Image Tensors Shape: \(trainImages.0.shape)")
//print("Label Tensors Shape: \(trainImages.1.shape)")
let newTrainPaths = createDataset(datasetType: "train")
