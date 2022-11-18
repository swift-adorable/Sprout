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

struct Photo {
    var url: URL
    var data: (origin: Data, resize: Data)
}

final class PhotoManager: NSObject {
    static let shared = PhotoManager()
    private var maxNumberOfItems: Int = 1
    private var asset: PublishSubject<[PHAsset]> = PublishSubject()
    var cameraPhoto: PublishSubject<[UIImage]> = PublishSubject()
    var photo: BehaviorSubject<[Photo]> = BehaviorSubject(value: [])
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
        asset.subscribe(onNext: { (assets) in
                var returnPhotoData: [Photo] = []
                
                DispatchQueue.global().sync { [weak self] in
                    guard let `self` = self else { return }
                    
                    for asset in assets {

                        let width = asset.pixelWidth
                        let height = asset.pixelHeight
                        
                        asset.requestContentEditingInput(with: nil) { (edit, info) in
                            guard let url = edit?.fullSizeImageURL else { return }
                            guard let originData = try? Data(contentsOf: url) else { return }
                            guard let originImage = UIImage(data: originData) else { return }
                            
                            guard width > 80 else {
                                //DEBUG_LOG("PHAsset Image width is less than 80!!")
                                returnPhotoData.append(Photo(url: url,
                                                             data: (origin: originData, resize: originData)))
                                return
                            }
                            
                            var returnOriginData = Data()
                            var returnThumbData = Data()
                            
                            //MARK: GIF 사진
                            if let identifier = edit?.uniformTypeIdentifier, identifier == kUTTypeGIF as String {
                                
                                let originSize = originImage.size
                                let maxDataSize = 5242880 // 5 MB = 5,242,880 Byte
                                
                                let path = URL(fileURLWithPath: NSTemporaryDirectory())
                                let originFileURL = path.appendingPathComponent("originGIF.gif")
                                let thumbFileURL = path.appendingPathComponent("thumbGIF.gif")
                                
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
                                
                                //Resize To Thumbnail GIF Image
                                let thumbMaxEdgeSize: Double = originSize.width >= originSize.height ? 80 : 80 * Double(originSize.height / originSize.width)
                                
                                let thumbSuccess = self.resizeGIF(returnOriginData, fileURL: thumbFileURL, maxEdgeSize: thumbMaxEdgeSize)
                                if thumbSuccess {
                                    if let thumbData = try? Data(contentsOf: thumbFileURL) {
                                        returnThumbData = thumbData
                                    }
                                }
                                DEBUG_LOG("GIF 사진 원본: \(originData)")
                                DEBUG_LOG("GIF 사진 원본 with 리사이징 5MB: \(returnOriginData)")
                                DEBUG_LOG("GIF 사진 리사이즈: \(returnThumbData)")
                                returnPhotoData.append(Photo(url: url,
                                                             data: (origin: returnOriginData, resize: returnThumbData)))
                                
                            //MARK: GIF 아닌 사진
                            } else {

                                let imageThumb: UIImage = self.getAssetThumbnail(asset: asset,
                                                                                 size: CGSize(width: width, height: height))

                                var originThumb = UIImage()
                                var resizeThumb = UIImage()

                                if width > 600 {
                                    let originWidth: CGFloat = 600
                                    let originHeight: CGFloat = (originWidth * CGFloat(height)) / CGFloat(width)
                                    originThumb = imageThumb.resize(size: CGSize(width: originWidth, height: originHeight)) ?? UIImage()

//                                    DEBUG_LOG("600 resized thumbnail size: \(resizeThumb.size)")

                                } else {
                                    originThumb = imageThumb
                                }

                                let resizeWidth: CGFloat = 80
                                let resizeHeight: CGFloat = (resizeWidth * CGFloat(height)) / CGFloat(width)
                                resizeThumb = imageThumb.resize(size: CGSize(width: resizeWidth, height: resizeHeight)) ?? UIImage()

                                DEBUG_LOG("GIF 아닌 사진 원본: \(imageThumb.size)")
                                DEBUG_LOG("GIF 아닌 사진 원본 by 리사이징 600px: \(originThumb.size)")//.jpegData(compressionQuality: 1.0) ?? Data())")
                                DEBUG_LOG("GIF 아닌 사진 리사이즈: \(resizeThumb.size)")//.jpegData(compressionQuality: 1.0) ?? Data())")
                                
                                returnOriginData = originThumb.jpegData(compressionQuality: 1.0) ?? Data()
                                returnThumbData = resizeThumb.jpegData(compressionQuality: 1.0) ?? Data()
                                
                                returnPhotoData.append(Photo(url: url,
                                                             data: (origin: returnOriginData, resize: returnThumbData)))
                            }
                            
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    guard let `self` = self else { return }
                    if self.maxNumberOfItems == 1 {
                        self.photo.onNext(returnPhotoData)
                    } else {
                        if let value = try? self.photo.value(), value.count < 2 {
                            self.photo.onNext(value + returnPhotoData)
                        } else {
                            self.photo.onNext(returnPhotoData)
                        }
                    }
                    
                }
                
            }).disposed(by: disposeBag)
        
        //MARK: - 카메라로 사진 찍을 시
        cameraPhoto
            .subscribe(onNext: { [weak self] (images) in
                guard let `self` = self else { return }
                
                var photoModel: [Photo] = []
                
                for image in images {
                    
                    let originSize = image.size
                    
                    let resizeWidth: CGFloat = 80
                    let resizeHeight: CGFloat = (resizeWidth * CGFloat(originSize.height)) / CGFloat(originSize.width)
                    let resizeThumb = image.resize(size: CGSize(width: resizeWidth, height: resizeHeight)) ?? UIImage()
                    
                    let url: URL = URL(string: "CAMERAPHOTO")!
                    
                    let originData = image.jpegData(compressionQuality: 1.0) ?? Data()
                    let resizeData = resizeThumb.jpegData(compressionQuality: 1.0) ?? Data()
                    
                    photoModel.append(Photo(url: url,
                                            data: (origin: originData, resize: resizeData)))
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    guard let `self` = self else { return }
                    if let value = try? self.photo.value() as [Photo], value.count < 2 {
                        self.photo.onNext(value+photoModel)
                    } else {
                        self.photo.onNext(photoModel)
                    }
                }
                
            }).disposed(by: disposeBag)
    }
    
    func showPicker(_ viewController: UIViewController, maxNumberOfItems: Int, nextViewController: UIViewController? = nil) {
        self.maxNumberOfItems = maxNumberOfItems
        var config = YPImagePickerConfiguration()
        config.library.minNumberOfItems = 1
        config.library.maxNumberOfItems = maxNumberOfItems
        config.wordings.libraryTitle = "앨범"
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "다음"
        config.wordings.cancel = "취소"
        config.targetImageSize = YPImageSize.cappedTo(size: 600)
//        config.wordings.permissionPopup.title = "PERMISSION_DENIED".localized
//        config.wordings.permissionPopup.message = "PERMISSION_DENIED_DESCRIPTION".localized
//        config.wordings.permissionPopup.cancel = "CANCEL".localized
//        config.wordings.permissionPopup.grantPermission = "GO_SETTINGS".localized
        config.startOnScreen = .library
        config.showsPhotoFilters = false
        config.hidesStatusBar = false
        config.library.defaultMultipleSelection = false
        //config.library.defaultMultipleSelection = maxNumberOfItems == 1 ? false : true
        config.library.preSelectItemOnMultipleSelection = false
        config.colors.albumBarTintColor = .whiteNBlack
        config.colors.albumTitleColor = .signatureNWhite
        config.colors.albumTintColor = .signatureNWhite
        config.colors.tintColor = .signatureNWhite
        config.colors.multipleItemsSelectedCircleColor = .signature
        
        let picker = YPImagePicker(configuration: config)
        
        let attr = [NSAttributedString.Key.foregroundColor: UIColor.signatureNWhite,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold)]
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .whiteNBlack
            appearance.titleTextAttributes = attr
            UINavigationBar.appearance().barTintColor = .signatureNWhite
            UINavigationBar.appearance().tintColor = .signatureNWhite
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().titleTextAttributes = attr
            
        } else {
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = .signatureNWhite
            UINavigationBar.appearance().tintColor = .signatureNWhite
            UINavigationBar.appearance().titleTextAttributes = attr
            UINavigationBar.appearance().backgroundColor = .whiteNBlack
            
        }
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = .signatureNWhite
        
