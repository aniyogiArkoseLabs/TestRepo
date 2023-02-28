Pod::Spec.new do |spec|
  spec.name         = "TestRepo"
  spec.version      = "1.0.0"
  spec.summary      = "This is test"
  spec.description  = <<-DESC
                    This is a test
                   DESC
  spec.homepage     = "https://developer.arkoselabs.com"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Avik Niyogi" => "a.niyogi@arkoselabs.com" }
  spec.platform     = :ios, "16.2"
  spec.source       = { :git => "https://github.com/aniyogiArkoseLabs/TestRepo.git", :tag => "#{spec.version}" }
  spec.source_files = "TestRepo/*.{swift}"
  spec.swift_version = "5.0"
end
