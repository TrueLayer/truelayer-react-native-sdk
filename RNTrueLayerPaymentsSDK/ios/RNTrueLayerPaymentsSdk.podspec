
Pod::Spec.new do |s|
  s.name         = "RNTrueLayerPaymentsSdk"
  s.version      = "1.0.0"
  s.summary      = "React Native wrapper for TrueLayerPaymentsSDK"
  s.description  = "The iOS wrapper for the TrueLayerPaymentsSDK"
  s.homepage     = "https://github.com/TrueLayer/truelayer-react-native-sdk"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "13.0"
  s.source       = { :git => "https://github.com/TrueLayer/truelayer-react-native-sdk.git" }
  s.source_files  = "RNTrueLayerPaymentsSdk/**/*.{h,m}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "TrueLayerPaymentsSDK"
end

  