        YPImagePickerConfiguration.shared = config
        
        viewController.present(picker, animated: true, completion: nil)
        
        picker.didFinishPicking { [unowned picker, weak self] (items, cancelled) in
            
            guard let `self` = self else {return}
            guard !cancelled else {
                //DEBUG_LOG("cancelled Picker")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            self.setPhotos(items) { (photos, images) in
                if photos.count > 0 {
                    PhotoManager.shared.asset.onNext(photos)
                }
                
                if images.count > 0 {
                    PhotoManager.shared.cameraPhoto.onNext(images)
                }
                
                if let nextViewController = nextViewController {
                    self.photo.onNext([])
                    picker.pushViewController(nextViewController, animated: true)
                } else {
                    picker.dismiss(animated: true)
                }
            }
            
        }
    }
    
    private func setPhotos(_ items: [YPMediaItem], _ completionHandler: @escaping ([PHAsset], [UIImage]) -> ()) {

        var photos: [PHAsset] = []
        var cameraImage: [UIImage] = []
        for (index, item) in items.enumerated() {
            switch item {
            
            case .photo(let photo):
                
                if let asset = photo.asset {
                    asset.requestContentEditingInput(with: nil) { (edit, info) in
                        if edit?.fullSizeImageURL != nil {
                            photos.append(asset)
                        } else {
                            cameraImage.append(photo.originalImage)
                        }
                        
                        if index == items.count-1 {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                                completionHandler(photos, cameraImage)
                            }
                        }
                        
                    }
                    
                } else { // 카메라로 사진 찍을 시
                    cameraImage = [photo.originalImage]

                    if index == items.count-1 {
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                            completionHandler(photos, cameraImage)
                        }
                    }
                }
                
            default : break
            }
            
        }

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

        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: { (result, info) -> Void in
            if let resultImage = result{
                
                //DEBUG_LOG("info: \(info.debugDescription)")
                thumbnail = resultImage
            }else{
                //DEBUG_LOG("getAssetThumbnail failed!!\n info: \(info.debugDescription)")
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

extension YPImagePicker {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
