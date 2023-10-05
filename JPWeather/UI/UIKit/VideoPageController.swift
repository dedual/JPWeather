//
//  VideoPageController.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/5/23.
//

// Built because the requirements said "Make sure to use UIKit, we would love to see a combination of both UIKit and SwiftUI if you desire."
// which is contradictory: how can I both make sure to do something yet still have a choice, as implied with "if you desire"?
// So, I'm doing something simple because I ran out of time and frankly, a lot of my UI was just better implemented in SwiftUI
// which, kind of shocked me?

// Also, this view is a simple SwiftUI call that we can make and avoid all of this headache. A better example would be a custom layout
// with a UICollectionView, but time - not on my side.

import Foundation
import SwiftUI
import UIKit
import AVFoundation
import AVKit

struct VideoView: View {
    @Binding var selectedTabIndex:Int
    @EnvironmentObject var playerState : PlayerState
    @State private var showVideoPlayer = false
    @State private var vURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    var body: some View {
        Button(action: { self.showVideoPlayer = true }) {
            Text("Open UIKit View Modally").bold()
                }
                .fullScreenCover(isPresented: $showVideoPlayer, onDismiss: { self.playerState.currentPlayer?.pause() }) {
                    AVPlayerView(videoURL: self.$vURL)
                        .edgesIgnoringSafeArea(.all)
                        .environmentObject(self.playerState)
                }
    }
}
#Preview {
    VideoView(selectedTabIndex: .constant(4))            .environmentObject(PlayerState())
}

struct AVPlayerView: UIViewControllerRepresentable
{
    @EnvironmentObject var playerState : PlayerState
    @Binding var videoURL: URL?
        
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        playerController.modalPresentationStyle = .fullScreen
        playerController.player = playerState.player(for: videoURL!)
        playerController.player?.seek(to: .zero)
        playerController.player?.play()
        return playerController
    }
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
    }
}

class PlayerState: ObservableObject {

    public var currentPlayer: AVPlayer?
    private var videoUrl : URL?

    public func player(for url: URL) -> AVPlayer {
        if let player = currentPlayer, url == videoUrl {
            return player
        }
        currentPlayer = AVPlayer(url: url)
        videoUrl = url
        return currentPlayer!
    }
}
