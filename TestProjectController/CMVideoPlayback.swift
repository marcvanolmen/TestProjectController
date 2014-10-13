//
//  CMVideoPlayback.swift
//

import UIKit
import AVFoundation

protocol CMPlaybackDelegate {
	func playbackStopped()
	func playbackPaused()
	func playbackStarted()
	func playbackPosition(seconds: Double)
	func playbackError(message: String)
}

class CMVideoPlayback: NSObject {
	// MARK: Public Properties
	var delegate: CMPlaybackDelegate?
	var playing: Bool {
		get {
			return isPlaying
		}
	}
	var ready: Bool {
		get {
			return !errorOccurred
		}
	}
	
	var loop = false
	
	// in seconds
	var duration: Double {
		get {
			return videoDuration
		}
	}
	
	// MARK: Private Properties
	private var url: NSURL
	private var errorOccurred = false
	private var view: UIView
	private var isPlaying = false
	private var videoDuration: Double = 0.0
	private var player: AVPlayer
	private var layer: AVPlayerLayer
	private var timer: NSTimer?
	
	// MARK: Init
	init(url: NSURL, view: UIView, autoplay: Bool, delegate: CMPlaybackDelegate?) {
		self.url = url
		self.view = view
		self.delegate = delegate
		
		// setup avplayer
		player = AVPlayer(URL: url)
		
		// determine video duration
		videoDuration = CMTimeGetSeconds(player.currentItem.asset.duration)
		
		// setup view
		layer = AVPlayerLayer(player: player)
		layer.frame = view.bounds
		view.layer.addSublayer(layer)
		
		// setup notification listener
		super.init()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "stop", name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
		
		// handle autoplay
		if autoplay {
			player.addObserver(self, forKeyPath: "status", options: .New, context: nil)
			player.currentItem.addObserver(self, forKeyPath: "status", options: .New, context: nil)
		}
	}
	
	// MARK: - KVO Observer
	// used for autoplay
	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		if player.status == AVPlayerStatus.ReadyToPlay && player.currentItem.status == AVPlayerItemStatus.ReadyToPlay {
			play()
			player.removeObserver(self, forKeyPath: "status")
			player.currentItem.removeObserver(self, forKeyPath: "status")
		}
	}
	
	// MARK: - Sizing
	func aspectFill() {
		layer.videoGravity = AVLayerVideoGravityResizeAspectFill
	}
	
	// MARK: - Playback Lifecycle
	func play() {
		if playing || !ready {
			return
		}
		
		// nested due to swift compiler errors with type
		if player.status == AVPlayerStatus.ReadyToPlay && player.currentItem.status == AVPlayerItemStatus.ReadyToPlay {
			self.isPlaying = true
			self.delegate?.playbackStarted()
			self.player.play()

			// start timer
			timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "playedSplitSecond", userInfo: nil, repeats: true)
		}
	}
	
	func pause() {
		if !isPlaying || !ready {
			return
		}
		
		player.pause()
		
		delegate?.playbackPaused()
		isPlaying = false
		
		// stop timer
		timer?.invalidate()
		timer = nil
	}
	
	func seek(seconds: Double) {
		var seconds2 = seconds
		
		if seconds > videoDuration {
			seconds2 = videoDuration
		}
		
		player.seekToTime(CMTimeMakeWithSeconds(seconds, player.currentTime().timescale))
	}
	
	func stop() {
		if !isPlaying || !ready {
			return
		}
		
		pause()
		seek(0)
		
		main({
			self.delegate?.playbackStopped()
			return
		})
		
		if loop {
			play()
		}
	}
	
	private func error(message :String) {
		errorOccurred = true
		
		main({
			self.delegate?.playbackError(message)
			return
		})
	}
	
	func playedSplitSecond() {
		main({
			self.delegate?.playbackPosition(CMTimeGetSeconds(self.player.currentTime()))
			return
		})
	}
}
