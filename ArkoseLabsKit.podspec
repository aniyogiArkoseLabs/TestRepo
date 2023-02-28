#
#  Be sure to run `pod spec lint ArkoseLabsKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "ArkoseLabsKit"
  spec.version      = "0.0.1"
  spec.summary      = "Simple integration with the Arkose Labs Platform in native iOS applications."

  spec.description  = <<-DESC
    The Arkose Labs iOS SDK allows simple integration with the Arkose Labs Platform in native iOS applications.
  DESC

  spec.homepage     = "https://developer.arkoselabs.com"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Arkose Labs" => "a.niyogi@arkoselabs.com" }
  spec.platform     = :ios, "12.0"
  spec.source       = { :git => "https://github.com/aniyogiArkoseLabs/TestRepo.git", :tag => "#{spec.version}" }
  spec.source_files  = "ArkoseLabsKit","ArkoseLabsKit/**/*.{swift}"
  spec.swift_version = "5.0"
end
