//
//  GameModel.swift
//  FuBao
//
//  Created by Administrator1 on 1/7/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

enum gameViewBtnTag:Int {
    //buttons
    case Game_MGRecordBtnTag = 10,Game_BS_homeBtnTag
}

class GameModel: NSObject {
    
    let mgRecordPath = "Game/GetMGPlayerBetUrl"
    
    func getMGRecordURL(success:@escaping(String)->(),failure:@escaping(()->())) -> Void {
        tlPrint(message: "getMGRecordURL")
        futuNetworkRequest(type: .get, serializer: .http, url: mgRecordPath, params: ["":""], success: { (response) in
            tlPrint(message: response)
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint(message: string)
            string = string!.replacingOccurrences(of: "\"", with: "")
            string = string!.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "string:\(String(describing: string))")
            if string == "failed" || string == "\"Failed\"" || string == "\"null\"" {
                tlPrint(message: "error string: \(String(describing: string))")
                failure()
                return
            }
            
            success(string!)
            
        }) { (error) in
            tlPrint(message: error)
        }
    }
}
//bm.thelinear@proexcel.com.ph
