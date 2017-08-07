//
//  UserDetailsViewController.swift
//  HealthStudio
//
//  Created by Juan Francisco Sánchez López on 20/6/17.
//  Copyright © 2017 pineappleapps. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet var imageViewUser: UIImageView!
    var imageUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageViewUser.image = UIImage(named: imageUser)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
