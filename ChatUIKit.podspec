Pod::Spec.new do |s|
  s.name         = "ChatUIKit"
  s.version      = "0.9.3"
  s.summary      = "An exquisite UIKit library for chatting interface."
  s.description  = <<-DESC
TBD: An exquisite UIKit library for chatting interface.
                   DESC
  s.homepage     = "https://github.com/ideastouch/ChatUIKit"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Gustavo Halperin" => "gustavoh@ideastouch.com" }
  s.social_media_url   = "http://twitter.com/ideastouch"
  s.ios.deployment_target = '11.0'
  s.swift_version = "4.2"
  s.source       = { :git => "https://github.com/ideastouch/ChatUIKit.git", :tag => "#{s.version}" }
  s.source_files  = "ChatUIKit/ChatUIKit/*.{h,swift}"
  s.resource_bundles = {'ChatUIKit' => ['ChatUIKit/ChatUIKit/*.{bundle}']}
  s.resources = 'ChatUIKit/ChatUIKit/*.{png,bundle,xib}'
  s.requires_arc = true
end
