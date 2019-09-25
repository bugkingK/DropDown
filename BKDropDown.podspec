Pod::Spec.new do |s|

  s.name         = "BKDropDown"
  s.version      = "1.0.3"
  s.summary      = "An API for DropDown with streams similar Rx"
  s.description  = <<-DESC
An API for DropDown with streams similar Rx, Implement options as simple functions
                   DESC

  s.homepage     = "https://github.com/bugkingK/BKDropDown"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "bugkingK" => "myway0710@naver.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/bugkingK/BKDropDown.git", :tag => "#{s.version}" }
  s.source_files = "Classes", "BKDropDown/Sources/**/*"

  s.swift_version = '5.0'

end
