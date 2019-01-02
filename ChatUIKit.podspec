Pod::Spec.new do |s|
  s.name = 'ChatUIKit'
  s.version = '1.1.2'
  s.summary = 'An exquisite UIKit library for chatting interface.'
  s.homepage = 'https://github.com/ideastouch/ChatUIKit'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Gustavo Halperin' => 'gustavoh@ideastouch.com' }
  s.social_media_url = 'http://twitter.com/ideastouch'
  s.ios.deployment_target = '11.0'
  s.swift_version = '4.2'
  s.platform = :ios, '11.0'
  s.source = { :git => 'https://github.com/ideastouch/ChatUIKit.git', :tag => s.version.to_s }
  s.source_files = 'ChatUIKit/ChatUIKit/**/*.{h,swift}'
  s.resources = 'ChatUIKit/ChatUIKit/**/*.{xib,otf,xcassets,bundle}'
  s.requires_arc = true
end
