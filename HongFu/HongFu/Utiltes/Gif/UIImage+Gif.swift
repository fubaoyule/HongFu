//
//  Gif.swift
//  SwiftGif
//
//  Created by Arne Bahlo on 07.06.14.
//  Copyright (c) 2014 Arne Bahlo. All rights reserved.
//

import UIKit
import ImageIO

extension UIImage {

    public class func gifWithData(data: NSData) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source: source)
    }

    public class func gifWithURL(gifUrl:String) -> UIImage? {
        // Validate URL
        guard let bundleURL:NSURL = NSURL(string: gifUrl) else {
                tlPrint(message: "SwiftGif: This image named \"\(gifUrl)\" does not exist")
                return nil
        }
        
        

        // Validate data
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            tlPrint(message: "SwiftGif: Cannot turn image named \"\(gifUrl)\" into Data")
            return nil
        }

        return gifWithData(data: imageData)
    }

    public class func gifWithName(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gifWithData(data: imageData)
    }

    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
//        let gifProperties: CFDictionary = unsafeBitCast(
//            CFDictionaryGetValue(cfProperties,
//                unsafeAddressOf(kCGImagePropertyGIFDictionary)),
//            to: CFDictionary.self)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)

        // Get delay time
//        var delayObject: AnyObject = unsafeBitCast(
//            CFDictionaryGetValue(gifProperties,
//                unsafeAddressOf(kCGImagePropertyGIFUnclampedDelayTime)),
//            to: AnyObject.self)
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
//            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
//                unsafeAddressOf(kCGImagePropertyGIFDelayTime)), to: AnyObject.self)
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        delay = delayObject as! Double

        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }

    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            //gcd = UIImage.gcdForPair(val, gcd)
            gcd = UIImage.gcdForPair(a: val, gcd)
        }

        return gcd
    }

    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
            }()

        // Get frames
        let gcd = gcdForArray(array: delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)

        return animation
    }

}

/*
*

//example

let jeremyGif = UIImage.gifWithName("jeremy")
let imageView = UIImageView(image: jeremyGif)
imageView.frame = CGRect(x: 0.0, y: 20.0, width: 350.0, height: 202.0)
view.addSubview(imageView)


let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("adventure-time", withExtension: "gif")!)
let advTimeGif = UIImage.gifWithData(imageData!)
let imageView2 = UIImageView(image: advTimeGif)
imageView2.frame = CGRect(x: 0.0, y: 222.0, width: 350.0, height: 202.0)

view.addSubview(imageView2)



*/
