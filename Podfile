# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

target 'HomeControl' do
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for HomeControl
  pod 'MZFormSheetPresentationController'
  pod 'ChromaColorPicker'
  pod 'StepSlider'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
  end
