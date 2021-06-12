//
//  PostDetailsController.swift
//  AzeniaBlogTest
//
//  Created by edwin weru on 11/06/2021.
//

import UIKit
import Alamofire

class PostDetailsController: UIViewController {

    //MARK: outlets
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_user: UILabel!
    
    @IBOutlet weak var segment_section: UISegmentedControl!
    
    @IBOutlet weak var containerView: UIView!
    
    //MARK: vars
    var post: Post?
    var user: User?
    
    var postId: Int = 0
    var userId: Int = 0
    
    var postTitle: String = ""
    var postBody: String = ""
    
    var usersList: [User] = []
    var arrayList: [Comment] = []
    var commentsDic: [Int: [Comment]] = [:]
    
    let cellNibName = "PostViewCell"
    let cellIdenifier = "cell"
    
    private lazy var summaryViewController: PostController = {
       
        // Instantiate View Controller
        var viewController = PostController()
        viewController.post = self.post

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()

    private lazy var sessionsViewController: CommentsController = {
        
        // Instantiate View Controller
        var viewController = CommentsController()

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Posts Details"
        // Do any additional setup after loading the view.
        
        if let value: Int = post?.id { self.postId = value; }
        if let value: Int = post?.userID { self.userId = value; }
        
        if let value: String = post?.title {
            self.postTitle = value;
            self.lbl_title.text = self.postTitle
        }
        if let value: String = post?.body { self.postBody = value; }
        
        requestUser()
        
        updateView()
        //commentsView()
    }

    @IBAction func actionSection(_ sender: Any) {
        
        updateView()
    }
    
    private func updateView() {
        if segment_section.selectedSegmentIndex == 0 {
            remove(asChildViewController: sessionsViewController)
            add(asChildViewController: summaryViewController)
        } else {
            remove(asChildViewController: summaryViewController)
            add(asChildViewController: sessionsViewController)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
//    private func commentsView() {
//
//        let textView = UITextView(frame: containerView.frame)
//        textView.contentInsetAdjustmentBehavior = .automatic
//
//         textView.center = self.containerView.center
//         textView.textAlignment = NSTextAlignment.justified
//
//         // Update UITextView font size and colour
//         textView.font = UIFont.systemFont(ofSize: 20)
//         textView.textColor = UIColor.darkGray
//
//         textView.font = UIFont.boldSystemFont(ofSize: 20)
//         textView.font = UIFont(name: "Verdana", size: 17)
//
//         // Capitalize all characters user types
//         textView.autocapitalizationType = UITextAutocapitalizationType.allCharacters
//
//         // Make UITextView web links clickable
//         textView.isSelectable = true
//         textView.isEditable = false
//         textView.dataDetectorTypes = UIDataDetectorTypes.link
//
//         // Make UITextView corners rounded
//         textView.layer.cornerRadius = 10
//
//         // Enable auto-correction and Spellcheck
//         textView.autocorrectionType = UITextAutocorrectionType.yes
//         textView.spellCheckingType = UITextSpellCheckingType.yes
//         // myTextView.autocapitalizationType = UITextAutocapitalizationType.None
//
//         // Make UITextView Editable
//         textView.isEditable = false
//
//        textView.text = postBody
//
//         self.containerView.addSubview(textView)
//
//    }
}

//MARK:-

extension PostDetailsController {
    
    private func requestUser () {
        
        let feedUrl = MyConstants.URL_USERS
        
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
                        usersList = try! JSONDecoder().decode([User].self, from: jsonData)

                        //Check if the element exists
//                        if arrayList.contains(where: {$0.postID == postId}) { // it exists, do something
//                        } else {  //item could not be found
//                        }
                        
                        //Get the element
                        if let selected = usersList.first(where: {$0.id == userId}) {
                           // do something with selected
                            if let uname = selected.name {
                                lbl_user.text = uname
                            }
                        } else {
                           // item could not be found
                        }
                        
                    } catch let err {
                        print("Err", err)
                    }
                    
                case .failure(let error):
                    
                    print("Falure code ", error)
                } // end of switch
                
        }
        
    }
    
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
                        print("groupBy \(commentsDic)")
                        
                        
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
