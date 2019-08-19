import WebKit
import UIKit

class ViewController: UIViewController {
  
  var webView: WKWebView!
  let config = WKWebViewConfiguration()
  let contentController = WKUserContentController()
  
  var count = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()

    if let script = generateCountButtonScript() {
      contentController.addUserScript(script)
    }
    
    if let script = generateAddCSSScript() {
      contentController.addUserScript(script)
    }
    
    contentController.add(self, name: "count")

    config.userContentController = contentController
    setupWebView(config: config, url: "https://google.com")
  }
  
  func generateCountButtonScript() -> WKUserScript? {
    guard let scriptPath = Bundle.main.path(forResource: "script", ofType: "js"),
      let scriptSource = try? String(contentsOfFile: scriptPath) else {
        return nil
    }
    
    let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    
    return script
  }
  
  func generateAddCSSScript() -> WKUserScript? {
    guard let cssPath = Bundle.main.path(forResource: "style", ofType: "css"),
    let cssString = try? String(contentsOfFile: cssPath).components(separatedBy: .newlines).joined() else {
      return nil
    }

    let source = """
    var style = document.createElement('style');
    style.innerHTML = '\(cssString)';
    document.head.appendChild(style);
    """
    
    let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    return script
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

extension ViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if message.name == "count", let messageBody = message.body as? String {
      print(messageBody)
      count += 1
      let javascript = "document.getElementById(\"countLabel\").innerHTML = \"Count: \(count)\";"
      webView.evaluateJavaScript(javascript, completionHandler: nil)
    }
  }
}

