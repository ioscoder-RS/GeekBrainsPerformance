import UIKit
import Alamofire
import WebKit




class VKLoginController: UIViewController {
    
    let VKSecret = "7281379"
   
    var presenter : LoginPresenter?
    var configurator : LoginConfigurator?
    

    @IBOutlet weak var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
            self.view.addSubview(webView)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        doWebConnect{
            result in
            switch result {
             case .success(let loadResult):
 //               print("Success in doWebConnect()")
                
                self.saveUserDefaults()
                
                self.saveSingleton()
                

            case .failure(let error):
                print("Error in doWebConnect(): \(error)")
            }//switch
    
        }//completion doWebConnect
         
    }//override func viewDidLoad()
    
    //params:[String:String]
    func saveSingleton(){
        
    }
    
    func saveUserDefaults(){
    }
    
    
    private func transitionToTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MainTab")
        vc.modalPresentationStyle = .custom
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func doWebConnect(completion: @escaping (Out<WKNavigation?,Error>)-> Void){
        
        
              var urlComponent = URLComponents()
              urlComponent.scheme = "https"
              urlComponent.host = "oauth.vk.com"
              urlComponent.path = "/authorize"
              urlComponent.queryItems = [URLQueryItem(name: "client_id", value: VKSecret),
                                         URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/authorize/blank.html"),
                                         URLQueryItem(name: "display", value: "mobile"),
                                         URLQueryItem(name: "scope", value: "336918"),
                                         URLQueryItem(name: "response_type", value: "token"),
                                         URLQueryItem(name: "v", value: "5.103")
              ]
              
              //информирует, что пользователь переходит на другую страницу, напр. с токеном
 
      
            let request = try URLRequest(url: urlComponent.url!)
          do {
              let loadResult = try webView.load(request)
            completion(.success(loadResult))
        }catch{
            completion(.failure(error))
        }
    }
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
        
        Session.shared.token = params["access_token"]!
        Session.shared.userId = params["user_id"] ?? "0"
        Session.shared.version = "5.103"
        
        //получаем запись о пользователе с сервера
        
        //реализация UserDefaults
        UserDefaults.standard.set(params["access_token"], forKey: "access_token")

        //Получение групп по поисковому запросу"
        //    vkAPI.searchGroups(token: Session.shared.token, query: "любовь")
        
        decisionHandler(.cancel)
     
        //определили класс для бэк-енд логики
        self.configurator = LoginConfiguratorImplementation()
        self.configurator?.configure(view: self)
          
          //получили/обновили логин из интернета
        self.presenter?.getLoginFromWebAndSave()
        
        self.presenter?.transitionToTabBar()
    }
}// extension


