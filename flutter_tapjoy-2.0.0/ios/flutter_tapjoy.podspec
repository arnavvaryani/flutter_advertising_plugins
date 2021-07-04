Pod::Spec.new do |s|
  s.name             = 'flutter_tapjoy'
  s.version          = '1.0.3'
  s.summary          = 'A plugin for Tapjoy for both Android & iOS'
  s.description      = 'A plugin for Tapjoy for both Android & iOS'
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Anavrin Apps LLP' => 'anavrinapps@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'TapjoySDK'
  s.static_framework = true
  s.platform = :ios, '8.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
