//
//  PlaybackController.swift

import UIKit

class PlaybackController: UIViewController, CMPlaybackDelegate {
	// MARK: Properties
	var url: NSURL?
	var playback: CMPlayback?
	
	// MARK: IBOutlets
	@IBOutlet weak var playbackView: UIView!
	@IBOutlet weak var progressView: UIProgressView!

	// MARK: - Handle Button Taps
	@IBAction func playPauseTapped(sender: AnyObject) {
		if playback == nil {
			return
		}
		
		if playback!.playing {
			playback?.pause()
		} else {
			playback?.play()
		}
	}
	
	// MARK: - View Controller Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if url == nil {
			return
		}
		
		// setup of playback
		playback = CMPlayback(url: url!, view: playbackView, autoplay: true, delegate: self)
		playback?.loop = true
		playback?.aspectFill()
	}
	
	// MARK: - Playback Delegate
	func playbackStopped() {
		progressView.setProgress(0, animated: false)
	}
	
	func playbackPaused() {
	}
	
	func playbackStarted() {
	}
	
	func playbackPosition(seconds :Double) {
		var progress = seconds/playback!.duration
		progressView.setProgress(Float(progress), animated: true)
	}
	
	func playbackError(message :String) {
		NSLog("Playback error \(message)")
		UIAlertView(title: "Error", message: "Could not playback video", delegate: nil, cancelButtonTitle: "Dismiss")
	}
}
