platform:ios, '9.0'

# ignore all warnings from all pods
inhibit_all_warnings!

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

target 'huozi' do
    pod 'Hero',             '1.2.0'
    pod 'iCarousel',        '1.8.3'
    pod 'SVGAPlayer',       '2.1.4'
    pod 'SideMenuSwift',    '0.5.0'
    pod 'Instabug',         '8.0.9'
end
