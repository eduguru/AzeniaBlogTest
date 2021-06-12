//
//  CommentsController.swift
//  AzeniaBlogTest
//
//  Created by edwin weru on 12/06/2021.
//

import UIKit
import Alamofire

class CommentsController: UIViewController {
    
    let tableView = UITableView()
    
    //MARK: vars
    var post: Post?
    var user: User?
    
    var postId: Int = 0
    var userId: Int = 0
    
    var arrayList: [Comment] = []
    var commentsList: [Comment] = []
    var commentsDic: [Int: [Comment]] = [:]
    
    let cellNibName = "CommentsViewCell"
    let cellIdenifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let value: Int = post?.id { self.postId = value; }
        
        subviews()
        constraints()
        setupTableView()
        
        requestData()
    }

    func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.allowsSelection = false
        
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdenifier)
        //tableView.rowHeight = 80
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

}

//MARK:-

extension CommentsController {
    
    private func requestData () {
        
        let feedUrl = MyConstants.URL_COMMENTS
        
        let parameters: [String: Any] = [:]
        
        showUniversalLoadingView(true, loadingText: "Please Wait....")
        
        AF.request(feedUrl, method: .get, parameters: parameters)
            
            .responseString { [self] response in
                
                showUniversalLoadingView(false)
                switch response.result {
            
                case .success(let data):
                    
                    //print(data)
                    do {
                        
                        let jsonData = data.data(using: .utf8)!
                        arrayList = try! JSONDecoder().decode([Comment].self, from: jsonData)

                        //for item in arrayList {  print(item.body) }
                        
                        //let groupBy = Dictionary(grouping: arrayList) { $0.postID }
                        commentsDic = Dictionary(grouping: arrayList) { $0.postID ?? 0 }
                        
                        commentsList = commentsDic[postId] ?? []
                        tableView.reloadData()
                        
                        print("groupBy \(commentsList.count)")
                        
                        
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

extension CommentsController {
    func subviews() {
        view.addSubview(tableView)
    }

    func constraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK:-
extension CommentsController: UITableViewDataSource, UITableViewDelegate {

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//     
//        return UITableView.automaticDimension
//     
//     }
//     
//     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//     return 150
//     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return commentsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdenifier, for: indexPath) as! CommentsViewCell
  
        let row = indexPath.row
        let currentItem: Comment = commentsList[row]
        
        let name: String = currentItem.email ?? "user"
        let body: String = currentItem.body ?? "comment"
        
        cell.lbl_name.text = name
        cell.lbl_comment.text = body
        
        return cell
        
    }
    
}

