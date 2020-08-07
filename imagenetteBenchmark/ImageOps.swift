//
//  ImageOps.swift
//  imagenetteBenchmark
//
//  Created by Ayush Agrawal on 25/07/20.
//  Copyright © 2020 Ayush Agrawal. All rights reserved.
//

import Foundation
import libjpeg

public enum pixelFormats: Int32 {
    case RGB888 = 0     // TJPF_RGB
    case BGR888 = 1      // TJPF_BGR
    case RGBA8888 = 2 // TJPF_RGBA
    case BGRA8888 = 3 // TJPF_BGRA
    case ARGB8888 = 4 // TJPF_ARGB
    case ABGR8888 = 5 // TJPF_ABGR
    case RGBA8880 = 6 // TJPF_RGBX
    case BGRA8880 = 7 // TJPF_BGRX
    case ARGB0888 = 8 // TJPF_XRGB
    case ABGR0888 = 9 // TJPF_XBGR
    case YUV400 = 10     // TJPF_GREY
    
    var channelCount: Int32 {
       switch self {
       case .RGB888:
        return 3
       case .BGR888:
        return 3
       case .RGBA8888:
        return 4
       case .BGRA8888:
        return 4
       case .ARGB8888:
        return 4
       case .ABGR8888:
        return 4
       case .RGBA8880:
        return 3
       case .BGRA8880:
        return 3
       case .ARGB0888:
        return 3
       case .ABGR0888:
        return 3
       case .YUV400:
        return 1
       }
    }
}

public struct ImageData {
    var height: Int32
    var width: Int32
    var data: UnsafeMutablePointer<UInt8>
    var formatProperties: pixelFormats
    
//    public enum pixelFormats: Int32 {
//        case RGB888     // TJPF_RGB
//        case BGR888      // TJPF_BGR
//        case RGBA8888 // TJPF_RGBA
//        case BGRA8888 // TJPF_BGRA
//        case ARGB8888 // TJPF_ARGB
//        case ABGR8888 // TJPF_ABGR
//        case RGBA8880 // TJPF_RGBX
//        case BGRA8880 // TJPF_BGRX
//        case ARGB0888 // TJPF_XRGB
//        case ABGR0888 // TJPF_XBGR
//        case YUV400     // TJPF_GREY
//    }
    
    
    init(height: Int32, width: Int32, data: UnsafeMutablePointer<UInt8>, imageFormat: pixelFormats) {
        self.height = height
        self.width = width
        self.data = data
        self.formatProperties = imageFormat
    }
}

func LoadJPEG(atPath path: String, imageFormat: pixelFormats) -> ImageData? {
    
    /* Read the JPEG file into memory. */
    var jpegFile = fopen(path, "rb")
    fseek(jpegFile, 0, SEEK_END)
    let size = ftell(jpegFile)
    fseek(jpegFile, 0, SEEK_SET)
    let jpegSize = CUnsignedLongLong(size)
    //print(size)
    var jpegBuf = (tjAlloc(Int32(jpegSize)))
    fread(jpegBuf, Int(jpegSize), 1, jpegFile)
    fclose(jpegFile)
    jpegFile = nil
    
    var width: Int32 = 0
    var height: Int32 = 0
    
    var tjInstance = tjInitDecompress()
    /* Initializes `width` and `height` variables */
    tjDecompressHeader(tjInstance, jpegBuf, UInt(jpegSize), &width, &height)
    
    let imgBuf = tjAlloc(imageFormat.channelCount * width * height)
    
    //print(3*width*height)
    
    /* Decompresses the JPEG Image from `jpegBuf` into `imgBuf` buffer
        - Decompresses `jpegBuf` which has image data
        - uses `jpegSize` as size of image in bytes
        - Image gets decompressed into `imgBuf` buffer
        - `width` = width of Image
        - pitch = 0
        - `height` = height of image
        - pixelFormat = 0 which denotes TJPF_RGB Pixel Format to which image is being decompressed.
        - flags = 0
    */
    tjDecompress2(tjInstance, jpegBuf, UInt(jpegSize), imgBuf, width, 0, height, imageFormat.rawValue, 0)
    
    /* Free/Destroy instances and buffers */
    tjFree(jpegBuf)
    jpegBuf = nil
    tjDestroy(tjInstance)
    tjInstance = nil
    
    let res = ImageData.init(height: height, width: width, data: imgBuf!, imageFormat: imageFormat)
    return res
    
}

func SaveJPEG(atPath path : String, image: ImageData) -> Int32 {
    
    /* Create new file */
    var jpegFile = fopen(path, "wb")
    var jpegBuf: UnsafeMutablePointer<UInt8>?
    
    var retVal: Int32 = -1
    let outQual: Int32 = 95
    var jpegSize: CUnsignedLong = 0
    
    var tjInstance = tjInitCompress();
    /* Compress the Image Data from `buffer` into `jpegBuf`
        - Compresses image.data
        - `width` = width of Image
        - pitch = 0
        - `height` = height of image
        - `pixelFormat` = 0
        - Image gets compressed into `jpegBuf` buffer
        - initializes `jpegSize` as size of image in bytes
        - `outSubsamp` = 0
        - `outQual` = the image quality of the generated JPEG image (1 = worst, 100 = best), 95 taken as default
        - `flags` = 0
    */
    tjCompress2(tjInstance, image.data, image.width, 0, image.height, image.formatProperties.rawValue, &jpegBuf, &jpegSize, 0, outQual, 0)
    
    if (fwrite(jpegBuf, Int(jpegSize), 1, jpegFile) == 1){
        retVal = 0
    }
    
    /* Free/Destroy instances and buffers */
    tjDestroy(tjInstance)
    tjInstance = nil
    fclose(jpegFile)
    jpegFile = nil
    tjFree(jpegBuf)
    jpegBuf = nil
    
    return retVal;
}
