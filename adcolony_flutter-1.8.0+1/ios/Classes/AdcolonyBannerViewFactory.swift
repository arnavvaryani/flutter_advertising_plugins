// class AdColonyBannerViewFactory: NSObject, FlutterPlatformViewFactory {
//     private let messenger: FlutterBinaryMessenger
    
//     init(messenger: FlutterBinaryMessenger) {
//         self.messenger = messenger
//     }
    
//     func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
//         return FlutterStandardMessageCodec.sharedInstance()
//     }
    
//     func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
//         return AdColonyBannerView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
//     }
// }
