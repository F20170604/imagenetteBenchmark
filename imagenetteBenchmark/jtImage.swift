//
//  jtImage.swift
//  imagenetteBenchmark
//
//  Created by Ayush Agrawal on 12/06/20.
//  Copyright © 2020 Ayush Agrawal. All rights reserved.
//

import Foundation
import TensorFlow
import libjpeg

public struct jtImage {
    public enum ByteOrdering {
        case bgr
        case rgb
    }

    public enum Colorspace {
        case rgb
        case grayscale
    }

    enum ImageTensor {
        case float(data: Tensor<Float>)
        case uint8(data: Tensor<UInt8>)
    }

    let imageData: ImageTensor

    public var tensor: Tensor<Float> {
        switch self.imageData {
        case let .float(data): return data
        case let .uint8(data): return Tensor<Float>(data)
        }
    }

    public init(tensor: Tensor<UInt8>) {
        self.imageData = .uint8(data: tensor)
    }

    public init(tensor: Tensor<Float>) {
        self.imageData = .float(data: tensor)
    }

    public init(jpeg url: URL, byteOrdering: ByteOrdering = .rgb) {
        if byteOrdering == .bgr {
            // TODO: Add BGR byte reordering.
            fatalError("BGR byte ordering is currently unsupported.")
        } else {
            guard FileManager.default.fileExists(atPath: url.path) else {
                // TODO: Proper error propagation for this.
                fatalError("File does not exist at: \(url.path).")
            }
            
            var width: Int32 = 0
            var height: Int32 = 0
            var pixelFormat: Int32 = 0
            var inSubsamp: Int32 = 0
//            guard let bytes = tjJPEGLoadImage(url.path, &width, 0, &height, &pixelFormat, &inSubsamp, 0) else {
//                // TODO: Proper error propagation for this.
//                fatalError("Unable to read image at: \(url.path).")
//            }
//            print(width)
//            print(height)
//            print(pixelFormat)
//            print(inSubsamp)
//
//            var data = [UInt8](UnsafeBufferPointer(start: bytes, count: Int(width * height * pixelFormat)))
//            tjFree(bytes)
//            var loadedTensor = Tensor<UInt8>(
//                shape: [Int(height), Int(width), Int(pixelFormat)], scalars: data)
//            if pixelFormat == 1 {
//                loadedTensor = loadedTensor.broadcasted(to: [Int(height), Int(width), 3])
//            }
//
//
//
            var imgDe = tjJPEGLoadImageCompressed(url.path, &width, 0, &height, &pixelFormat, &inSubsamp, 0)
//            print(width)
//            print(height)
//            print(pixelFormat)
//            print(inSubsamp)
            let data = [UInt8](UnsafeBufferPointer(start: imgDe, count: Int(width * height * 3)))
            tjFree(imgDe)
            let loadedTensor = Tensor<UInt8>(shape: [Int(height), Int(width), 3], scalars: data)
            self.imageData = .uint8(data: loadedTensor)
            imgDe = nil;
//            data = [UInt8](UnsafeBufferPointer(start: imgDe, count: 61538*2))
//            //tjFree(imgDe)
//            loadedTensor = Tensor<UInt8>(shape: [2, 61538], scalars: data)
//            print(loadedTensor)
//            let jpegFile = fopen(filenamepointer2, "wb")
//            let status = fwrite(imgDe, 61538, 1, jpegFile)
//            print(status)
        }
    }
    
    

    public func resized(to size: (Int, Int)) -> jtImage {
        switch self.imageData {
        case let .uint8(data):
            let resizedImage = resize(images: Tensor<Float>(data), size: size, method: .bilinear)
            return jtImage(tensor: Tensor<UInt8>(resizedImage))
        case let .float(data):
            let resizedImage = resize(images: data, size: size, method: .bilinear)
            return jtImage(tensor: resizedImage)
        }
    }
}
