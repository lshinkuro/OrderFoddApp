import ProjectDescription
import Foundation

let appName = "App"
let prefixBundleID = "com.lshinkuro.App"

let project = Project(
    name: appName,
    targets: [
        .mainApp(appName,
                 dependencies: [
                    // External Depedencies
                    .alamofire,
                    .lottie,
                    .snapkit,
                    .firebaseAnalytics,
                    .firebaseStorage,
                    .firebaseCrashlytics,
                    .firebaseAuth,
                    .firebaseRemoteConfig,
                    .firebaseFirestore,
                    .netfox,
                    .FLEX,
                    .IQKeyboardManagerSwift,
                    .floatingPanel,
                    .MidtransKit,
                    .MidtransCoreKit,
                    .rxRelay,
                    .rxCocoa,
                    .rxSwift,
                    .skeletonView,
                    .toast,
                    .kingFisher,
                 ]),
        
            
    ]
    
)

public extension ProjectDescription.Target {
    
    static func mainApp(_ name: String,
                        dependencies: [TargetDependency]) -> ProjectDescription.Target {
        .target(
            name: "\(name)",
            destinations: .iOS,
            product: .app,
            bundleId: "com.lshinkuro.App",
            infoPlist: .file(path: .relativeToManifest("App/Info.plist")),
            sources: ["App/Sources/**/*.swift",],
            resources: [
                   "App/Sources/**/*.{xib,storyboard,ttf,json,strings,wav,xcdatamodeld,lproj,plist}",
                   "App/Resources/**/*.xcassets"

               ],
            dependencies: dependencies,
            settings: .settings(
                base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"])
        )
    }
    
    static func framework(_ targetName: String, sources: SourceFilesList?, resources: ResourceFileElements?, dependencies: [TargetDependency]) -> ProjectDescription.Target {
            .target(
                name: targetName,
                destinations: .iOS,
                product: .framework,
                bundleId: "\(prefixBundleID).\(targetName.dashSeparator)",
                sources: sources,
                resources: resources,
                dependencies: dependencies,
                settings: .settings(
                    base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"])
            )
    }
    
    static func example(_ targetName: String, sources: SourceFilesList?, resources: ResourceFileElements?, dependencies: [TargetDependency]) -> ProjectDescription.Target {
            .target(
                name: targetName,
                destinations: .iOS,
                product: .app,
                bundleId: "\(prefixBundleID).\(targetName.dashSeparator)",
                sources: sources,
                resources: resources,
                dependencies: dependencies,
                settings: .settings(
                    base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"])
            )
    }
    
}

internal extension String {
    var dashSeparator: String {
        self.replacingOccurrences(of: " ", with: "-")
    }
}

extension String {

    static let Dependency = "Dependency"
    static let Coordinator = "Coordinator"
    
}

extension TargetDependency {
    // MARK: TargetDependency Internal
    static let Dependency = TargetDependency.target(name: "Dependency")
    static let Coordinator = TargetDependency.target(name: "Coordinator")

    // MARK: TargetDependency External
    static let skeletonView = TargetDependency.external(name: "SkeletonView")
    static let alamofire = TargetDependency.external(name: "Alamofire")
    static let rxSwift = TargetDependency.external(name: "RxSwift")
    static let rxRelay = TargetDependency.external(name: "RxRelay")
    static let rxCocoa = TargetDependency.external(name: "RxCocoa")
    static let netfox = TargetDependency.external(name: "netfox")
    static let lottie = TargetDependency.external(name: "Lottie")
    static let snapkit = TargetDependency.external(name: "SnapKit")
    static let flex = TargetDependency.external(name: "FLEX")
    static let toast = TargetDependency.external(name: "Toast")
    static let AAChartKitSwift = TargetDependency.external(name: "AAInfographics")
    static let FSCalendar = TargetDependency.external(name: "FSCalendar")
    static let MarqueeLabel = TargetDependency.external(name: "MarqueeLabel")
    static let TrustKit = TargetDependency.external(name: "TrustKit")
    static let FLEX = TargetDependency.external(name: "FLEX")
    static let SDWebImage = TargetDependency.external(name: "SDWebImage")
    static let SwiftyGif = TargetDependency.external(name: "SwiftyGif")
    static let CryptoSwift = TargetDependency.external(name: "CryptoSwift")
    static let AlamofireImage = TargetDependency.external(name: "AlamofireImage")
    static let IOSSecuritySuite = TargetDependency.external(name: "IOSSecuritySuite")
    static let firebaseAuth = TargetDependency.external(name: "FirebaseAuth")
    static let firebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics")
    static let firebaseStorage = TargetDependency.external(name: "FirebaseStorage")
    static let firebaseCrashlytics = TargetDependency.external(name: "FirebaseCrashlytics")
    static let firebaseFirestore = TargetDependency.external(name: "FirebaseFirestore")

    static let firebaseRemoteConfig = TargetDependency.external(name: "FirebaseRemoteConfig")
    static let kingFisher = TargetDependency.external(name: "Kingfisher")

    static let Instructions = TargetDependency.external(name: "Instructions")

    static let floatingPanel = TargetDependency.external(name: "FloatingPanel")
    static let IQKeyboardManagerSwift = TargetDependency.external(name: "IQKeyboardManagerSwift")
}

// MARK: Terget dependency from XCFramework
extension TargetDependency {
    static let MidtransKit = TargetDependency.xcframework(
        path: "Frameworks/MidtransKit.xcframework",
        expectedSignature: nil,
        status: .required,
        condition: nil
    )
    
    static let MidtransCoreKit = TargetDependency.xcframework(
        path: "Frameworks/MidtransCoreKit.xcframework",
        expectedSignature: nil,
        status: .required,
        condition: nil
    )
}

enum TypeAssets: String {
    case xib
    case xcassets
    case swift
    case json
    
    func resourcePath(in feature: String, type : TypeSources, module: TypeModule = .features ) -> ProjectDescription.SourceFileGlob {
        return "\(module.rawValue)/\(feature)/\(type.rawValue)/**/*.\(self.rawValue)"
    }
    
    enum TypeSources: String {
        case sources = "Sources"
        case resources = "Resources"
    }
    
    enum TypeModule: String {
        case features = "Features"
        case foundations = "Foundations"
    }
    
}
