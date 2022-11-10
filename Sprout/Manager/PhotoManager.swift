//
//  PhotoManager.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import UIKit
import Photos
import ImageIO
import MobileCoreServices
import RxSwift
import RxCocoa
import YPImagePicker

struct PostPhotoModel {
    var url: URL
    var photoData: Data
}

final class PhotoManager: NSObject {
    static let shared = PhotoManager()
    
    var assetSubject: PublishSubject<[PHAsset]> = PublishSubject()
    var cameraPhotoSubject: PublishSubject<UIImage> = PublishSubject()
    var photoModelSubject: BehaviorSubject<[PostPhotoModel]> = BehaviorSubject(value: [])
    var disposeBag = DisposeBag()
    
    private override init() {
        super.init()
        bind()
    }
    
    deinit { }
    
}

extension PhotoManager {
    func bind() {
        //MARK: - 갤러리에서 사진 선택 시
        assetSubject
            .subscribe(onNext: { (assets) in
                var returnPhotoData: [PostPhotoModel] = []
                
                DispatchQueue.global().sync { [weak self] in
                    guard let `self` = self else { return }
                    
                    for asset in assets {

                        let width = asset.pixelWidth
                        let height = asset.pixelHeight
//                        DEBUG_LOG("assets.pixelWidth: \(width)")
//                        DEBUG_LOG("assets.pixelheight: \(height)")
                        
                        asset.requestContentEditingInput(with: nil) { (edit, info) in
                            guard let url = edit?.fullSizeImageURL else { return }
                            guard let originData = try? Data(contentsOf: url) else { return }
                            guard let originImage = UIImage(data: originData) else { return }
                            
                            var returnOriginData = Data()
                            
                            if url.absoluteString.contains("GIF") { // GIF 사진
                                
                                let originSize = originImage.size
                                let maxDataSize = 5242880 // 5 MB = 5,242,880 Byte
                                
                                let path = URL(fileURLWithPath: NSTemporaryDirectory())
                                let originFileURL = path.appendingPathComponent("originGIF.gif")
                                
                                //OriginData Size > 5MB ==>> Resize OriginData to 5MB Data
                                var originSuccess = false
                                
                                if originData.count > maxDataSize {
                                    
                                    let bestResizeWidth = self.calculateResizeWidth(originWidth: Int(originSize.width),
                                                                                    originSizeInBytes: originData.count,
                                                                                    maxSizeInBytes: maxDataSize)
                                    
                                    let bestEdgeSize: Double = originSize.width >= originSize.height ? bestResizeWidth : bestResizeWidth * Double(originSize.height / originSize.width)
                                    
                                    var tempData: Data?
                                    var tempDataSize = originData.count
                                    var tempEdgeSize = bestEdgeSize
                                    
                                    while tempDataSize > maxDataSize {
                                        originSuccess = self.resizeGIF(originData, fileURL: originFileURL, maxEdgeSize: tempEdgeSize)
                                        if originSuccess {
                                            if let data = try? Data(contentsOf: originFileURL) {
                                                tempData = data
                                                tempDataSize = data.count
                                                tempEdgeSize *= 0.9
                                            }
                                        }
                                    }
                                    
                                    if let originData = tempData { returnOriginData = originData }
                                    
                                } else {
                                    returnOriginData = originData
                                }
                                
                                returnPhotoData.append(PostPhotoModel(url: url, photoData: returnOriginData))
                                
                                
                            } else { // GIF 아닌 사진

                                let imageThumb: UIImage = self.getAssetThumbnail(asset: asset, size: CGSize(width: width, height: height))

                                var originThumb = UIImage()

                                if width > 600 {
                                    let originWidth: CGFloat = 600
                                    let originHeight: CGFloat = (originWidth * CGFloat(height)) / CGFloat(width)
                                    originThumb = imageThumb.resize(size: CGSize(width: originWidth, height: originHeight)) ?? UIImage()

//                                    DEBUG_LOG("600 resized thumbnail size: \(resizeThumb.size)")

                                } else {
                                    originThumb = imageThumb
                                }

                                DEBUG_LOG("GIF 아닌 사진: \(originThumb.jpegData(compressionQuality: 1.0) ?? Data())")
                                
                                returnOriginData = originThumb.jpegData(compressionQuality: 1.0) ?? Data()
                                
                                returnPhotoData.append(PostPhotoModel(url: url, photoData: returnOriginData))
                            }
                            
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    guard let `self` = self else { return }
                    if let value = try? self.photoModelSubject.value(), value.count < 2 {
                        self.photoModelSubject.onNext(value + returnPhotoData)
                    } else {
                        self.photoModelSubject.onNext(returnPhotoData)
                    }
                    
                }
                
            }).disposed(by: disposeBag)
        
        //MARK: - 카메라로 사진 찍을 시
        cameraPhotoSubject
            .subscribe(onNext: { [weak self] (image) in
                guard let `self` = self else { return }
                DEBUG_LOG("Camera Photo Image: \(image)")
                
                let url: URL = URL(string: "CAMERAPHOTO")!
                
                let originData = image.jpegData(compressionQuality: 1.0) ?? Data()
                
                let photoModel = PostPhotoModel(url: url, photoData: originData)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    guard let `self` = self else { return }
                    if let value = try? self.photoModelSubject.value() as [PostPhotoModel], value.count < 2 {
                        self.photoModelSubject.onNext(value+[photoModel])
                    } else {
                        self.photoModelSubject.onNext([photoModel])
                    }
                }
                
            }).disposed(by: disposeBag)
    }
    
    func showPicker(_ viewController: UIViewController, maxNumberOfItems: Int, nextViewController: UIViewController? = nil) {
     
        var config = YPImagePickerConfiguration()
        config.library.minNumberOfItems = 1
        config.library.maxNumberOfItems = maxNumberOfItems
        config.wordings.libraryTitle = "앨범"
        config.wordings.cameraTitle = "카메라"
        let nextWording = nextViewController == nil ? "완료" : "다음"
        config.wordings.next = nextWording
        config.wordings.cancel = "취소"
        config.targetImageSize = YPImageSize.cappedTo(size: 600)
        config.wordings.permissionPopup.title = "권한이 거부됨"
        config.wordings.permissionPopup.message = "[선택권한] 프로필 및 갤러리 사용을 위하여, 카메라 혹은 이미지 검색, 첨부 기능을 사용하려면 승인이 필요합니다."
        config.wordings.permissionPopup.cancel = "취소"
        config.wordings.permissionPopup.grantPermission = "설정 바로가기"
        config.startOnScreen = .library
        config.showsPhotoFilters = false
        config.hidesStatusBar = false
        config.library.defaultMultipleSelection = false
        //config.library.defaultMultipleSelection = maxNumberOfItems == 1 ? false : true
        config.library.preSelectItemOnMultipleSelection = false

        config.colors.tintColor = .signatureNWhite
        config.colors.multipleItemsSelectedCircleColor = UIColor.colorFromRGB(0x4b6293)
        
        let picker = YPImagePicker(configuration: config)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .signatureNWhite
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 17),
                                                            .foregroundColor: UIColor.signatureNWhite]
        
