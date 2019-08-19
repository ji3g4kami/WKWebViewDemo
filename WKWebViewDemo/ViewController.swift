import WebKit
import UIKit

class ViewController: UIViewController {
  
  var webView: WKWebView!
  let config = WKWebViewConfiguration()
  let contentController = WKUserContentController()
  
  var count = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let scriptPath = Bundle.main.path(forResource: "script", ofType: "js"),
      let scriptSource = try? String(contentsOfFile: scriptPath) else {
        return
    }

    let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    contentController.addUserScript(script)
    contentController.add(self, name: "count")

    config.userContentController = contentController
    let html = """
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        #countButton {
          text-align: center;
          position: relative;
          font-size: 16px;
          color: white;
          padding: 20px 20px 20px 20px;
          background: #e13232;
          border-radius: 8%;
      }

        #countLabel {
        font-size: 20px;
        margin: 40px;
      }
      </style>
    </head>
    <body>
      <p id="countLabel"></p>
      <button id="countButton">Count</button>
    </body>
    </html>
    """
    webView = WKWebView(frame: .zero, configuration: config)
    webView.loadHTMLString(html, baseURL: nil)
    
    view.addSubview(webView)
    let layoutGuide = view.safeAreaLayoutGuide
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
    webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
    webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
    webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
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

