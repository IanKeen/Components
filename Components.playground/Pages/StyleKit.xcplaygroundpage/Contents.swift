/*:
 # StyleKit

 - Simple typesafe style definitions
 - `Styleable`/`Style` are the bare minimum needed
 - `Style`s can be combined into `Stylesheet`s which can be applied at any level of the view hierarchy
 - `Stylesheet`s can be used in conjunction with a `StylesheetManager` which `UIViewController`s can observe to automatically update if the `Stylesheet` changes
 */
import UIKit

// define `UIView` styles
extension Style {
    static var light: Style<UIView> {
        return .init { $0.backgroundColor = .white }
    }
    static var dark: Style<UIView> {
        return .init { $0.backgroundColor = .black }
    }
}

// define `UIButton` styles
extension Style where T: UIButton {
    static var light: Style<UIButton> {
        return .init { button in
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }
    }
    static var dark: Style<UIButton> {
        return .init { button in
            button.backgroundColor = .black
            button.setTitleColor(.white, for: .normal)
        }
    }
}

// combine `Style`s into `Stylesheet`s
extension Stylesheet {
    static var light: Stylesheet {
        return Stylesheet(name: "Light")
            .styling(UIView.self, with: .light)
            .styling(UIButton.self, with: .light)
    }
    static var dark: Stylesheet {
        return Stylesheet(name: "Dark")
            .styling(UIView.self, with: .dark)
            .styling(UIButton.self, with: .dark)
    }
}

// create a `StylesheetManager` to notify of changes in stylesheets
let manager = StylesheetManager(stylesheet: .light)

// basic view controller listening for changes from `StylesheetManager`
class VC: UIViewController {
    let subscriptions = Subscriptions()

    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Button!!", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        view.addSubview(button)
        bindStyle(from: manager).disposed(by: subscriptions)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = .init(x: 0, y: 0, width: 200, height: 80)
    }
}

// update the style after a small delay
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    manager.changeStylesheet(to: .dark)
}

let vc = VC()
vc.show()
