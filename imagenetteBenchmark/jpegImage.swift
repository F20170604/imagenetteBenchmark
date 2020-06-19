//
//  jpegImage.swift
//  imagenetteBenchmark
//
//  Created by Ayush Agrawal on 17/06/20.
//  Copyright © 2020 Ayush Agrawal. All rights reserved.
//

import Foundation
import TensorFlow
import JPEG

public struct jpegImage {
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
    let imageSize = 160
    public init(jpeg url: URL, byteOrdering: ByteOrdering = .rgb) {
        if byteOrdering == .bgr {
            // TODO: Add BGR byte reordering.
            fatalError("BGR byte ordering is currently unsupported.")
        } else {
            guard let image:JPEG.Data.Rectangular<JPEG.Common> = try! .decompress(path: url.path)
            else
            {
                fatalError("failed to open file '\(path)'")
            }
            //print(url.path)
            let width = image.size.x
            let height = image.size.y
            let rgb:[JPEG.RGB] = image.unpack(as: JPEG.RGB.self)
            let data = rgb.flatMap{ [$0.r, $0.g, $0.b] }
            let loadedTensor = Tensor<UInt8>(shape: [Int(height), Int(width), 3], scalars: data)
            self.imageData = .uint8(data: loadedTensor)
        }
    }

    public func resized(to size: (Int, Int)) -> jpegImage {
        switch self.imageData {
        case let .uint8(data):
            let resizedImage = resize(images: Tensor<Float>(data), size: size, method: .bilinear)
            return jpegImage(tensor: Tensor<UInt8>(resizedImage))
        case let .float(data):
            let resizedImage = resize(images: data, size: size, method: .bilinear)
            return jpegImage(tensor: resizedImage)
        }
    }
}
