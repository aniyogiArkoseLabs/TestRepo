//
//  Fingerprint.swift
//  ArkoseLabsKit
//
//  Created by ArkoseLabs on 14/02/22.
//

import AVFoundation
import CryptoKit
import Foundation
import LocalAuthentication
import os
import UIKit

class Fingerprint {
    
    private static var frameworkBundle: Bundle?
    private static var sysinfo = utsname()
    private static let infoResult = uname(&sysinfo)
    private static let mtldevice = MTLCreateSystemDefaultDevice()
    private static var dataValues : [String: Any] = [:]
    private static var proximityNearCount = 0
    //MARK: methods not in camelCase for ease of obfuscation
    
    public class func getInfo(json: [String: [String: String]]) throws -> [String: Any]{
        
        if let fwBundle = Bundle(identifier: "ArkoseLabs.ArkoseLabsKit") {
            frameworkBundle = fwBundle
        } else {
            if let bundlePath = Bundle.main.path(forResource: "ArkoseLabsKitResource", ofType: "bundle") {
                if let resourceBundle = Bundle(path: bundlePath) {
                    frameworkBundle = resourceBundle
                }
            }
        }
        
        let currentSDKVersion = frameworkBundle?.infoDictionary?["CFBundleShortVersionString"] as! String
        var request = json[currentSDKVersion]
        if request == nil {
            request = json["default"]
        }
        if let _ = request?.key(from: "all") {
            request = AppConstants.ALDataDefault.requestDefault
        }
        for (_, requestVal) in request! {
            switch(requestVal) {
            case AppConstants.ALDataName.mobileSDKBuildVersion:
                dataValues[AppConstants.ALDataName.mobileSDKBuildVersion] = self.buildVersion()
            
                // Vendor
            case AppConstants.ALDataName.manufacturer:
                dataValues[AppConstants.ALDataName.manufacturer] = AppConstants.ALDataDefault.appleDefault
            case AppConstants.ALDataName.brand:
                dataValues[AppConstants.ALDataName.brand] = AppConstants.ALDataDefault.appleDefault
            case AppConstants.ALDataName.model:
                dataValues[AppConstants.ALDataName.model] = self.model()
            case AppConstants.ALDataName.product:
                dataValues[AppConstants.ALDataName.product] = self.product()
            case AppConstants.ALDataName.device:
                dataValues[AppConstants.ALDataName.device] = self.device()
                
            // Hardware
            case AppConstants.ALDataName.deviceArch:
                dataValues[AppConstants.ALDataName.deviceArch] = self.deviceArch()
            case AppConstants.ALDataName.cpuCores:
                dataValues[AppConstants.ALDataName.cpuCores] = self.cpuCores()
            case AppConstants.ALDataName.gpu:
                dataValues[AppConstants.ALDataName.gpu] = self.gpu()
            case AppConstants.ALDataName.storageInfo:
                dataValues[AppConstants.ALDataName.storageInfo] = self.storage()
            case AppConstants.ALDataName.bioFingerprint:
                dataValues[AppConstants.ALDataName.bioFingerprint] = self.bioFingerprint()
            case AppConstants.ALDataName.screenWidth:
                dataValues[AppConstants.ALDataName.screenWidth] = self.screenSize().width
            case AppConstants.ALDataName.screenHeight:
                dataValues[AppConstants.ALDataName.screenHeight] = self.screenSize().height
            case AppConstants.ALDataName.batteryStatus:
                dataValues[AppConstants.ALDataName.batteryStatus] = self.batteryStatus()
            case AppConstants.ALDataName.batteryCapacity:
                dataValues[AppConstants.ALDataName.batteryCapacity] = self.batteryCapacity()
                
            // Software
            case AppConstants.ALDataName.osVersion:
                dataValues[AppConstants.ALDataName.osVersion] = self.osVersion()
            case AppConstants.ALDataName.kernel:
                dataValues[AppConstants.ALDataName.kernel] = self.kernel()
            case AppConstants.ALDataName.codecsHash:
                dataValues[AppConstants.ALDataName.codecsHash] = self.codecHash()
            
            // Device State
            case AppConstants.ALDataName.deviceOrientation:
                dataValues[AppConstants.ALDataName.deviceOrientation] = self.deviceOrientation()
//            case AppConstants.ALDataName.pasteboardData:
//                dataValues[AppConstants.ALDataName.pasteboardData] = self.pasteboardData()
            case AppConstants.ALDataName.biometricsProximity:
                dataValues[AppConstants.ALDataName.biometricsProximity] = self.proximitySensorData()
                
                // Personal settings
            case AppConstants.ALDataName.localeHash:
                dataValues[AppConstants.ALDataName.localeHash] = self.localeHash()
            case AppConstants.ALDataName.countryRegion:
                dataValues[AppConstants.ALDataName.countryRegion] = self.countryRegion()
            case AppConstants.ALDataName.language:
                dataValues[AppConstants.ALDataName.language] = self.language()
            case AppConstants.ALDataName.timezoneOffset:
                dataValues[AppConstants.ALDataName.timezoneOffset] = self.timezoneOffset()               
            case AppConstants.ALDataName.deviceName:
                dataValues[AppConstants.ALDataName.deviceName] = self.deviceName()
            case AppConstants.ALDataName.screenBrightnessData:
                dataValues[AppConstants.ALDataName.screenBrightnessData] = self.screenBrightnessData()
            case AppConstants.ALDataName.iCloudUbiquityToken:
                dataValues[AppConstants.ALDataName.iCloudUbiquityToken] = self.iCloudUbiquityToken()

            // Application
            case AppConstants.ALDataName.parentApplicationId:
                dataValues[AppConstants.ALDataName.parentApplicationId] = self.appID()
            case AppConstants.ALDataName.parentApplicationVersion:
                dataValues[AppConstants.ALDataName.parentApplicationVersion] = self.appVersion()
            case AppConstants.ALDataName.appSigningData:
                dataValues[AppConstants.ALDataName.appSigningData] = self.signingData()
                
            case AppConstants.ALDataName.idForVendor:
                dataValues[AppConstants.ALDataName.idForVendor] = self.idForVendor()

            default:
                dataValues[requestVal] = ""
                //appendError(withDatapoint: requestVal, errorMessage: AppConstants.ALErrorText.errorJSONParsing)
            }
        }
        return dataValues
    }
    
