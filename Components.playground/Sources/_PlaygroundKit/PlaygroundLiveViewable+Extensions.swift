import PlaygroundSupport

public struct Device {
    public let size: CGSize
}

public extension Device {
    static var iPhone5: Device { return .init(size: .init(width: 320, height: 568)) }
    static var iPhone67: Device { return .init(size: .init(width: 375, height: 667)) }
    static var iPad: Device { return .init(size: .init(width: 768, height: 1024)) }
}

public extension PlaygroundLiveViewable {
    public func show(on device: Device = .iPhone5) {
        show(size: device.size)
    }
    public func show(size: CGSize) {
        let targetView: UIView

        switch playgroundLiveViewRepresentation {
        case .view(let view):
            targetView = view

        case .viewController(let viewController):
            targetView = viewController.view
        }

        targetView.frame = CGRect(origin: .zero, size: size)

        PlaygroundPage.current.liveView = targetView
    }
}
