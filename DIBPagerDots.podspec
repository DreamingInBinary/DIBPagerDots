Pod::Spec.new do |s|
  s.name         = "DIBPagerDots"
  s.version      = "0.0.1"
  s.summary      = "Add animated pagination to UIScrollViews."
  s.description  = "Add animated pagination easily to UIScrollViews with minimal code."
  s.homepage     = "https://github.com/DreamingInBinary/DIBPagerDots.git"
  s.screenshots  = "https://github.com/DreamingInBinary/DIBPagerDots/blob/master/demo.gif?raw=true"
  s.requires_arc = true
  s.license      = "MIT"
  s.author             = { "Jordan Morgan" => "jordan@dreaminginbinary.co" }
  s.social_media_url   = "http://twitter.com/JordanMorgan10"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/DreamingInBinary/DIBPagerDots.git", :tag => "0.0.1" }
  s.source_files = 'DIBPagerDots/DIBPagerDots/*.{h,m}'
  s.framework = "UIKit"
end
