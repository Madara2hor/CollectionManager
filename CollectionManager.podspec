#
# Be sure to run `pod lib lint CollectionManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CollectionManager'
  s.version          = '0.0.1'
  s.summary          = 'Collection with different sections.'
  s.description      = <<-DESC
  a UICollectionView manager that allows you to easily manage sections. Sections can be: vertical, horizontal and consist of one cell.
                       DESC

  s.homepage         = 'https://github.com/Madara2hor/CollectionManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kirill Kapis' => 'kkprokk07@gmail.com' }
  s.source           = { :git => 'https://github.com/Madara2hor/CollectionManager', :tag => s.version.to_s }

  s.ios.deployment_target = '12.1'
  s.swift_version = '5.0'

  s.source_files = 'CollectionManager/Source/**/*'
  
end
