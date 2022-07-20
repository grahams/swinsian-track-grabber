//  Swinsian Track Grabber
//  radio.dosburros.com

import Foundation
import ScriptingBridge

/*
 * This is stolen from https://github.com/bmsimons/itunescli/blob/master/itunescli/bridge.swift
 *
 * I'd prefer to ditch the magic numbers once I figure out how to represent an AS enumeration in swift
 */
@objc public enum SwinsianPlayerState : AEKeyword {
    case stopped = 0x6b505353 /* 'kPSS' */
    case playing = 0x6b505350 /* 'kPSP' */
    case paused = 0x6b505370 /* 'kPSp' */
    case fastForwarding = 0x6b505346 /* 'kPSF' */
    case rewinding = 0x6b505352 /* 'kPSR' */
}

@objc protocol SwinsianTrack {
    @objc optional var name: String {get}
    @objc optional var artist: String {get}
    @objc optional var album: String {get}
    @objc optional var duration: Double {get}
    @objc optional var id: String {get}
}

@objc protocol swinsianApplication {
    @objc optional var soundVolume: Int {get}
    @objc optional var currentTrack: SwinsianTrack? {get}
    @objc optional var playerState: SwinsianPlayerState {get}
}

struct JSONSwinsianTrack : Codable {
    var trackName: String
    var trackArtist: String
    var trackAlbum: String
    var trackLength: String
    var trackId: String
}

extension SBApplication : swinsianApplication {}

if( SBApplication(bundleIdentifier: "com.swinsian.Swinsian")?.isRunning == true) {
    if let app: swinsianApplication = SBApplication(bundleIdentifier: "com.swinsian.Swinsian") {
        let track: SwinsianTrack? = app.currentTrack!
        
        if(app.playerState == SwinsianPlayerState.playing) {
            var trackLength = ""
            
            if(track?.duration != nil) {
                let min = (Int) ((track?.duration ?? 0.0) / 60)
                let sec = (Int) ((track?.duration ?? 0.0).truncatingRemainder(dividingBy: 60))
                trackLength = String(format: "%d:%02d", min, sec)
            }
            
            let jsonEncoder = JSONEncoder()
            let resultTrack = JSONSwinsianTrack(trackName: track?.name ?? "",
                                                trackArtist: track?.artist ?? "",
                                                trackAlbum: track?.album ?? "",
                                                trackLength: trackLength,
                                                trackId: track?.id ?? "");
            
            let jsonOutput = try jsonEncoder.encode(resultTrack)
            
            print(String(data: jsonOutput, encoding: .utf8)!)
        }
        else {
            print("{}")
        }
    }
    else {
        print("{}")
    }
}
else {
    print("{}");
}
