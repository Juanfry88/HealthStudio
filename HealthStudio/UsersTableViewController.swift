//
//  UsersTableViewController.swift
//  HealthStudio
//
//  Created by Juan Francisco Sánchez López on 19/6/17.
//  Copyright © 2017 pineappleapps. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import Cache

class UsersTableViewController: UITableViewController, UISearchResultsUpdating {

    
    let UsersURL = "http://healthtraining.es/APP/getAllUsers.php"
    let imgUsersURL = URL(string: "http://healthtraining.es/APP/imgs/users/")
    
    var usuarios = [Usuario]()
    
    var usersNames = [String]()
    var usersImages = [String]()
    
    var searchController:UISearchController!
    var searchResults:[String]     = []
    var searchImgResults: [String] = []
    
    let cache = HybridCache(name: "Mix")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Ponemos una imagen de titulo
        setImageTitle()
        
        //Obtenemos del JSON los Usuarios
        downloadJSON()
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    func setImageTitle(){
        let imageView = UIImageView(frame: CGRect(x: 100, y: 0, width: 40, height: 20))
        imageView.contentMode = .scaleAspectFit
        let imageTitle = UIImage(named: "titulo480")
        imageView.image = imageTitle
        self.navigationItem.titleView = imageView
    }
    
    
    func downloadJSON(){
        Alamofire.request(UsersURL).responseJSON {response in
            self.usuarios = self.parseJsonData(data: response.data!)
            // Reload table view
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
        }
    }
    
    
    func parseJsonData(data: Data) -> [Usuario] {
    
        var usuarios = [Usuario]()
    
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            // Parse JSON data
            let jsonUsuarios = jsonResult?["usuarios"] as! [AnyObject]
            for jsonUsuario in jsonUsuarios {
                let usuario = Usuario()
                usuario.ID = Int(jsonUsuario["ID"] as! String)!
                
                let name:String = jsonUsuario["Nombre"] as! String
                let apellidos:String = jsonUsuario["Apellidos"] as! String
                usuario.Nombre = name
                usuario.Apellidos = apellidos
                usersNames.append(name + " " + apellidos)
                
                usuario.Img = jsonUsuario["Img"] as! String
                usersImages.append(jsonUsuario["Img"] as! String)
                
                usuario.Edad = Int(jsonUsuario["Edad"] as! String)!
                //let location = jsonLoan["location"] as! [String:AnyObject]
                //usuario.country = location["country"] as! String
                usuarios.append(usuario)
            }
        
        } catch {
            print(error)
            }
        
            return usuarios
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    func filterContent(for searchText: String) {
        searchResults = usersNames.filter({ (userName) -> Bool in
            return userName.localizedCaseInsensitiveContains(searchText)
        })
        searchImgResults = usersImages.filter({ (userImage) -> Bool in
            return userImage.localizedCaseInsensitiveContains(searchText)
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive{
            return searchResults.count
        } else {
            //return usersNames.count
            return usuarios.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UsersTableViewCell

        // Configure the cell...
        if searchController.isActive{
            cell.nameLabel.text = searchResults[indexPath.row]
            let imgURL = "http://healthtraining.es/APP/imgs/users/" + searchImgResults[indexPath.row]
            let imgUsersURL = URL(string: imgURL)
            cell.userImg.kf.setImage(with: imgUsersURL)
            //cell.userImg.image = UIImage(named:userImgs[indexPath.row])
        } else {
            cell.nameLabel.text = usuarios[indexPath.row].Nombre + " " + usuarios[indexPath.row].Apellidos
            //cell.userImg.image = UIImage(named:userImgs[indexPath.row])
            let imgURL = "http://healthtraining.es/APP/imgs/users/" + usuarios[indexPath.row].Img
            let imgUsersURL = URL(string: imgURL)
            cell.userImg.kf.setImage(with: imgUsersURL)
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            usersNames.remove(at: indexPath.row)
            //userImgs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //showUserDetails
        if segue.identifier == "showUserDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! UserDetailsViewController
                destinationController.imageUser = usuarios[indexPath.row].Img
            }
        }
    
    }
    

}
