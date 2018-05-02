//: Playground - noun: a place where people can play

import UIKit

//var str = "Hello, playground"

//let noticeString = "[{\"Title\":\"鸿福首推签名送钱活动\",\"Content\":\"每日签到轻松换积分，积分可兑换金钱，欢迎新老朋友参与！\",\"CreateTime\":\"2018年1月4日\"},{\"Title\":\"鸿福首推签名送钱活动\",\"Content\":\"每日00000，积分可兑换金钱，欢迎新老朋友参与！\",\"CreateTime\":\"2018年1月4日\"}] "
//var sourceArray2:Array<String> = [""]
//var sourceArray = noticeString.components(separatedBy: "\",\"CreateTime\"")
//for i in 0 ..< sourceArray.count {
//    sourceArray[i]
//    let sourceSubArray = sourceArray[i].components(separatedBy: "\"Content\":\"")
//    if sourceSubArray.count >= 2 {
//        sourceSubArray[1]
//        sourceArray2.append(sourceSubArray[1])
//    }
//}
//sourceArray2.removeFirst()
//sourceArray2
//
//var testString: String!
//var test2 = "123"
//do {
//     try test2 = testString
//} catch {
//    print("error:")
//}

"0800:00:00" > "0800:00:01"
"2.1.3" > "2.1.2"


let dateFormatter = DateFormatter()
dateFormatter.locale = Locale(identifier: "en_EN")
dateFormatter.setLocalizedDateFormatFromTemplate("dd")
let dateStr = dateFormatter.string(from: Date())
Int(dateStr)!

//let data2 = "<e99499e8 afafe79a 84e8afb7 e6b182>"
//var string = String(data: Data(data2), encoding: String.Encoding.utf8)
let temp = "sdddfsdf"
String(temp[temp.range(of: "ddf")!.lowerBound])

let date1 = Optional("2018/04/25")
let date2 = Optional("2018/04/25")
let dataArray1 = date1?.components(separatedBy: "/")
let dataArray2 = date2?.components(separatedBy: "/")
