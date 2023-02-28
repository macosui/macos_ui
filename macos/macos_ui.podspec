#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint macos_ui.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'macos_ui'
  s.version          = '0.1.0'
  s.summary          = 'Native functionality for the macos_ui Flutter package.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/macosui/macos_ui'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'GroovinChip' => 'groovinchip@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
