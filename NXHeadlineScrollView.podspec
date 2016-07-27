Pod::Spec.new do |s|
s.name         = 'NXHeadlineScrollView'
s.version      = '0.1.0'
s.summary      = '类似淘宝，京东APP首页的滚动头条'
s.homepage     = 'https://github.com/qufeng33/NXHeadlineScrollView.git'
s.license      = 'MIT'
s.author       = { 'nightx' => 'qufeng33@hotmail.com' }
s.platform     = :ios, '7.0'
s.source       = { :git => 'https://github.com/qufeng33/NXHeadlineScrollView.git', :tag => s.version.to_s }
s.source_files = 'NXHeadlineScrollView/**/*'
s.requires_arc = true
s.frameworks   = 'UIKit'
end