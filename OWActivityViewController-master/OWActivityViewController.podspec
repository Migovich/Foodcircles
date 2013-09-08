Pod::Spec.new do |s|
  s.name        = 'OWActivityViewController'
  s.version     = '1.5'
  s.authors     = { 'Roman Efimov' => 'romefimov@gmail.com', 'Brant Young' => 'brant.young@gmail.com' }
  s.homepage    = 'https://github.com/brantyoung/OWActivityViewController'
  s.summary     = 'Open source alternative to UIActivityViewController, highly customizable and compatible with iOS 5.0.'
  s.source      = { :git => 'https://github.com/brantyoung/OWActivityViewController.git' }
  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.platform = :ios, '5.0'
  s.requires_arc = true
  s.source_files = 'OWActivityViewController'
  s.public_header_files = 'OWActivityViewController/*.h'
  s.resources = "OWActivityViewController/OWActivityViewController.bundle", "OWActivityViewController/Localizations/*.lproj"

  s.ios.deployment_target = '5.0'
  s.ios.frameworks = 'QuartzCore', 'AssetsLibrary', 'MessageUI', 'Twitter'
  s.ios.weak_frameworks = 'Social'

  s.prefix_header_contents = <<-EOS
#import <Availability.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
  #import <SystemConfiguration/SystemConfiguration.h>
  #import <MobileCoreServices/MobileCoreServices.h>
  #import <Security/Security.h>
#else
  #import <SystemConfiguration/SystemConfiguration.h>
  #import <CoreServices/CoreServices.h>
  #import <Security/Security.h>
#endif
EOS
end
