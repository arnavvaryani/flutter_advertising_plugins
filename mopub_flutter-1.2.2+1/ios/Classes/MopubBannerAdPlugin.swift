//
//  MoPubBannerAdPlugin.swift
//  mopub_flutter
//
//  Created by Rohit Kulkarni on 1/6/20.
//

import Foundation
import Flutter

class MopubBannerAdPlugin : NSObject, FlutterPlatformViewFactory {
    
    let messeneger: FlutterBinaryMessenger
    
    init(messeneger: FlutterBinaryMessenger) {
        self.messeneger = messeneger
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return MoPubBannerAd(
            frame: frame,
            viewId: viewId,
            args: args as? [String : Any] ?? [:],
            messeneger: messeneger
        )
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
