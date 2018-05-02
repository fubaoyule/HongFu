//
//  TreasureBoxModel.swift
//  FuTu
//
//  Created by Administrator1 on 17/8/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit


enum TreasureBoxTag:Int {
    case TreasureBackBtnTag = 50,ResultMaskViewTapTag,ResultLightViewTapTag,alertConfirmBtnTag
    case TreasureBoxViewTag = 80
}

class TreasureBoxModel: NSObject {

    //打开宝箱接口请求函数
    func getTreasureBoxInfo(success:@escaping((Dictionary<String,Any>))->(),failure:@escaping(()->())) -> Void {
        
        let url = "Active/GrabGoldenBox"
        futuNetworkRequest(type: .get, serializer: .http, url: url, params: nil, success: { (response) in
            tlPrint(message: response)
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
            tlPrint(message: error)
        }
    }
    
    
    
    
    
    
}
