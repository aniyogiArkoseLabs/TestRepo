//
//  AppConstants.swift
//  ArkoseLabsiOSDemo
//
//  Created by ArkoseLabs on 30/06/2021.
//

//MARK: Constants

struct AppConstants {
    
    struct ALCallbackName {
        static let onReady = "onReady"
        static let onShow = "onShow"
        static let onShown = "onShown"
        static let onSuppress = "onSuppress"
        static let onHide = "onHide"
        static let onReset = "onReset"
        static let onCompleted = "onCompleted"
        static let onError = "onError"
        static let onFailed = "onFailed"
        static let onResize = "onResize"
        static let onDataRequest = "onDataRequest"
        static let fpMethodName = "fingerprintData"
    }
    
    struct ALDataName {
        //The below line is not to be part of default request
        //This will be added in datapoint collection when errors occur
        static let error = "mobile_sdk__errors"
        static let mobileSDKBuildVersion = "mobile_sdk__build_version"
        
        // Vendor Info
        static let manufacturer = "mobile_sdk__manufacturer"
        static let brand = "mobile_sdk__brand"
        static let model = "mobile_sdk__model"
        static let product = "mobile_sdk__product"
        static let device = "mobile_sdk__device"
        
        // Hardware
        static let deviceArch = "mobile_sdk__device_arch"
        static let cpuCores = "mobile_sdk__cpu_cores"
        static let gpu = "mobile_sdk__gpu"
        static let storageInfo = "mobile_sdk__storage_info"
        static let screenWidth = "mobile_sdk__screen_width"
        static let screenHeight = "mobile_sdk__screen_height"
        static let bioFingerprint = "mobile_sdk__bio_fingerprint"
        static let batteryStatus = "mobile_sdk__battery_status"
        static let batteryCapacity = "mobile_sdk__battery_capacity"
        
        // Software
        static let osVersion = "mobile_sdk__os_version"
        static let kernel = "mobile_sdk__kernel"
        static let codecsHash = "mobile_sdk__codec_hash"
        
        // Device State
        static let deviceOrientation = "mobile_sdk__device_orientation"
        static let pasteboardData = "mobile_sdk__pasteboard_data"
        static let biometricsProximity = "mobile_sdk__biometrics_proximity"
        
        // Personal settings
        static let localeHash = "mobile_sdk__locale_hash"
        static let countryRegion = "mobile_sdk__country_region"
        static let language = "mobile_sdk__language"
        static let timezoneOffset = "mobile_sdk__timezone_offset"
        static let deviceName = "mobile_sdk__device_name"
        static let screenBrightnessData = "mobile_sdk__screen_brightness"
        static let iCloudUbiquityToken = "mobile_sdk__icloud_ubiquity_token"
        
        // Application
        static let parentApplicationId = "mobile_sdk__app_id"
        static let parentApplicationVersion = "mobile_sdk__app_version"
        static let appSigningData = "mobile_sdk__app_signing_credential"

        // Ids
        static let idForVendor = "mobile_sdk__id_for_vendor"
        
        // Behavioral Biomertic data
        static let biometricMotion = "mobile_sdk__biometric_motion"
        static let biometricOrientation = "mobile_sdk__biometric_orientation"
        
    }
    
    struct ALDataDefault {
        static let unknownArch = "Unknown Architecture"
        static let unknown = "Unknown"
        static let simulatorBuild = "simulator"
        static let appleDefault = "Apple"
        static let requestDefault = [

                                     "0":AppConstants.ALDataName.mobileSDKBuildVersion,
                                     
                                     "1":AppConstants.ALDataName.manufacturer,
                                     "2":AppConstants.ALDataName.brand,
                                     "3":AppConstants.ALDataName.model,
                                     "30":AppConstants.ALDataName.product,
                                     "31":AppConstants.ALDataName.device,
                                     
                                     "4":AppConstants.ALDataName.deviceArch,
                                     "5":AppConstants.ALDataName.cpuCores,
                                     "6":AppConstants.ALDataName.gpu,
                                     "7":AppConstants.ALDataName.storageInfo,
                                     "8":AppConstants.ALDataName.screenWidth,
                                     "9":AppConstants.ALDataName.screenHeight,
                                     "10":AppConstants.ALDataName.bioFingerprint,
                                     "11":AppConstants.ALDataName.batteryStatus,
                                     "12":AppConstants.ALDataName.batteryCapacity,
                                                                    
                                     "13":AppConstants.ALDataName.osVersion,
                                     "14":AppConstants.ALDataName.kernel,
                                     "15":AppConstants.ALDataName.codecsHash,
                                     
                                     "16":AppConstants.ALDataName.deviceOrientation,
                                     //"17":AppConstants.ALDataName.pasteboardData,
                                     "18":AppConstants.ALDataName.biometricsProximity,
                                     
                                     "19":AppConstants.ALDataName.localeHash,
                                     "20":AppConstants.ALDataName.countryRegion,
                                     "21":AppConstants.ALDataName.language,
                                     "22":AppConstants.ALDataName.timezoneOffset,
                                     "23":AppConstants.ALDataName.deviceName,
                                     "24":AppConstants.ALDataName.screenBrightnessData,
                                     "25":AppConstants.ALDataName.iCloudUbiquityToken,
                                     
                                     "26":AppConstants.ALDataName.parentApplicationId,
                                     "27":AppConstants.ALDataName.parentApplicationVersion,
                                     "28":AppConstants.ALDataName.appSigningData,
                                     
                                     "29":AppConstants.ALDataName.idForVendor]
    }
    
    struct ALErrorText {
        static let errorMethodName = " method not called as it is not found. Check CAPI. "
        static let errorJSONParsing = " Internal JSON Parsing Error: mitigating..."
        static let errorDataCollection = "Encountered Data collection issue"
        static let errorTypeGeneric = "Generic"
        static let errorNotInApp = "Data collection is not from within an app on device"
        static let errorPasteboard = "Pasteboard data currently restricted in current iOS version"
        static let errorNetworkUnavailable = "Network in unavailable"
    }
    
    enum AuthStatusType : Int {
        case unknown = 0
        case unsupported = 1
        case supported = 2
        case enabled = 3
    }
    
    enum BatteryStatusType : String {
        case charging = "Charging"
        case unknown = "Unknown"
        case unplugged = "Unplugged"
        case full = "Full"
        case undefined = "Undefined"
    }
    
    enum DeviceOrientation : String {
        case landscapeLeft = "LL"
        case landscapeRight = "LR"
        case portrait = "P"
        case portraitUpsideDown = "PU"
        case faceUp = "FU"
        case faceDown = "FD"
        case unknown = "Un"
    }
}