    //MARK: private class methods for getInfo
    private class func model() -> String{
        let model: String
        var mib  = [CTL_HW, HW_TARGET]
        var size = MemoryLayout<ipc_info_name_t>.size
        let ptr = UnsafeMutablePointer<ipc_info_name_t>.allocate(capacity: 1)
        let nameResult = sysctl(&mib, u_int(mib.count), ptr, &size, nil, 0)
        if nameResult == 0 {
            model = String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
        }
        else {
            model = String()
        }
        ptr.deallocate()
        return model
    }
    
    private class func osVersion() -> String{
        return UIDevice.current.systemVersion
    }
    
    private class func buildVersion() -> String{
        let sdkVersion = frameworkBundle?.infoDictionary?["CFBundleShortVersionString"] as! String
        let sdkBuild = frameworkBundle?.infoDictionary?["CFBundleVersion"] as! String
        return "\(sdkVersion)(\(sdkBuild))"
    }
    
    private class func kernel() -> String{
        var kernel: String {
            guard infoResult == EXIT_SUCCESS else {
                return ""
                
            }
            let data = Data(bytes: &sysinfo.version, count: Int(_SYS_NAMELEN))
            guard let identifier = String(bytes: data, encoding: .ascii) else { return "" }
            return identifier.trimmingCharacters(in: .controlCharacters)
            
        }
        return kernel
    }
    private class func deviceArch() -> String{
        guard let archRaw = NXGetLocalArchInfo().pointee.name else {
            return String(AppConstants.ALDataDefault.unknownArch)
        }
        return String(cString: archRaw)
    }
    
    private class func device() -> String{
        var build: String = ""
        var buildinfo: String {
            guard infoResult == EXIT_SUCCESS else {
                return ""
            }
            let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
            guard let identifier = String(bytes: data, encoding: .ascii) else {
                return ""
            }
            return identifier.trimmingCharacters(in: .controlCharacters)
        }
        build = buildinfo
        return build
    }
    
