import WebKit
import UIKit

class ViewController: UIViewController {
  
  var webView: WKWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let config = WKWebViewConfiguration()
    setupWebView(config: config)
    
    if let url = URL(string: "https://google.com") {
      webView.load(URLRequest(url: url))
    }
  }
  
  func setupWebView(config: WKWebViewConfiguration) {
    webView = WKWebView(frame: .zero, configuration: config)
    view.addSubview(webView)
    
    let layoutGuide = view.safeAreaLayoutGuide
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
    webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
    webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
    webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
  }
}

