#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint macos_ui.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'macos_ui'
  s.version          = '0.1.0'
  s.summary          = 'Native functionality for the macos_ui Flutter package.'
  s.description      = <<-DESC
macos_ui is a Flutter package that provides widgets and themes implementing the current macOS design language.
                       DESC
  s.homepage         = 'https://github.com/macosui/macos_ui'
  s.license          = { :file => '../LICENSE', :type => 'MIT' }
  s.author           = { 'GroovinChip' => 'groovinchip@gmail.com' }
  s.source           = { :git => 'https://github.com/macosui/macos_ui.git',
	                       :tag => s.version.to_s }
  s.source_files = 'macos_ui/Sources/macos_ui/**/*.swift'
  s.resource_bundles = {'macos_ui_privacy' => ['macos_ui/Sources/macos_ui/Resources/PrivacyInfo.xcprivacy']}
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
