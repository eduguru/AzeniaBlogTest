//
//  BlogPostsController.swift
//  AzeniaBlogTest
//
//  Created by edwin weru on 11/06/2021.
//

import UIKit
import Alamofire

class BlogPostsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let cellNibName = "PostViewCell"
    let cellIdenifier = "cell"
    
    var arrayList: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Blog Posts"
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.allowsSelection = true
        
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdenifier)
        tableView.rowHeight = 80
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        
        requestData()
    }

}


//MARK:-

extension BlogPostsController {
    
    private func requestData () {
        
        let feedUrl = MyConstants.URL_POSTS
        
        let parameters: [String: Any] = [:]
        
        showUniversalLoadingView(true, loadingText: "Please Wait....")
        
        AF.request(feedUrl, method: .get, parameters: parameters)
            
            .responseString { [self] response in
                
                showUniversalLoadingView(false)
                switch response.result {
            
                case .success(let data):
                    
                    //print(data)
                    do {
                        
//                        var arrayList: [Post]
//                        let strData = Data(data.utf8)
//
//                        let decoder = JSONDecoder()
//                        let response = try decoder.decode(Post.self, from: strData)
//
//                        for item in response.users {
//                            print(user.first_name)
//                        }
                        
                        let jsonData = data.data(using: .utf8)!
                        arrayList = try! JSONDecoder().decode([Post].self, from: jsonData)

                        //for item in arrayList {  print(item.body) }
                        
                        if arrayList.count > 0 {
                            tableView.reloadData()
                        }
                        
                    } catch let err {
                        print("Err", err)
                    }
                    
                case .failure(let error):
                    
                    print("Falure code ", error)
                } // end of switch
                
        }
        
    }
    
    // an overlay for loader
    func showUniversalLoadingView(_ show: Bool, loadingText : String = "") {
        
        let existingView = UIApplication.shared.windows[0].viewWithTag(1200)
        if show {
            if existingView != nil {
                return
            }
            let loadingView = makeLoadingView(withFrame: UIScreen.main.bounds, loadingText: loadingText)
            loadingView?.tag = 1200
            UIApplication.shared.windows[0].addSubview(loadingView!)
        } else {
            existingView?.removeFromSuperview()
        }

    }
    
    func makeLoadingView( withFrame frame: CGRect, loadingText text: String?) -> UIView? {
        
        let loadingView = UIView(frame: frame)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = loadingView.center
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            // Fallback on earlier versions
            activityIndicator.style = .whiteLarge
        }
        activityIndicator.startAnimating()
        activityIndicator.tag = 100 // 100 for example

        loadingView.addSubview(activityIndicator)
        if !text!.isEmpty {
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            let cpoint = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 80)
            lbl.center = cpoint
            lbl.textColor = UIColor.white
            lbl.textAlignment = .center
            lbl.text = text
            lbl.numberOfLines = 2
            lbl.tag = 1234
            loadingView.addSubview(lbl)
        }
        
        return loadingView
    }
    
}

//MARK:-
extension BlogPostsController: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return arrayList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdenifier, for: indexPath) as! PostViewCell
  
        let row = indexPath.row
        let currentItem: Post = arrayList[row]
        
        let name: String = currentItem.title ?? "title"
        let body: String = currentItem.body ?? "title"
        
        cell.lbl_title.text = name
        cell.lbl_desc.text = body
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let item: Post = arrayList[row]
        let id = item.id
        
        let nextVc = PostDetailsController()
        nextVc.post = item
        
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
}