        YPImagePickerConfiguration.shared = config
        
        viewController.present(picker, animated: true, completion: nil)
        
        picker.didFinishPicking { [unowned picker, weak self] items, cancelled in
            
            guard let `self` = self else {return}
            guard !cancelled else {
                DEBUG_LOG("cancelled Picker")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            var photos: [PHAsset] = []
            var cameraImage: UIImage?
            
            for item in items {
                
                switch item {
                    
                case .photo(let photo):
                    
                    if let asset = photo.asset {
                        photos.append(asset)
                        
                    } else { // 카메라로 사진 찍을 시
                        cameraImage = photo.originalImage
                    }
                    
                default : break
                }
            }
            
            if photos.count > 0 {
                PhotoManager.shared.assetSubject.onNext(photos)
            }
            
            if let image = cameraImage {
                PhotoManager.shared.cameraPhotoSubject.onNext(image)
            }
            
            if let nextViewController = nextViewController {
                self.photoModelSubject.onNext([])
                picker.pushViewController(nextViewController, animated: true)
            } else {
                picker.dismiss(animated: true)
            }
            
        }
    }
    
    @objc func dismissAction() {
        
    }
}

extension PhotoManager {
    
    //MARK: - GIF Resize Method
    
    //MARK: -
    func calculateResizeWidth(originWidth: Int, originSizeInBytes: Int, maxSizeInBytes: Int) -> Double {
        let ratioDiff = Double(maxSizeInBytes)/Double(originSizeInBytes)
        //return Double(originWidth) * ( ratioDiff + ((1-ratioDiff)/3))
        return Double(originWidth) * ( ratioDiff )
    }
    
