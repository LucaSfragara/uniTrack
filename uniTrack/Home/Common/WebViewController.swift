//
//  WebViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 11/01/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private let webView = WKWebView()
    private var URL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = URL?.host
        navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "External Link Icon"), style: .plain, target: self, action: #selector(didPressOpenInSafari))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "uniTrack secondary label color") as Any]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func loadView() {
        self.view = webView
    }
    
    convenience init(url: URL){
        self.init()
        self.URL = url
        webView.load(URLRequest(url: url))
    }

    @objc private func didPressOpenInSafari(){
        guard let url = URL else{return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