    private class func product() -> String{
        var build: String = ""
        var buildinfo: String {
            guard infoResult == EXIT_SUCCESS else {
                return ""
            }
            let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
            guard let identifier = String(bytes: data, encoding: .ascii) else {
                return ""
            }
            return identifier.trimmingCharacters(in: .controlCharacters)
        }
        build = buildinfo
        if UIDevice.current.isSimulator {
            build = "\(AppConstants.ALDataDefault.simulatorBuild)_\(build)"
        }
        return build
    }
    
    private class func cpuCores() -> Int {
        return ProcessInfo.processInfo.processorCount
    }
    
    private class func gpu() -> String{
        var gpuRenderer = ""
        let gpuVendor = AppConstants.ALDataDefault.appleDefault
        if (mtldevice != nil) {
            guard let gpuRendererValue = mtldevice?.name.description else {
                return ""
            }
            gpuRenderer = gpuRendererValue
        }
        return "\(gpuVendor),\(gpuRenderer)"
    }
    
    private class func codecHash() -> String{
        let codecs = AVAssetExportSession.allExportPresets().description
        return getHashPrefix(forAttribute: codecs)
    }
    
    private class func localeHash() -> String{
        let availableLocale = Locale.availableIdentifiers.description
        return getHashPrefix(forAttribute: availableLocale)
    }
    
    private class func countryRegion() -> String{
        guard let countryRegion = Locale.current.regionCode else {
            return ""
        }
        return countryRegion
    }
    
    private class func language() -> String{
        guard let language = Locale.current.languageCode else {
            return ""
        }
        return language
    }
    
    private class func timezoneOffset() -> Int {
        let seconds = TimeZone.current.secondsFromGMT()

        let minutes = seconds/60
        return minutes
    }
    
    private class func storage() -> [CLongLong]{
        return [freeStorage(), totalStorage()]
    }
    
