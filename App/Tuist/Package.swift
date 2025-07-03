// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "App",
    dependencies: [
        // Networking
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.0")),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework-Static.git", .upToNextMajor(from: "6.10.0")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.6.0")),
        
        // UI & Utilities
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", .upToNextMajor(from: "5.15.4")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.6.0")),
        .package(url: "https://github.com/kirualex/SwiftyGif.git", .upToNextMajor(from: "5.4.4")),
        .package(url: "https://github.com/airbnb/lottie-spm.git", .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", .upToNextMajor(from: "24.0.0")),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", .upToNextMajor(from: "1.7.0")),
        .package(url: "https://github.com/BastiaanJansen/toast-swift.git", .upToNextMajor(from: "2.1.2")),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", .upToNextMajor(from: "7.1.1")),
        .package(url: "https://github.com/SCENEE/FloatingPanel.git", from: "2.8.5"),
        
        // Firebase Modules
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.5.0")),
        .package(url: "https://github.com/kasketis/netfox.git", .upToNextMajor(from: "1.20.0")),
        .package(url: "https://github.com/FLEXTool/FLEX.git", from: "5.22.10"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.1"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.0.0")),
//        .package(url: "https://github.com/ephread/Instructions", .upToNextMajor(from: "1.3.0"))
        
    ]
)
