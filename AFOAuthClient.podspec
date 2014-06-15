Pod::Spec.new do |s|
  s.name     = 'AFOAuthClient'
  s.version  = '1.0.0'
  s.license  = 'Apache License, Version 2.0'
  s.summary  = 'AFNetworking Extension for OAuth 1.0a, OAuth 2 explict (server side) and oAuth 2 Implicit Authentication'
  s.homepage = 'https://github.com/aporat/AFOAuthClient'
  s.author   = { 'Adar Porat' => 'http://github.com/aporat' }
  s.source   = { :git => 'https://github.com/aporat/AFOAuthClient.git', :tag => '1.0.0' }
  
  s.platform = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'AFOAuthClient/AFOAuthClient/*.{h,m}'
  s.dependency 'AFNetworking', '~> 2'

end
