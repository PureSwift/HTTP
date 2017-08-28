Pod::Spec.new do |s|
  s.name         = "HTTP"
  s.version      = "1.0"
  s.summary      = ""
  s.description  = "Pure Swift HTTP library"
  s.homepage     = "https://github.com/PureSwift/HTTP"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Alsey Coleman Miller" => "alseycmiller@gmail.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/PureSwift/HTTP.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
