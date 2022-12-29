/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreData


class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
  var checklist: Checklist!
  
  /*
  var items = [Pokemon]()
  
  var pokemonManager = PokemonManager()
  var pokemons: [Pokemon] = []
  var pokemonFilter: [Pokemon] = []
  var pokemonSelected: Pokemon?
   */
  var managedObjectContext: NSManagedObjectContext!


  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    title = checklist.name
    tableView.backgroundView = UIImageView(image: UIImage(named: "snorlax"))
    
   // pokemonManager.delegade = self
   // pokemonManager.verPokemon()
   // print(pokemonManager.verPokemon())
  }

  // MARK: - Navigation
  override func prepare(
    for segue: UIStoryboardSegue,
    sender: Any?
  ) {
    if segue.identifier == "AddItem" {
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self
    } else if segue.identifier == "EditItem" {
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self
      if let indexPath = tableView.indexPath(
        for: sender as! UITableViewCell) {
        controller.itemToEdit = checklist.items[indexPath.row]
      }
      
  }
    else if segue.identifier == "pokemon" {
      let controller = segue.destination as! PokedexViewController
      //controller.delegate = self
      if let indexPath = tableView.indexPath(
        for: sender as! UITableViewCell) {
        controller.itemToEdit = checklist.items[indexPath.row]
        controller.managedObjectContext = managedObjectContext

      }
      
  }
  }

  // MARK: - Actions
  func configureCheckmark(
    for cell: UITableViewCell,
    with item: ChecklistItem
  ) {
  }

  func configureText(
    for cell: UITableViewCell,
    with item: ChecklistItem
  ) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
    //label.text = "\(item.itemID): \(item.text)"
  }

  /*
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(
      for: .documentDirectory,
         in: .userDomainMask)
    return paths[0]
  }

  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
  }

  func saveChecklistItems() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(items)
      try data.write(
        to: dataFilePath(),
        options: Data.WritingOptions.atomic)
    } catch {
      print("Error encoding item array: \(error.localizedDescription)")
    }
  }

  func loadChecklistItems() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        items = try decoder.decode(
          [ChecklistItem].self,
          from: data)
      } catch {
        print("Error decoding item array: \(error.localizedDescription)")
      }
    }
  }
   */
  // MARK: - Table View Data Source
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return checklist.items.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "ChecklistItem",
      for: indexPath)

    let color = UIColor(r: 0, g: 118, b: 200) //
    cell.backgroundColor = color


    let pokemonSelected = checklist.items[indexPath.row]
    print(pokemonSelected)
    
    //performSegue(withIdentifier: "verPokemon", sender: self)
    configureText(for: cell, with: pokemonSelected)
    cell.textLabel?.textColor = UIColor.white // <- Changed color here
    configureCheckmark(for: cell, with: pokemonSelected)

    return cell
  }

  // MARK: - Table View Delegate
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    if let cell = tableView.cellForRow(at: indexPath) {
      //let pokemonSelected = checklist.items[indexPath.row]
      //item.checked.toggle()

      //onfigureCheckmark(for: cell, with: item)
    }

    //let pokemonSelected = checklist.items[indexPath.row]
    //performSegue(withIdentifier: "verPokemon", sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
    
  }

  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    checklist.items.remove(at: indexPath.row)

    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
    
  }

  // MARK: - Add Item ViewController Delegates
  func itemDetailViewControllerDidCancel(
    _ controller: ItemDetailViewController
  ) {
    navigationController?.popViewController(animated: true)
  }

  func itemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishAdding item: ChecklistItem
  ) {
    let newRowIndex = checklist.items.count
    checklist.items.append(item)

    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    navigationController?.popViewController(animated:true)
    
  }

  func itemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishEditing item: ChecklistItem
  ) {
    if let index = checklist.items.firstIndex(of: item) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        configureText(for: cell, with: item)
      }
    }
    navigationController?.popViewController(animated: true)
    
  }
}

extension UIColor {
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
    self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
  }
}
