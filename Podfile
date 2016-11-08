# Uncomment this line to define a global platform for your project
 platform :ios, '10.0'

target 'SpendingAnalysis' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SpendingAnalysis
  pod "SwiftyBeaver"
  pod "RxSwift", '~>2.6.0'
  pod "RxCocoa", '2.6.0'
  pod 'TBAppScaffold', :path => "~/Dropbox/shared_code/TBAppScaffold/"
  pod 'Charts'
  
  
  pod 'Moya','~>7.0.2'
  pod 'Moya/RxSwift'
  pod 'Moya-ObjectMapper', '1.4'
  pod 'Moya-ObjectMapper/RxSwift'
  pod 'SwiftDate', '3.0.9'
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
config.build_settings['SWIFT_VERSION'] = '2.3'
end
end
end
