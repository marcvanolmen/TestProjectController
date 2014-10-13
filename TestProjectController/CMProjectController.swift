//
//  ViewController.swift
//  TestProjectController
//
//  Created by Van Olmen, Marc on 10/6/14.
//  Copyright (c) 2014 Van Olmen, Marc. All rights reserved.
//
import UIKit
import AVFoundation



/*!
    @class			CMClip

    @abstract		This will hold all the information for a clip.

    @discussion		This will the model that holds all the information about a clip. 
                    Where it came from (Camera roll, Shared, Vi, the cut range etc.
*/


class CMClip {
    var url: NSURL

    init(url theURL: NSURL) {
        self.url = theURL
    }
}



/*!
    @class			CMProjectController

    @abstract		This a controller that helps us manage the Cameo Project.

    @discussion		This is build around the same idea as a NSArrayController.
*/

// MARK: -

class CMProjectController {

    
    /* Array of the clips we compose together  */
     private var clipList: [CMClip] = []
    
    /*!
        @method			init:
        @abstract		Will initialize a new Project Controller.
    
        @result			a valid CMProjectController
    */
    init () {
        
    }

    /*!
        @method			appendClipWithURL:
        @abstract		Appends a clip to our project
        @param			CMClip
                        a URL that points to a new video.
        This is the simplest way to add something to the project it will add both the audio and 
        video track to our current project.
    */

    func appendClip( clip: CMClip ) {
        self.clipList.append(clip);
    }

    /*!
    @method			asset:
    @abstract		This will return the current AVAsset
    @result			AVAsset of the current clips.
    */

    var asset: AVAsset {
        get {
            /*
                For the moment we build the asset always again but this will probably change, once we
                start adding trims commands.
            */
            
            var aComposition = AVMutableComposition()
            
            // For the moment lets create one audio and vidoe track.
            var aVideoCompositionTrack = aComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID:CMPersistentTrackID())
            var anAudioCompositionTrack = aComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID:CMPersistentTrackID())
            
            // Lets loop over all the clips and get
            for aClip in self.clipList {
                var anAsset = AVAsset.assetWithURL(aClip.url) as AVAsset
                var anError: NSError?
                var aRange = CMTimeRangeMake(kCMTimeZero, anAsset.duration)
                var anInsertTime = aComposition.duration
                
                //TODO: Will need to add support in case any of those tracks are empty.
                
                var aClipVideoTrack = anAsset.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack
                var aClipAudioTrack = anAsset.tracksWithMediaType(AVMediaTypeAudio)[0] as AVAssetTrack
                
                var a_result = aVideoCompositionTrack.insertTimeRange(aRange, ofTrack:aClipVideoTrack, atTime: anInsertTime, error: &anError)
                
                a_result = anAudioCompositionTrack.insertTimeRange(aRange, ofTrack:aClipAudioTrack, atTime: anInsertTime, error: &anError)
            }
            
            return aComposition
        }
    }

    
    
    /*!
    @method			printTrackDescription:
    @abstract		This will print out all the tracks information.
    */

    func printTrackDescription() {
        var anAsset = self.asset
        
        // lets print all the tracks information
        for aTrack  in anAsset.tracks {
            let anAVMutableCompositionTracks = aTrack as AVMutableCompositionTrack
            
            println("TrackType: \(anAVMutableCompositionTracks.mediaType) size: \(anAVMutableCompositionTracks.naturalSize)")
        }
    }
    
    


}

