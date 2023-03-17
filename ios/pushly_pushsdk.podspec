#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint pushsdk.podspec` to validate before publishing.
#
require 'yaml'

pubspec = YAML.load_file('../pubspec.yaml')

Pod::Spec.new do |s|
  s.name             = pubspec['name']
  s.version          = pubspec['version']
  s.summary          = pubspec['description']

  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE', :type => 'MIT' }
  s.author           = { 'Pushly' => 'support@pushly.com' }
  s.source           = { :git => "https://github.com/pushly/push-sdk-flutter", :tag => s.version.to_s }
  s.source_files     = 'Classes/**/*'
  s.platform         = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'Flutter'
  s.dependency "Pushly", '>= 1.0.0', '< 2.0.0'
end
