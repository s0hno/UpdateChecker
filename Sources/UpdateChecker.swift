import UIKit

private let appId = "284882215"
private let title = "アップデート"
private let message = "新しいVersionのインストール準備ができています。"
private let okBtnTitle = "今すぐインストール"
private let cancelBtnTitle = "後で"

private var topViewController: UIViewController? {
    guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
    while let presentedViewController = topViewController.presentedViewController {
        topViewController = presentedViewController
    }
    return topViewController
}

public enum UpdateType {
    case normal
    case force
}

public class UpdateChecker {

    public static func run(updateType: UpdateType) {
        guard let url = URL(string: "https://itunes.apple.com/jp/lookup?id=\(appId)") else { return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: request, completionHandler: {
            (data, _, _) in
            guard let d = data else { return }
            do {
                guard let results = try JSONSerialization.jsonObject(with: d, options: .allowFragments) as? NSDictionary else { return }
                guard let resultsArray = results.value(forKey: "results") as? NSArray else { return }
                guard let storeVersion = (resultsArray.firstObject as? NSDictionary)?.value(forKey: "version") as? String else { return }
                guard let installVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
                guard installVersion.compare(storeVersion) == .orderedAscending else { return }
                showAlert(updateType: updateType)
            } catch {
                print("Serialization error")
            }
        })
        task.resume()
    }

    private static func showAlert(updateType: UpdateType) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okBtnTitle, style: .default, handler: { Void in
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)") else { return }
            UIApplication.shared.openURL(url)
        })
        alert.addAction(okAction)

        if updateType == .normal {
            let cancelAction = UIAlertAction(title: cancelBtnTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }

        topViewController?.present(alert, animated: true, completion: nil)
    }
}
