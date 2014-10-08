//
//  ViewController.swift
//  TestProjectController
//
//  Created by Van Olmen, Marc on 10/6/14.
//  Copyright (c) 2014 Van Olmen, Marc. All rights reserved.
//

import UIKit
import AVFoundation



func getURLForEmbeddedMovie(fileName: String) -> NSURL {
    
    var aSampleURL = NSBundle.mainBundle().URLForResource(fileName.stringByDeletingPathExtension,
            withExtension: fileName.pathExtension)!
    
    return aSampleURL
}

class ViewController: UIViewController {

    
    var projectController: CMProjectController
    var avPlayer: AVPlayer!

    required init(coder aDecoder: NSCoder) {
        
        // Do any additional setup after loading the view, typically from a nib.
        self.projectController = CMProjectController()
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        var anURL = getURLForEmbeddedMovie("Nantucket Island Grove.mov")
        self.projectController.appendClipWithURL(anURL)
        anURL = getURLForEmbeddedMovie("Nantucket Island Grove.mov")
        self.projectController.appendClipWithURL(anURL)
        
        var anAVPlayerItem = AVPlayerItem(asset: self.projectController.asset)
        
        self.avPlayer = AVPlayer(playerItem: anAVPlayerItem)

        var aLayer = AVPlayerLayer(player: self.avPlayer)
        
        if let aLocalPlayer = self.avPlayer {
            aLocalPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.None
            aLayer.frame = self.view.frame
            self.view.layer.addSublayer(aLayer)
            self.avPlayer.play()

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

