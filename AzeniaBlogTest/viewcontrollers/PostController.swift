//
//  PostController.swift
//  AzeniaBlogTest
//
//  Created by edwin weru on 12/06/2021.
//

import UIKit

class PostController: UIViewController {

    @IBOutlet weak var txt_post: UITextView!
    
    //MARK: vars
    var post: Post?
    var user: User?
    
    var postId: Int = 0
    var userId: Int = 0
    
    var postTitle: String = ""
    var postBody: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let value: String = post?.body { self.postBody = value; }
        
        self.txt_post.text = postBody
    }

}
