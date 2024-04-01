//
//  MapTinter.swift
//  Pet Bullet Heaven
//
//  Created by Lukasz Bednarek on 2024-03-26.
//

import UIKit
import SceneKit
import Foundation

// Static helper class to change the appearance of the map
public enum StageAestheticsHelper {
    
    enum mapBG {
        case plants
        case beach
        case clouds
        
        var image: UIImage {
            switch self {
            case .plants:
                return StageAestheticsHelper.plantBG
            case .beach:
                return StageAestheticsHelper.beachBG
            case .clouds:
                return StageAestheticsHelper.heavenBG
            }
        }
        
        var background: Background {
            switch self {
            case .plants:
                return Background(imageTexture: StageAestheticsHelper.plantBG, scale: StageAestheticsHelper.plantBGTileScale)
            case .beach:
                return Background(imageTexture: StageAestheticsHelper.beachBG, scale: StageAestheticsHelper.beachBGTileScale)
            case .clouds:
                return Background(imageTexture: StageAestheticsHelper.heavenBG, scale: StageAestheticsHelper.cloudBGTileScale)
            }
        }
        
        func next() -> mapBG {
            switch self {
            case .plants:
                return .beach
            case .beach:
                return .clouds
            case .clouds:
                return .plants
            }
        }
    }
    
    public struct Background {
        //var color: UIColor
        var imageTexture: UIImage?
        var scale: SCNMatrix4

        // Initialization with default values
        init(imageTexture: UIImage? = nil, scale: SCNMatrix4 = SCNMatrix4MakeScale(45, 25, 1)) {
            self.imageTexture = imageTexture
            self.scale = scale
        }
    }
    
    enum Backgrounds {
        case grassStage(Background)
        case beachStage(Background)
        case cloudStage(Background)
    }
    
    // Static colors
    public static let greenTint = UIColor.green
    public static let blueTint = UIColor.blue
    public static let redTint = UIColor.red
    
    public static let plantBG : UIImage = UIImage(named: "art.scnassets/backgrounds/Grass_01.png")!
    public static let beachBG : UIImage = UIImage(named: "art.scnassets/backgrounds/beach_sand.png")!
    public static let heavenBG : UIImage = UIImage(named: "art.scnassets/backgrounds/wispy_clouds.png")!
    
    public static let plantBGTileScale: SCNMatrix4 = SCNMatrix4MakeScale(40, 25, 1)
    public static let beachBGTileScale: SCNMatrix4 = SCNMatrix4MakeScale(5, 5, 1)
    public static let cloudBGTileScale: SCNMatrix4 = SCNMatrix4MakeScale(45, 25, 1)
    
    public static let maxTintCount : Int = 3
    public static let maxTextureCount : Int = 3
    private static var tintCount : Int = 0
    private static var textureCount : Int = 0
    private static var mapIterCount : Int = (UserDefaults.standard.integer(forKey: Globals.stageCountKey) % maxTextureCount + 1)
    
    //private static var currTint : tintColor = tintColor.green
    private static var currBG : mapBG = mapBG.plants
    
    public static func iterateStageVariation(_ material: SCNMaterial) -> UIImage? {
        // iterate tint. loop back to start if reached max
//        tintCount += 1
//        tintCount = tintCount % (maxTintCount + 1)
        
        mapIterCount += 1
        mapIterCount = mapIterCount % (maxTextureCount + 1) // add maxTintCount later
        currBG = currBG.next()
        
        setTileBG(material, withScale: currBG.background.scale)
        
        return currBG.image
        
        
        // TODO: Use this when adding map tints, maybe.
//        switch mapIterCount {
//        case 0:
//            return
//        default:
//            <#code#>
//        }
        
//        switch tintCount {
//        case 0:
//            // return the next image texture
//            return image
//        case 1:
//            currTint = tintColor.green
//        case 2:
//            currTint = tintColor.blue
//        case 3:
//            currTint = tintColor.red
//        default:
//            break
//        }
//        
//        let tintedImage = tintImage(image: image, withColor: currTint.!)
//        return tintedImage
    }
    
    public static func setInitialStageImage(_ material: SCNMaterial) -> UIImage? {
        if (mapIterCount != 0) {
            for _ in 0...mapIterCount{
                currBG = currBG.next()
            }
        }
        setTileBG(material, withScale: currBG.background.scale)
        
        return currBG.image
    }
    
    // Function to apply tint to an image
    public static func tintImage(image: UIImage, withColor color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard UIGraphicsGetCurrentContext() != nil else { return nil }
        
        color.setFill()
        
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIRectFill(rect)
        
        // Use the "multiply" blend mode to apply the color as a tint
        image.draw(in: rect, blendMode: .multiply, alpha: 1.0)
        
        // Combine the original image with the tint color using the "destination in" blend mode
        image.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        
        // Get the tinted image
        guard let tintedImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        return tintedImage
    }
    
    public static func tintImage(atPath path: String, withColor color: UIColor) -> UIImage? {
        guard let image = UIImage(contentsOfFile: path) else {
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard UIGraphicsGetCurrentContext() != nil else {
            return nil
        }

        color.setFill()

        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIRectFill(rect)

        // Use the "multiply" blend mode to apply the color as a tint
        image.draw(in: rect, blendMode: .multiply, alpha: 1.0)

        // Combine the original image with the tint color using the "destination in" blend mode
        image.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)

        // Get the tinted image
        guard let tintedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        return tintedImage
    }
    
    public static func setTileBG(_ material: SCNMaterial, withScale scale: SCNMatrix4) {
        // Set the tiling properties for the material
        material.diffuse.wrapS = .repeat // Horizontal tiling
        material.diffuse.wrapT = .repeat // Vertical tiling
        material.diffuse.contentsTransform = scale
        
        print("Scale: \(scale)")
    }

}
