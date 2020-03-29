import UIKit
import Alamofire
import WebKit


class VKLoginController: UIViewController {
       
    var presenter : LoginPresenter?
    var configurator : LoginConfigurator?
    let vkService = VKService()

    @IBOutlet weak var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(vkService.request!)
    }//override func viewDidLoad()
    
    
}// class VKLoginController: UIViewController


extension VKLoginController: WKNavigationDelegate {
    //Функция возвращает текст ошибки, если она случается. Для отладки
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        if debugMode == 1 {print(error)}
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        if debugMode == 1 {
            if let response = navigationResponse.response as? HTTPURLResponse {
                print("response description = \(response.description)")
                print("response.statusCode = \(response.statusCode)")
            }
        }
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }
        
        let params = fragment.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=")}
            .reduce([String: String]()) {
                value, params in
                var dict = value
                let key = params[0]
                let value = params[1]
                dict[key] = value
                return dict
        }
        if debugMode == 1 {print(params)}
        
        vkService.setSingleton(token: params["access_token"]!, userId: params["user_id"] ?? "0", version: "5.103")

        
        //реализация UserDefaults
        UserDefaults.standard.set(params["access_token"], forKey: "access_token")
        
        decisionHandler(.cancel)
     
        //определили класс для бэк-енд логики
        self.configurator = LoginConfiguratorImplementation()
        self.configurator?.configure(view: self)
          
          //получили/обновили логин из интернета
        self.presenter?.getLoginFromWebAndSave()
        
        self.presenter?.transitionToTabBar()
    }
}// extension


