//
//  ViewController.swift
//  photomaster
//
//  Created by 八森聖人 on 2022/05/12.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBAction func onTappedCameraButton(_ sender: UIButton) {
        presentPickerController(sourceType: .camera)
    }
    
    @IBAction func onTappedAlbumButton(_ sender: UIButton) {
        presentPickerController(sourceType: .photoLibrary)
    }
    
    @IBAction func onTappedTextButton(_ sender: UIButton) {
        if photoImageView.image != nil {
            photoImageView.image = drawText(image: photoImageView.image!)
        } else {
            print("画像がありません")
        }
    }
    
    @IBAction func onTappedIllustButton(_ sender: UIButton) {
        if photoImageView.image != nil {
            photoImageView.image = drawMaskImage(image: photoImageView.image!)
        } else {
            print("画像がありません")
        }
    }

    @IBAction func onTappedUploadButton(_ sender: UIButton) {
        if photoImageView.image != nil {
            // 共有するアイテムを設定
            let activityVC = UIActivityViewController(activityItems: [photoImageView.image!, "#PhotoMaster"], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        } else {
            print("画像がありません")
        }
    }
    
    // カメラ、アルバムの呼び出しメソッド(カメラ or アルバムのソースタイプが引数)
    func presentPickerController(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    // 写真が選択されたときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info :[UIImagePickerController.InfoKey: Any]) {
        self.dismiss(animated: true, completion: nil)
        
        // 画像を出力
        photoImageView.image = info[.originalImage] as? UIImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 元の画像にテキストを合成するメソッド
    func drawText(image: UIImage) -> UIImage {
        //テキストの内容の設定
        let text = "LifeIsTech!"
        
        // textFontAttributes: 文字のスタイルの設定
        let textFontAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 120)!,
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        
        // グラフィックスコンテキスト生成, 編集を開始
        UIGraphicsBeginImageContext(image.size)
        
        // 読み込んだ写真を書き出す
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // CGRect
        let margin: CGFloat = 5.0
        let textRect = CGRect(x: margin, y: margin, width: image.size.width - margin, height: image.size.height - margin)
        
        // テキスト描画
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        // グラフィックスコンテキストの画像を取得
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // 元の画像にイラストを合成するメソッド
    func drawMaskImage(image: UIImage) -> UIImage {

        // マスク画像
        let maskImage = UIImage(named: "furo_ducky")!
        
        UIGraphicsBeginImageContext(image.size)
        
        // 読み込んだ写真を書き出す
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // CGRect
        let margin: CGFloat = 50.0
        let maskRect = CGRect(
            x: image.size.width - maskImage.size.width - margin,
            y: image.size.height - maskImage.size.height - margin,
            width: maskImage.size.width,
            height: maskImage.size.height
        )
        
        // テキスト描画
        maskImage.draw(in: maskRect)
        
        // グラフィックスコンテキストの画像を取得
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

