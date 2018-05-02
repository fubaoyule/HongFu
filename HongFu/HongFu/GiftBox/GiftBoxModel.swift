//
//  GiftBoxModel.swift
//  FuBao
//
//  Created by Administrator1 on 4/8/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

enum giftBoxTag: Int{
    case backBtnTag = 10,boxBtnTag, boxTapTag, getBtnTag,shadowViewTapTag,alergGetBtnTag
}


class GiftBoxModel: NSObject {

    func getGiftBox(success:@escaping((Dictionary<String,Any>))->(),failure:@escaping(()->())) -> Void {
        tlPrint(message: "getGiftBox")
        let giftBoxUrl = "Active/GrabValidGiftBox"
        futuNetworkRequest(type: .get, serializer: .http, url: giftBoxUrl, params: ["":""], success: { (response) in
            tlPrint(message: "response:\(response)")
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            string = string!.replacingOccurrences(of: "\"{", with: "{")
            string = string!.replacingOccurrences(of: "}\"", with: "}")
            string = string!.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "string:\(String(describing: string))")
            if string == "Failed" || string == "\"Failed\"" || string == "\"null\"" {
                tlPrint(message: "error string: \(String(describing: string))")
                failure()
                return
            }
            
            let resultDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
            success(resultDic)
            
        }) { (error) in
            tlPrint(message: "error:\(error)")
            failure()
        }
    }
}





