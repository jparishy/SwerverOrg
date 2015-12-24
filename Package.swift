import PackageDescription

let package = Package(
	dependencies: [
		.Package(url: "../Swerver", majorVersion: 1)
	]
)
