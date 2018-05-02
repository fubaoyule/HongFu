//
//  QRCodeViewController.swift
//  FuTu
//
//  Created by Administrator1 on 29/9/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    let iconImage = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        initImageView()
        let avatarImage = UIImage(named: "FuTuLog")
        //createQRCode(info: "itms-services://?action=download-manifest&amp;url=https://s.beta.myapp.com/myapp/rdmexp/exp/file/comyidongdianwangame_1_59f51d55-8d76-4976-9949-a2602de5e040.plist", avatarImage: avatarImage!)
        
        _ = createQRCode(info: "http://appledownload.toobet0.com", avatarImage: avatarImage!)
        
    }
    
    func initImageView() -> Void {
        iconImage.frame = CGRect(x: 50, y: 50, width: 300, height: 300)
        self.view.addSubview(iconImage)
        
    }
    
    private func createQRCode(info: String, avatarImage: UIImage) -> UIImage {
        
        // 建立一个滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        // 重设滤镜的初始值
        qrFilter?.setDefaults()
        // 通过 KVC 设置滤镜的内容
        qrFilter?.setValue(info.data(using: String.Encoding.utf8, allowLossyConversion: true), forKey: "inputMessage")
        
        // 输出图像
        let ciImage = qrFilter?.outputImage
        // 打印生成图片的大小，生成的图像 23 * 23
        tlPrint(message: ciImage!.extent)
        // 过滤图像单色彩以及`形变`的滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        // 不能直接用 UIColor 转换，会崩溃
        //        colorFilter.setValue(UIColor.redColor().CIColor, forKey: "inputColor0")
        // 前景色
        colorFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        // 背景色
        colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        let transform = CGAffineTransform(scaleX: 5, y: 5)
        let transformImage = colorFilter?.outputImage?.transformed(by: transform)
        
        let codeImage = UIImage(ciImage: transformImage!)
        
        let QRCodeImage = insertAvatarImage(codeImage: codeImage, avatarImage: avatarImage)
        
        iconImage.image = QRCodeImage
        return QRCodeImage
    }
    
    // 合成头像图像
    private func insertAvatarImage(codeImage: UIImage, avatarImage: UIImage) -> UIImage {
        
        let size = codeImage.size
        // 1. 开启图像的上下文
        UIGraphicsBeginImageContext(size)
        
        // 2. 绘制二维码图像
        
        codeImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // 3. 计算头像的大小
        let w = size.width * 0.25
        let h = size.height * 0.25
        let x = (size.width - w) * 0.5
        let y = (size.height - h) * 0.5
        
        //图片的位置
        //avatarImage.draw(in: CGRect(x: x, y: y, width: w, height: h))
        avatarImage.draw(in: CGRect(x: x, y: y, width: 0, height: 0))
        
        // 4. 从上下文中取出图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        return image!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
