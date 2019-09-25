Pod::Spec.new do |s|

  s.name         = "BKDropDown"
<<<<<<< HEAD
  s.version      = "1.0.1"
=======
  s.version      = "1.0.5"
>>>>>>> f62639361600141ec5db84a9c68a6bbf7395f65b
  s.summary      = "An API for DropDown with streams similar Rx"
  s.description  = <<-DESC
An API for DropDown with streams similar Rx, Implement options as simple functions
                   DESC

  s.homepage     = "https://github.com/bugkingK/BKDropDown"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "bugkingK" => "myway0710@naver.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/bugkingK/BKDropDown.git", :tag => "#{s.version}" }
<<<<<<< HEAD
  s.source_files = "Classes", "BKDropDown/Sources/**/*.{swift}"

  s.swift_version = '5.0'	

end
=======
  s.source_files = "Classes", "BKDropDown/Sources/**/*"

  s.swift_version = '5.0'

end
>>>>>>> f62639361600141ec5db84a9c68a6bbf7395f65b
