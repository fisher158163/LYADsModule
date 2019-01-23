#
# Be sure to run `pod lib lint LYADsModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LYADsModule'
  s.version          = '1.1.0'
  s.summary          = 'LYADsModule is a Library has LaunchAd-function for Project'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
   LYADsModule is a Library has LaunchAd-function for Project
                       DESC

  s.homepage         = 'https://github.com/liyu158163/LYADsModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liyu158163' => '13798464518@163.com' }
  s.source           = { :git => 'https://github.com/liyu158163/LYADsModule.git', :tag => "#{s.version}" }

  s.header_dir       = "LYADsModule" # Pod安装之后的文件名

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'LYADsModule/Classes/**/*'
  s.dependency 'SDWebImage', '~> 3.8.2'
  s.dependency 'AFNetworking', '~> 3.2.1'


  # s.subspec 'Config' do |ss|
  #     ss.source_files = 'LYADsModule/Classes/LYADsModule/Config/*.{h}'
  #     ss.header_dir   = 'Config'
  # end

  # s.subspec 'LYADsWebViewController' do |ss|
  #     ss.source_files = 'LYADsModule/Classes/LYADsModule/LYADsWebViewController/*.{h,m}'
  #     ss.header_dir   = 'LYADsWebViewController'
  # end

  # s.subspec 'LYADsManager' do |ss|
  #     ss.source_files = 'LYADsModule/Classes/LYADsModule/LYADsManager/*.{h,m}'
  #     ss.header_dir   = 'LYADsManager'
  #     ss.dependency 'LYADsModule/Classes/LYADsModule/Config'
  #     ss.dependency 'LYADsModule/Classes/LYADsModule/LYADsWebViewController'
  #     ss.dependency 'LYADsModule/Classes/LYADsModule/LYADsNetworkingTool'
  #     ss.dependency 'LYADsModule/Classes/LYADsModule/LYADsLaunchView'

  # end

  # s.subspec 'LYADsNetworkingTool' do |ss|
  #     ss.source_files = 'LYADsModule/Classes/LYADsModule/LYADsNetworkingTool/*.{h,m}'
  #     ss.header_dir   = 'LYADsNetworkingTool'
  #     ss.dependency 'LYADsModule/Classes/LYADsModule/Vender/AFNetworking'

  # end

  # s.subspec 'LYADsLaunchView' do |ss|
  #     ss.source_files = 'LYADsModule/Classes/LYADsModule/LYADsLaunchView/*.{h,m}'
  #     ss.header_dir   = 'LYADsLaunchView'
  #     ss.dependency 'LYADsModule/Classes/LYADsModule/Vender/SDWebImage'
  #     ss.dependency 'LYADsModule/Classes/LYADsModule/LYADsManager'
  # end

  # s.subspec 'Vender' do |ss|
  #     # ss.source_files = 'LYADsModule/Classes/LYADsModule/Vender/*'
  #     ss.header_dir   = 'Vender'

  #     ss.subspec 'SDWebImage' do |sss|
  #     sss.source_files = 'LYADsModule/Classes/LYADsModule/Vender/SDWebImage/*.{h,m}'
  #     sss.header_dir   = 'SDWebImage'
  #     end

  #     ss.subspec 'AFNetworking' do |sss|
  #     sss.source_files = 'LYADsModule/Classes/LYADsModule/Vender/AFNetworking/*.{h,m}'
  #     sss.header_dir   = 'AFNetworking'
  #     end

  # end

  # s.resource_bundles = {
  #   'LYADsModule' => ['LYADsModule/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
