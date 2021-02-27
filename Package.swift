// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

//import PackageDescription
//
//let package = Package(
//    name: "Pokemon",
//    defaultLocalization: "en",
////    products: [
////        // Products define the executables and libraries a package produces, and make them visible to other packages.
////        .library(
////            name: "DangerDependency",
////            type: .dynamic,
////            targets: ["Pokemon"]),
////    ],
//    dependencies: [
//        // Dependencies declare other packages that this package depends on.
//        // .package(url: /* package url */, from: "1.0.0"),
//        .package(url: "https://github.com/danger/swift.git", from: "1.0.0")
//    ],
//    targets: [
//        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
//        // Targets can depend on other targets in this package, and on products in packages this package depends on.
////        .target(name: "eigen", dependencies: ["Danger"], path: "Artsy", sources: ["Stringify.swift"]),
//        .target(
//            name: "Pokemon",
//            dependencies: ["Danger"], path: "./",  sources: ["Fake.swift"]),
//    ]
//)

import PackageDescription

let package = Package(
    name: "Eigen",
    products: [
        .library(name: "DangerDep", type: .dynamic, targets: ["eigen"])
    ],
    dependencies: [
        .package(name: "danger-swift", url: "https://github.com/danger/swift.git", from: "3.7.2"),
    ],
    targets: [
        .target(name: "eigen",
                dependencies: [.product(name: "Danger", package: "danger-swift")],
                path: ".",
                sources: ["Fake.swift"]),
    ]
)
