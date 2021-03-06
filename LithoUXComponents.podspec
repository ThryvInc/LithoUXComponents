#
# Be sure to run `pod lib lint LithoUXComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LithoUXComponents'
  s.version          = '0.0.7'
  s.summary          = 'LithoUXComponents contains everything you need to create a simple app.'

  s.description      = <<-DESC
There's a bunch of really cool stuff in this pod, all targeted at letting you build the things that are *different* about your app, not the reproducing the same things over and over. Customizable, extendable, bare bones implementations of common UX components like splash, login, creds creation, commenting, and view/edit profile screens, an app delegate implementation that sets up fabric and crashlytics for you, a simple framework for handling user sessions, a material design based controller for table views... and more coming!
                       DESC

  s.homepage         = 'https://github.com/ThryvInc/LithoUXComponents'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Elliot' => '' }
  s.source           = { :git => 'https://github.com/ThryvInc/LithoUXComponents.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/elliot_schrock'

  s.ios.deployment_target = '11.0'

  s.source_files = 'LithoUXComponents/Classes/**/*.swift'
  
  s.resources = 'LithoUXComponents/**/*.xib'
  # s.resource_bundles = {
  #   'LithoUXComponents' => ['LithoUXComponents/**/*.xib']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ReactiveSwift'
  #s.dependency 'SBTextInputView'
  s.dependency 'FlexDataSource'
  s.dependency 'FunNet/ReactiveSwift'
  s.dependency 'LUX/Base'
  s.dependency 'LUX/Utilities'
  s.dependency 'LUX/Auth'
  s.dependency 'Prelude', '~> 3.0'
end
