# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'dvach' do
  source 'https://github.com/CocoaPods/Specs.git'
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  
  source 'https://github.com/brion/OGVKit-Specs.git'
  
  # Pods for dvach
   pod 'PureLayout'
   pod 'Firebase/Core'
   pod 'Firebase/Database'
   pod 'Alamofire'
   pod 'SwiftyJSON', '4.2.0'
   pod 'SnapKit', '4.2.0'
   pod 'Nuke', '~> 7.6'
   pod 'Nuke-FLAnimatedImage-Plugin'
   pod 'FLAnimatedImage', :git => 'https://github.com/Flipboard/FLAnimatedImage.git', :tag => '1.0.14'
   pod 'Nantes'
   pod 'SwiftEntryKit', :git => 'https://github.com/Semty/SwiftEntryKit.git', :branch => 'support-of-setting-home-indicator-behaviour'
   pod 'lottie-ios', '3.1.0'
   pod 'Appodeal', '~> 2.4.10'
   pod 'OGVKit/WebM', :git => 'https://github.com/Semty/OGVKit', :branch => 'lanscape-orientation-video-fix'
   
  target 'dvachTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_BITCODE'] = 'NO'
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'USE_ALLOCA', 'OPUS_BUILD']
      end
    end
  end

end
