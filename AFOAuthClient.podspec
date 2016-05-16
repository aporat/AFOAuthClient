Pod::Spec.new do |s|
  s.name             = "AFOAuthClient"
  s.version          = "2.0.0"
  s.summary          = "AFNetworking Extension for OAuth 1.0a, OAuth 2"
  s.description      = <<-DESC
AFNetworking Extension for OAuth 1.0a, OAuth 2 explict (server side) and oAuth 2 Implicit Authentication
                       DESC

  s.homepage         = "https://github.com/aporat/AFOAuthClient"
  s.license          = 'MIT'
  s.author           = { "Adar Porat" => "adar.porat@gmail.com" }
  s.source           = { :git => "https://github.com/aporat/AFOAuthClient.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/aporat28'

  s.ios.deployment_target = '7.0'

  s.source_files = 'Classes/**/*'

  s.dependency 'AFNetworking'
end