    private class func screenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    private class func bioFingerprint() -> Int {
        let authContext = LAContext()
        var authError: NSError?
        var authStatus: AppConstants.AuthStatusType = .unknown
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError){
            if authError?.code == Int(kLAErrorBiometryNotAvailable) || authError?.code == Int(kLAErrorTouchIDNotAvailable){
                authStatus = .unsupported
            }
            else if authError?.code == Int(kLAErrorBiometryNotEnrolled) || authError?.code == Int(kLAErrorTouchIDNotEnrolled){
                authStatus = .supported
            }
            else {
                authStatus = .enabled
            }
        }
        return authStatus.rawValue
    }
    
    private class func batteryStatus() -> String{
        UIDevice.current.isBatteryMonitoringEnabled = true
        var batteryStatus = String()
        
        switch(UIDevice.current.batteryState) {
        case .charging:
            batteryStatus = AppConstants.BatteryStatusType.charging.rawValue
        case .unknown:
            batteryStatus = AppConstants.BatteryStatusType.unknown.rawValue
        case .unplugged:
            batteryStatus = AppConstants.BatteryStatusType.unplugged.rawValue
        case .full:
            batteryStatus = AppConstants.BatteryStatusType.full.rawValue
        @unknown default:
            batteryStatus = AppConstants.BatteryStatusType.undefined.rawValue
        }
        
        return batteryStatus
    }
    
    private class func batteryCapacity() -> Int {
        var batteryLevel = Int()
        if(UIDevice.current.isSimulator){
            batteryLevel = 0
        }
        else {
            batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        }
        return batteryLevel
        
    }
    
    private class func deviceName() -> String {
        return getHashPrefix(forAttribute: UIDevice.current.name)
    }
    
    private class func deviceOrientation() -> String {
        var orientation = String()
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            orientation = AppConstants.DeviceOrientation.landscapeLeft.rawValue
        case .landscapeRight:
            orientation = AppConstants.DeviceOrientation.landscapeRight.rawValue
        case .portrait:
            orientation = AppConstants.DeviceOrientation.portrait.rawValue
        case .portraitUpsideDown:
            orientation = AppConstants.DeviceOrientation.portraitUpsideDown.rawValue
        case .faceUp:
            orientation = AppConstants.DeviceOrientation.faceUp.rawValue
        case .faceDown:
            orientation = AppConstants.DeviceOrientation.faceDown.rawValue
        default: // .unknown
            orientation = AppConstants.DeviceOrientation.unknown.rawValue
        }
        return orientation
    }
    
    private class func pasteboardData() -> String {
        var generalPasteboard = String()
        if #available(iOS 14.0, *) {
            //TODO: implement the logic for iOS 14.0 - 15.4, iOS 16.0 - * using UIPasteboard.DetectionPattern (or other components)
        }
        else {
            generalPasteboard = getHashPrefix(forAttribute: UIPasteboard.general.string ?? "")
        }
        guard generalPasteboard != "" else {
            appendError(withDatapoint: AppConstants.ALDataName.pasteboardData, errorMessage: AppConstants.ALErrorText.errorPasteboard)
            return ""
        }
        return generalPasteboard
    }
    
    private class func proximitySensorData() -> String {
        UIDevice.current.isProximityMonitoringEnabled = true
        return("\(UIDevice.current.proximityState),\(Fingerprint.proximityNearCount)")
    }
    
    private class func appID() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    private class func appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    private class func screenBrightnessData() -> Int {
        return Int(UIScreen.main.brightness * 100)
    }
    
    private class func idForVendor() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    private class func signingData() -> String {
        let profilePath: String? = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision")
        guard let path = profilePath else {
            appendError(withDatapoint: AppConstants.ALDataName.appSigningData, errorMessage: AppConstants.ALErrorText.errorNotInApp)
            return ""
        }
        return getHashPrefix(forAttribute: String(path))
    }
    
    private class func iCloudUbiquityToken() ->String {
        return getHashPrefix(forAttribute: FileManager.default.ubiquityIdentityToken?.description ?? "")
    }
    
    //MARK: internal calculation method used by other private class methods
    public class func startDataCollection() {
        startProximitySensor()
    }
    
    private class func startProximitySensor() {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: UIDevice.proximityStateDidChangeNotification, object: device)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIDevice.proximityStateDidChangeNotification, object: nil)
        }
    }
    
    @objc private class func proximityChanged( _ notification: Notification) {
        if notification.object is UIDevice {
            proximityNearCount += 1
        }
    }
    
    private class func freeStorage() -> CLongLong {
        
        return  getSpace(forAttribute: FileAttributeKey.systemFreeSize, withDatapoint: AppConstants.ALDataName.storageInfo)
    }
    
    private class func totalStorage() -> CLongLong {
        return  getSpace(forAttribute: FileAttributeKey.systemSize, withDatapoint: AppConstants.ALDataName.storageInfo)
    }
    
    private class func getSpace(forAttribute: FileAttributeKey, withDatapoint: String) -> CLongLong {
        var space : CLongLong = 0
        do {
            let spaceVal: CLongLong = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[forAttribute] as! CLongLong
            space = spaceVal
        }
        catch let fmError {
            appendError(withDatapoint: withDatapoint, errorMessage: "\(fmError.localizedDescription)")
            Logger.error("FileManager error: \(fmError.localizedDescription)")
            return 0
        }
        let bytes: CLongLong = 1 * CLongLong(space);
        return bytes;
    }
    
    private class func getHashPrefix(forAttribute: String) -> String {
        let data = forAttribute.data(using: .utf8)!
        var hashedDataString = String(SHA256.hash(data: data).description)
        hashedDataString = hashedDataString.replacingOccurrences(of: "SHA256 digest: ", with: "")
        return hashedDataString
    }
    
    private class func appendError(withDatapoint: String, errorMessage: String) -> Void {
        var errorString : String = ""
        errorString = dataValues[AppConstants.ALDataName.error] as? String ?? ""
        errorString = errorString + "[\(withDatapoint),\(errorMessage)] "
        dataValues[AppConstants.ALDataName.error] = errorString.trimTrailingWhitespace()
    }
    
}

//MARK: Extension used by other private class methods
extension Dictionary where Value: Equatable {
    func key(from value: Value) -> Key? {
        return self.first(where: { $0.value == value })?.key
    }
}
extension String {
    func trimTrailingWhitespace() -> String {
        if let trailingWs = self.range(of: "\\s+$", options: .regularExpression) {
            return self.replacingCharacters(in: trailingWs, with: "")
        } else {
            return self
        }
    }
}

extension UIDevice {
    var isSimulator: Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
}
