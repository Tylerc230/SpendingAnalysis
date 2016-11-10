# Uncomment this line to define a global platform for your project
 platform :ios, '10.0'

target 'SpendingAnalysis' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SpendingAnalysis
  pod "SwiftyBeaver"
  pod "RxSwift"
  pod "RxCocoa"
  pod "RxSugar"
  pod 'TBAppScaffold', :path => "~/Dropbox/shared_code/TBAppScaffold/"
  pod 'Charts'
  pod 'Moya'
  pod 'Moya/RxSwift'
  pod 'Moya-ObjectMapper'
  pod 'Moya-ObjectMapper/RxSwift'
  pod 'SwiftDate'
  pod 'Cartography'

  target 'SpendingAnalysisTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SpendingAnalysisUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