    //MARK: -
    func resizeGIF(_ data:Data, fileURL:URL, maxEdgeSize:Double) -> Bool {
        let options = [kCGImageSourceShouldCache as String:false,
            kCGImageSourceTypeIdentifierHint as String:kUTTypeGIF] as [String : Any]
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, options as CFDictionary?) else {
            return false
        }
        let numberOfFrames = CGImageSourceGetCount(imageSource)
        
        guard let destination = CGImageDestinationCreateWithURL(fileURL as CFURL, kUTTypeGIF, numberOfFrames, nil) else {
            return false
        }
        let fileProperties = [kCGImagePropertyGIFDictionary as String:[kCGImagePropertyGIFLoopCount  as String:0]]
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary?)
        
        let newOptions = [kCGImageSourceShouldCache as String:false,
            kCGImageSourceTypeIdentifierHint as String:kUTTypeGIF,
            kCGImageSourceCreateThumbnailFromImageIfAbsent as String:true,
            kCGImageSourceThumbnailMaxPixelSize as String:maxEdgeSize] as [String : Any]
        
        for index in 0..<numberOfFrames {
            autoreleasepool {
                let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil)
                if let imageRef = CGImageSourceCreateThumbnailAtIndex(imageSource, index, newOptions as CFDictionary?) {
                    CGImageDestinationAddImage(destination, imageRef, properties)
                }
            }
        }
        
        if (!CGImageDestinationFinalize(destination)) {
            NSLog("failed to finalize image destination");
            return false
        }
        return true
    }
    
    //MARK: - JPG Resize Method
    func getAssetThumbnail(asset: PHAsset, size: CGSize) -> UIImage {
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()

        var thumbnail = UIImage()
        option.isSynchronous = true

//        manager.requestImageData(for: asset, options: option) { (data, uti, orientation, info) in
//
//            guard let data = data else { return }
//
//            let bcf = ByteCountFormatter()
//            bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
//            bcf.countStyle = .file
//            let string = bcf.string(fromByteCount: Int64(data.count))
//            DEBUG_LOG("formatted result: \(string)")
//        }
        
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: { (result, info) -> Void in
            if let resultImage = result{
                
                DEBUG_LOG("info: \(info.debugDescription)")
                thumbnail = resultImage
            }else{
                DEBUG_LOG("getAssetThumbnail failed!!\n info: \(info.debugDescription)")
            }
        })
        return thumbnail
    }
    
    func dataWithRotateImage(image: UIImage) -> (Data, Data) {
        
        let width = image.size.width
        let height = image.size.height
        
        var origin = UIImage()
        var resize = UIImage()

        if width > 600 {
            let originWidth: CGFloat = 600
            let originHeight: CGFloat = (originWidth * CGFloat(height)) / CGFloat(width)
            origin = image.resize(size: CGSize(width: originWidth, height: originHeight)) ?? UIImage()

        } else {
            origin = image
        }

        let resizeWidth: CGFloat = 200
        let resizeHeight: CGFloat = (resizeWidth * CGFloat(height)) / CGFloat(width)
        resize = image.resize(size: CGSize(width: resizeWidth, height: resizeHeight)) ?? UIImage()

        guard let originData = origin.jpegData(compressionQuality: 1.0),
              let resizeData = resize.jpegData(compressionQuality: 1.0) else { return (Data(count: 0), Data(count: 0))}
        
        return (originData, resizeData)
    }
    
}

//MARK: - Rotation
extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
