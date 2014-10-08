//
//  ViewController.swift
//  TestProjectController
//
//  Created by Van Olmen, Marc on 10/6/14.
//  Copyright (c) 2014 Van Olmen, Marc. All rights reserved.
//
import UIKit
import AVFoundation

class CMProjectController {
    
    var clipURLList: [NSURL] = []
    
    init () {
        
    }
    
    func appendClipWithURL( url: NSURL ) {
        self.clipURLList.append(url);
    }
    
    var asset: AVAsset {
        get {
            return AVAsset.assetWithURL(self.clipURLList[0]) as AVAsset
        }
    }
    


}

