import Foundation
import BNBSdkApi
import BNBSdkCore

public class BanubaSdkPluginImpl: NSObject, BanubaSdkManager
{
    func deinitialize() {
        BNBSdkApi.BanubaSdkManager.deinitialize()
    }
    
    func initialize(resourcePath: [String], clientTokenString: String, logLevel: SeverityLevel) {
        var flutterResPath = resourcePath
        flutterResPath.append(Bundle.main.bundlePath + "/bnb-resources")
        flutterResPath.append(Bundle.main.bundlePath) // for "effects"
        BNBSdkApi.BanubaSdkManager.initialize(
            resourcePath: flutterResPath,
            clientTokenString: clientTokenString,
            logLevel: BNBSeverityLevel(rawValue: logLevel.rawValue) ?? .info 
        )
    }
    func attachWidget(banubaId: Int32) {
        banubaSdkManager.setup(configuration: EffectPlayerConfiguration())

        guard let view =  NativeViewFactory.findEffectPlayer(banubaId: banubaId) else {
            print("View with id \(banubaId)")
            return
        }
         
        banubaSdkManager.setRenderTarget(
            view: view,
            playerConfiguration: nil)
        
    }
    
    func openCamera() {
        banubaSdkManager.input.startCamera()
    }
    
    func loadEffect(path: String) {
        banubaSdkManager.loadEffect(path, synchronous: true)
    }
    
    
    func startPlayer() {
        banubaSdkManager.startEffectPlayer()
    }
    
    func stopPlayer() {
        banubaSdkManager.stopEffectPlayer()
    }
    
    func evalJs(script: String) {
        banubaSdkManager.effectManager()?.current()?.evalJs(script, resultCallback: nil)
    }
    
    private var banubaSdkManager = BNBSdkApi.BanubaSdkManager()
}
