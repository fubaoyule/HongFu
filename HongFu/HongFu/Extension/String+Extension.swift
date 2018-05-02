//
//  String+Extension.swift
//  FuTu
//
//  Created by Administrator1 on 23/9/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import Foundation

//========================
//Mark:- 字符串的加密扩展
//========================
enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}



extension String  {
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        return stringFromBytes(bytes: result, length: digestLen)
    }
    
    var sha1: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA1(str!, strLen, result)
        return stringFromBytes(bytes: result, length: digestLen)
    }
    
    var sha256String: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA256(str!, strLen, result)
        return stringFromBytes(bytes: result, length: digestLen)
    }
    
    var sha512String: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA512_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA512(str!, strLen, result)
        return stringFromBytes(bytes: result, length: digestLen)
    }
    
    func stringFromBytes(bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String{
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", bytes[i])
        }
        bytes.deallocate(capacity: length)
        return String(format: hash as String)
    }
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result: result, length: digestLen)
        
        result.deallocate(capacity: digestLen)
        
        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    

    
    func changeStringToDictionary(string : String)->NSDictionary{
        
        let dic: NSMutableDictionary = NSMutableDictionary()
        
        let array = string.components(separatedBy: "&")
        
        for str : String in array{
            
            let tempArray = str.components(separatedBy: "=")
            
            dic.setObject(tempArray[1], forKey: tempArray[0] as NSCopying)
            
        }
        return dic
    }
    
    func changeDictionaryToJson(dict: Dictionary<String,Any>) -> String {
        
        var strJson = ""
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            strJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
        }
        return strJson
    }
    
    
    func dataToDictonary(data:Data) -> Dictionary<String,Any> {
        
        let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as! Dictionary<String,Any>
        return dictionary
    }
    
    func dataToArray(data:Data) -> Array<Any> {
        
        let array = NSKeyedUnarchiver.unarchiveObject(with: data) as! Array<Any>
        return array
    }

    
    //将字典类型的制服串转化为字典类型
    func toDictionary(dicString: String) -> Dictionary<String,Any>? {
        tlPrint(message: "dicString:\(dicString)")
        var dictonary:NSDictionary?
        if let data = dicString.data(using: String.Encoding.utf8) {
            do {
                dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                
                if let myDictionary = dictonary {
                    return myDictionary as? Dictionary<String, Any>
                }
            } catch let error as NSError {
                print(error)
                tlPrint(message: "error code: \(error)")
            }
        }
        return nil
    }
    
    
    

    
    
    
    
    
    //Json 转换
//    func changeJsonToDictonary(user: AnyObject) {
//        
//        //使用 JSONKit 转换成为 JSON 字符串
//        let jsonstring = user.jsonString()
//        //print(jsonstring)
//        //由字符串反解析回字典
//        print(jsonstring?.objectFromJSONString() as! NSDictionary)
//        
//        //使用 JSONKit 转换成为 NSData 类型的 JSON 数据
//        let jsondata = (user as! NSDictionary).jsonData() as NSData
//        tlPrint(message: jsondata);
//        //由NSData 反解析回为字典
//        tlPrint(message: jsondata.objectFromJSONData() as! NSDictionary)
//    }
    
    
//    func subString(str: String, fromIndex:Int, offset:Int) -> String {
//    
//        let subString:String = ""
//        _ = str.index(str.startIndex, offsetBy: 3)
//        
//        return subString
//        
//    }
    
    static func stringToCGFloat(string:String) -> CGFloat {
        let string = string
        var cgFloat: CGFloat = 0
        if let doubleValue = Double(string)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    
    static func stringToInt(str:String)->(Int){
        
        let string = str
        var int: Int?
        if let doubleValue = Int(string) {
            int = Int(doubleValue)
        }
        if int == nil
        {
            return 0
        }
        return int!
    }
    
//    func isChiness(str:String) -> Bool {
//        for i in 0 ..< str.characters.count {
//            let char = str.sucString(str: str, fromIndex: i, offset: 1)
//            if strlen(char) == 3 {
//                return true
//            }
//                
//            }
//        }
//    }
}
