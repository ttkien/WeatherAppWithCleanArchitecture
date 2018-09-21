project 'Weather.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def podRxSwift
    pod 'RxSwift',    '4.1.2'
end

def podRxCocoa
    pod 'RxCocoa',    '4.1.2'
end

def podSwiftyJSON
    pod 'SwiftyJSON', '4.0.0'
end

def podSwiftyBeaver
    pod 'SwiftyBeaver', '1.5.0'
end

def podAlamofire
    pod 'Alamofire', '4.7.2'
    pod 'RxAlamofire', '4.0.0'
    pod 'AlamofireObjectMapper', '5.0.0'
end 

def podSwiftLint
pod 'SwiftLint'
end

def podSnapKit
    pod 'SnapKit', '4.0.0'
end

def podForWeather
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    
    podRxSwift
    podRxCocoa
    podSwiftyBeaver
    podSwiftyJSON
    podSwiftLint
    pod 'RxDataSources', '~> 3.0'
    podSnapKit
    pod 'Swinject', '2.1.1'
    pod 'BLKFlexibleHeightBar'
    podAlamofire
end

def podForTest
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'
    pod 'Swinject', '2.1.1'
end

target 'Weather' do
    podForWeather
end

target 'WeatherUI' do
    podSnapKit
    podRxSwift
    podRxCocoa
    pod 'BLKFlexibleHeightBar'

end

target 'Domain' do
    podRxSwift
    podSwiftLint
    target 'DomainTests' do
        podForTest
    end
end

target 'Platform' do
    podRxSwift
    podSwiftLint
    podSwiftyBeaver
    podSwiftyJSON
    podAlamofire
    target 'PlatformTests' do
        podForTest
    end

end


target 'DarkSkyRepository' do
    pod 'WXKDarkSky', '~> 2.2.0'
    podRxSwift
    podSwiftLint
    podSwiftyBeaver
    podSwiftyJSON
    podAlamofire
    pod 'Swinject', '2.1.1'
    target 'DarkSkyRepositoryTests' do
        podForTest
    end

end

target 'AERISWeatherRepository' do
    pod 'AerisWeather'
    pod 'AerisWeather/Maps'

    # include this if using Mapbox for maps in your project
    pod 'AerisWeather/Mapbox'

    # or include this if using Google Maps for maps in your project
    pod 'AerisWeather/Google'
    
    podRxSwift
    podSwiftLint
    podSwiftyBeaver
    podSwiftyJSON
    podAlamofire
    pod 'Swinject', '2.1.1'
    target 'AERISWeatherRepositoryTests' do
        podForTest
    end

end

target 'SearchCityRepository' do
    podRxSwift
    pod 'GooglePlaces'
    pod 'GooglePlacePicker'
    pod 'GoogleMaps'
    target 'SearchCityRepositoryTests' do
        podForTest
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'XCParameterizedTestCase'
            target.build_configurations.each do |config|
                config.build_settings['ENABLE_BITCODE'] = 'NO'
            end
        end
        target.build_configurations.each do |config|
            
            config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
        end
    end
end
