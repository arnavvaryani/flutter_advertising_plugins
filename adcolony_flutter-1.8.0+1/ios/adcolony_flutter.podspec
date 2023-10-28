#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint adcolony_flutter.podspec` to validate before publishing.
#

Pod::Spec.new do |s|
  s.name             = 'adcolony_flutter'
  s.version          = '1.8.0'  # Update the version number
  s.summary          = 'Flutter plugin for AdColony SDK'  # Update the summary
  s.description      = <<-DESC
A Flutter plugin for integrating AdColony SDK into your Flutter applications.
                       DESC
  s.homepage         = 'https://example.com'  # Update the homepage URL
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }  # Update the author information
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'AdColony'
  s.static_framework = true
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain an i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
