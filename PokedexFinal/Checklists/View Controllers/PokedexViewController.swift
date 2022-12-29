//
//  PokedexViewController.swift
//  Checklists
//
//  Created by Farhan Molla on 11/27/22.
//

import UIKit
import CoreData


class PokedexViewController: UITableViewController {
  
  
  var managedObjectContext: NSManagedObjectContext!
  var itemToEdit: ChecklistItem?
  //var searchResults = [SearchResult]()

  
  @IBOutlet weak var attack: UILabel!
  @IBOutlet weak var type: UILabel!
  @IBOutlet weak var defense: UILabel!
  @IBOutlet weak var pokeName: UILabel!
  @IBOutlet weak var pokeImage: UIImageView!

  var downloadTask: URLSessionDownloadTask?
  
  //var searchResults = [SearchResult]()
  var hasSearched = false
  var isLoading = false
  var dataTask: URLSessionDataTask?
  var height = ""
  var weight = ""
  var image = ""
  var name = ""
  var types = ""
  var testName = ""
  var searchName = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundView = UIImageView(image: UIImage(named: "pokedex"))

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    if let item = itemToEdit {
      title = item.text
      pokeName.text = item.text
      
      name = item.text.format()
      name = name.replacingOccurrences(of: " ", with: "&")
      //name = item.text.lowercased()
      //searchName = item.text.trimmingCharacters(in: .whitespacesAndNewlines)
      //name = searchName.lowercased()
      
    }
    
    //print(image_found)
    pokeImage.image = UIImage(systemName: "square")
    
    
      self.getPokemon(name: self.name) { [self] pokemon in
      // Print the data for the Squirtle pokemon
      //print("Name: \(pokemon.name)")
      //print("Height: \(pokemon.height)")
      //print("Weight: \(pokemon.weight)")
      //print("Types: \(pokemon.types.map { $0.type.name }.joined(separator: ", "))")
      //print("Image URL: \(pokemon.sprites.front_default)")
      //print("Description URL: \(pokemon.species.url)")
      
      
      height = String(pokemon.height)
      weight = String(pokemon.weight)
      image = pokemon.sprites.front_default
      types = (pokemon.types.map { $0.type.name }.joined(separator: ", "))
      
      if let smallURL = URL(string: image) {
        downloadTask = pokeImage.loadImage(url: smallURL)
      }
    
      
      DispatchQueue.main.async { [self] in
        
        self.attack.text = String(self.height)
        defense.text = String(weight)
        type.text = types
      }
    }
    
    
  }
  
  @IBAction func done() {
    guard let navigationController = navigationController
    else {return}
    
    let view = navigationController.viewControllers[navigationController.viewControllers.count-1].view
    
    guard let view = view
    else {return}
    
    //view.backgroundColor = .red
    
    let hudView = HudView.hud(inView: view, animated: true)
    hudView.text = "Added favorites"
    afterDelay(0.6) {
      hudView.hide()
      self.navigationController?.popViewController(animated: true)
      
    }
    
    coreDataPokemon()
    
  }
  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 3
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 1
  }
  
  func showNetworkError() {
    let alert = UIAlertController(
      title: "Whoops...",
      message: "There was an error accessing the Pokedex." +
      " Please try again and check for spelling.",
      preferredStyle: .alert)
    
   // let action = UIAlertAction(
   //   title: "OK", style: .default, handler: { [weak self] _ in
   //     self?.dismiss(animated: true, completion: nil)
   //   })
    
    let action = UIAlertAction(title: "OK", style: .default) { _ in
      // Dismiss the current view controller
      self.dismiss(animated: true, completion: nil)
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    

  }
  
  
  func getPokemon(name: String, completion: @escaping (Pokemon) -> Void) {
    // Create the URL for the API endpoint
    let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)")!
    
    // Create a URLSession to make the GET request
    let session = URLSession(configuration: .default)
    
    // Create a data task to make the GET request
    let task = session.dataTask(with: url) { data, response, error in
      // Ensure there are no errors and that the response data is not nil
      guard error == nil, let data = data else {
        self.showNetworkError()
        self.navigationController?.popViewController(animated: true)
        return
      }
      
      // Create a JSONDecoder to decode the response data into a Pokemon object
      let decoder = JSONDecoder()
      
      do {
        // Decode the response data into a Pokemon object
        let pokemon = try decoder.decode(Pokemon.self, from: data)
        
        // Call the completion closure with the Pokemon object
        completion(pokemon)
      } catch {
        // If there was an error decoding the data, print it to the console
        DispatchQueue.main.async {
          self.showNetworkError()
        }
        //print(error)
      }
    }
    
    // Start the data task
    task.resume()
  }
  
  func coreDataPokemon(){
    getPokemon(name: name) { [self] pokemon in
      // Print the data for the Squirtle pokemon
      print("Name: \(pokemon.name)")
      print("Height: \(pokemon.height)")
      print("Weight: \(pokemon.weight)")
      print("Types: \(pokemon.types.map { $0.type.name }.joined(separator: ", "))")
      print("Image URL: \(pokemon.sprites.front_default)")
      print("Description URL: \(pokemon.species.url)")
      
      let pokemonData = Pokemons(context: managedObjectContext)
      pokemonData.image = pokemon.sprites.front_default
      pokemonData.name = pokemon.name
      
    }
  }
  
  
  // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return false
  }
  
  }
  
  
  /*
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
   
   // Configure the cell...
   
   return cell
   }
   */
  
  
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
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
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  


