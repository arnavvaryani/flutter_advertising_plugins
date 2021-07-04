#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'mopub_flutter'
  s.version          = '1.1.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://github.com/rohitiskul'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'kulkarni.rohit111@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'mopub-ios-sdk'
  s.dependency 'MoPub-AdColony-Adapters'
  s.dependency 'MoPub-AdMob-Adapters'
  s.dependency 'MoPub-TapJoy-Adapters'
  s.ios.deployment_target = '9.0'
  s.static_framework = true
end

