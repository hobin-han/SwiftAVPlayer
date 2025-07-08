//
//  VideoDTO.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/7/25.
//

import Foundation

struct VideoDTO: Codable {
    let urlString: String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.urlString = try? container.decodeIfPresent(String.self, forKey: .urlString)
    }
    
    init(url: String?) {
        self.urlString = url
    }
    
    static func loadDummyList() -> [VideoDTO] {
        [
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear1/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/gear1/prog_index.m3u8", // timeout
            "https://file-examples.com/wp-content/uploads/2017/04/file_example_MOV_640_360_30s_800KB.mov", // timeout
            "https://filesamples.com/samples/video/mov/sample_1280x720_surfing_with_audio.mov",
            "https://filesamples.com/samples/video/mov/sample_3840x2160.mov",
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
            "https://test-videos.co.uk/bigbuckbunny/mp4-h264/1MB.mp4", // 404 error
            Bundle.main.url(forResource: "spinning_earth", withExtension: "mp4")?.absoluteString ?? "" // local file
        ].map { VideoDTO(url: $0) }
    }
}
