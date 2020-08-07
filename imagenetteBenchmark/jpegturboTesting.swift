//
//  jpegturboResting.swift
//  imagenetteBenchmark
//
//  Created by Ayush Agrawal on 12/06/20.
//  Copyright © 2020 Ayush Agrawal. All rights reserved.
//

import Foundation
import libjpeg
import TensorFlow
import PythonKit

let path = "/Users/ayush517/Downloads/tiger.jpg"
let url = (path as NSString).utf8String
let filenamepointer = UnsafeMutablePointer<Int8>(mutating: url)!

//func test3() {
//    var width: Int32 = 0
//    var height: Int32 = 0
//    var pixelFormat: Int32 = 0
//    var inSubsamp: Int32 = 0
//
//    let imgDe = tjJPEGLoadCompressedImage(filenamepointer, &width, 0, &height, &pixelFormat, &inSubsamp, 0)
////    print(imgDe)
////    let data = [UInt8](UnsafeBufferPointer(start: imgDe, count: Int(width * height * 3)))
////    tjFree(imgDe)
////    let loadedTensor = Tensor<UInt8>(shape: [Int(height), Int(width), 3], scalars: data)
////    var imgTensor = Tensor<Float>(loadedTensor)
////    imgTensor /= 255.0
////    showTensorImage(imgTensor)
//
//
//    let path3 = "/Users/ayush517/Downloads/savedBoooya.ppm"
//    let url3 = (path3 as NSString).utf8String
//    let filenamepointer3 = UnsafeMutablePointer<Int8>(mutating: url3)!
//
//    let status = tjSaveImage(filenamepointer3, imgDe, width, 0, height, 0, 0)
//    print(status)
//
//    let path4 = "/Users/ayush517/Downloads/savedBoooya.jpeg"
//    let url4 = (path4 as NSString).utf8String
//    let filenamepointer4 = UnsafeMutablePointer<Int8>(mutating: url4)!
//
//    let status2 = tjJPEGSaveImage(filenamepointer4, imgDe, width, 0, height, 0, inSubsamp, 0)
//    print(status2)
//}

func test4() {
//    let jpegFile = fopen(filenamepointer, "rb")
//    fseek(jpegFile, 0, SEEK_END)
//    let size = ftell(jpegFile)
//    print(size)

    let img = jtImage.init(jpeg: URL(string: path)!, byteOrdering: .rgb, imageFormat: .BGRA8888, channelCount: 4)
    let imgTensor = img.resized(to: (160, 160)).tensor / 255.0
    showTensorImage(imgTensor)
    let path = "/Users/ayush517/Downloads/jttiger.jpg"
    let url = URL(fileURLWithPath: path)
    img.save(to: url)
}

let plt = Python.import("matplotlib.pyplot")

public func oneAxes() -> PythonObject {
    plt.figure()
    return plt.subplot(1, 1, 1)
}

func showTensorImage<S> (_ image: Tensor<S>, title: String? = nil, pltAxes: PythonObject? = nil) where S: NumpyScalarCompatible {
    let numpyImage = image.makeNumpyArray()
    let axes = pltAxes ?? oneAxes()
    axes.imshow(numpyImage)
    axes.axis("off")
    if title != nil { axes.set_title(title!) }
    if pltAxes == nil { plt.show() }
}

func showNumpyImage (_ image: PythonObject) {
    let modImage = image / 255.0
    plt.imshow(modImage)
    plt.show()
}

let path2 = "/Users/ayush517/Downloads/turbosave.jpg"
let url2 = (path2 as NSString).utf8String
let filenamepointer2 = UnsafeMutablePointer<Int8>(mutating: url2)!
//
//public func test2() {
//    var width: Int32 = 0
//    var height: Int32 = 0
//    var pixelFormat: Int32 = 0
//
//    tjInitCompress()
//    tjInitDecompress()
//    tjInitTransform()
//
//    let imgBufSize = tjBufSize(640, 426, Int32(TJSAMP_444.rawValue))
//    print(imgBufSize)
//    let buffer = tjAlloc(Int32(imgBufSize))
//    print(buffer)
//
//    let imgBuf = tjGetErrorStr2(tjLoadImage(filenamepointer2, &width, 1, &height, &pixelFormat, 0))
//    print(imgBuf)
//    let str = String(cString: imgBuf!)
//    print(str)
//    print(width)
//    print(height)
//}
//
//public func turboImageSaveOperation() {
//    var width: Int32 = 0
//    var height: Int32 = 0
//    var pixelFormat: Int32 = 0
//
//    var jpegFile = fopen(filenamepointer, "rb")
//
//    if jpegFile == nil {
//        print("cant open")
//    }
//
//    print("filenamepointer \(filenamepointer)")
//    print("jpegfile \(jpegFile)")
//
//    fseek(jpegFile, 0, SEEK_END)
//    let size = ftell(jpegFile)
//    print(size)
//
//    var jpegBuf = tjAlloc(Int32(size))!
//    print("jpegBuf \(jpegBuf)")
//    print(type(of: jpegBuf))
//
//    let readFile = fread(jpegBuf, size, 1, jpegFile)
//    print(readFile)
//
//
//    let flags = TJFLAG_FASTDCT
//    let expImage = tjLoadImage(filenamepointer, &width, 0, &height, &pixelFormat, 0)
//
//    print(expImage)
//    print(width)
//    print(height)
//    print(pixelFormat)
//    let newUrl = URL(string: "/Users/ayush517/Downloads/turboSaved.jpeg")!
//    let status = tjSaveImage(newUrl.path, expImage, width, 0, height, pixelFormat, 0)
//    print(status)
//}
