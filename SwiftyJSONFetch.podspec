#
# Be sure to run `pod lib lint SwiftyJSONFetch.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyJSONFetch'
  s.version          = '0.1.0'
  s.summary          = 'A lightweight JSON fetching library.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Due to the amount of coding challenges for new jobs, where 99% are about loading JSON from somewhere, I decided to implement my own solution instead of using Alamofire (which is indeed awesome) or another library. That helped me refreshing my knowledge and in the end I learned something new. I also decided to make it public so you guys can learn or even make it better. Feel free to contribute! Bring in your ideas!
                       DESC

  s.homepage         = 'https://github.com/titatomte/SwiftyJSONFetch'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Thomas Marien' => 'titatomte@gmail.com' }
  s.source           = { :git => 'https://github.com/titatomte/SwiftyJSONFetch.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'SwiftyJSONFetch/Classes/**/*'
end
