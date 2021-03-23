source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/yumimobi/Specs.git'

platform :ios, '9.0'

target 'YumiMediationSDKDemo' do
  use_frameworks!
  
  pod "YumiMediationSDK"
  pod "YumiMediationAdapters"
  pod "YumiMediationDebugCenter-iOS"
  pod "YumiMediationAdapterBytedance"
  pod "YumiMediationAdapterAppLovin"
  pod "YumiMediationAdapterAdmob"
  pod "YumiMediationAdapterGDT"

  #  测试
  pod 'LookinServer','~> 1.0.0', :configurations => ['Debug'],:inhibit_warnings => true
  
  target 'YumiMediationSDKDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'YumiMediationSDKDemoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
