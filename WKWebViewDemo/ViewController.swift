import WebKit
import UIKit

class ViewController: UIViewController {
  
  var webView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    let scriptSource = "document.body.style.backgroundColor = `red`;"
    guard let scriptPath = Bundle.main.path(forResource: "script", ofType: "js"),
     let scriptSource = try? String(contentsOfFile: scriptPath) else {
      return
    }
    let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    
    let contentController = WKUserContentController()
    contentController.addUserScript(script)

    let config = WKWebViewConfiguration()
    config.userContentController = contentController
    
    setupWebView(config: config, url: "https://google.com")
  }
  
  func setupWebView(config: WKWebViewConfiguration, url: String) {
    webView = WKWebView(frame: .zero, configuration: config)
    view.addSubview(webView)
    
    let layoutGuide = view.safeAreaLayoutGuide
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
    webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
    webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
    webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
    
    if let url = URL(string: url) {
      webView.load(URLRequest(url: url))
    }
  }
  
}

