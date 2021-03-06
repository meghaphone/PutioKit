//
//  Subtitle.swift
//  PutioKit
//
//  Created by Stephen Radford on 12/01/2017.
//
//

import Foundation

/// The file format of subtitle.
///
/// - srt: Default. SRT file format.
/// - webvtt: webVTT file format used by things like Chromecast.
public enum SubtitleFormat: String {
    
    /// The default subtitle format used by Put.io.
    case srt = "srt"
    
    /// An alternative format available if required. Things like Chromecast require WebVTT.
    case webvtt = "webvtt"
    
}

/// Where the subtitle was obtained from
///
/// - folder: An SRT file with an identical name as the video
/// - mkv: Subtitles are extracted from an MKV file
/// - opensubtitles: The sutitles were fetched from OpenSubtitles
public enum SubtitleSource {
    
    /// An SRT file with an identical name as the video
    case folder
    
    /// Subtitles are extracted from an MKV file
    case mkv
    
    /// The sutitles were fetched from OpenSubtitles
    case opensubtitles
    
}

/// Represents a subtitle relating to a specific file.
open class Subtitle: NSObject {
    
    /// The unique key for the subtitle
    open dynamic var key = ""
    
    /// The detected language of the subtitle
    open dynamic var language: String?
    
    /// The name of the file e.g MySubtitle.srt
    open dynamic var name = ""
    
    /// The ID of the file this subtitle is associated with
    open dynamic var fileId = 0
    
    /// Where the subtitle was obtained from
    open var source: SubtitleSource = .folder
    
    internal convenience init(json: [String:Any], id: Int) {
        self.init()
        
        key = json["key"] as? String ?? ""
        language = json["language"] as? String
        name = json["name"] as? String ?? "Unknown"
        fileId = id
        
        if let text = json["source"] as? String {
            source = {
                switch text {
                case "folder":
                    return .folder
                case "mkv":
                    return .mkv
                case "opensubtitles":
                    return .opensubtitles
                default:
                    return .folder
                }
            }()
        }
        
    }
    
    /// Generate the URL for the requested format
    ///
    /// - Parameter format: The format to request. Defaults to `.srt`
    /// - Returns: The generated URL
    open func url(forFormat format: SubtitleFormat = .srt) -> URL? {
        let urlString = Router.base + "/files/\(fileId)/subtitles/\(key)?format=" + format.rawValue
        return URL(string: urlString)
    }
    
}
