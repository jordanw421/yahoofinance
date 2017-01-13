import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CustomSearchControllerDelegate {

    @IBOutlet weak var tblSearchResults: UITableView!
    
    var dataArray = [String]()
    var filteredArray = [String]()
    var shouldShowSearchResults = false
    var customSearchController: CustomSearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        loadListOfCountries()
        
        configureCustomSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: UITableView Delegate and Datasource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) 
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    
    // MARK: Custom functions
    
    func loadListOfCountries() {
    
        let pathToFile = Bundle.main.path(forResource: "countries", ofType: "txt")
        if let path = pathToFile {

            let countriesString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            dataArray = countriesString.components(separatedBy: "\n")
            tblSearchResults.reloadData()
        }
    }
    
    func configureCustomSearchController() {
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: tblSearchResults.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.orange, searchBarTintColor: UIColor.black)
        
        customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
        tblSearchResults.tableHeaderView = customSearchController.customSearchBar
        customSearchController.searchBar.keyboardAppearance = .dark
        customSearchController.customDelegate = self
        
        //addKeyboardButton()
        
        //customSearchController.definesPresentationContext = true
        //customSearchController.isActive = true
        //customSearchController.searchBar.becomeFirstResponder()
    }
    
    func addKeyboardButton() {
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.isTranslucent = false
        keyboardToolbar.barTintColor = UIColor.blue
        
        let addButton = UIButton(type: .custom)
        addButton.frame = CGRect(x: keyboardToolbar.frame.size.width / 2, y: keyboardToolbar.frame.size.height / 2, width: 50, height: 30)
        addButton.addTarget(self, action: #selector(clickMe), for: .touchUpInside)
        let item = UIBarButtonItem(customView: addButton)
        keyboardToolbar.items = [item]
        
        customSearchController.searchBar.inputAccessoryView = keyboardToolbar
    }
    
    func clickMe() {
        
        print("Clicked")
    }

    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        
        if !shouldShowSearchResults {
            
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    func didChangeSearchText(_ searchText: String) {
        
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText: NSString = country as NSString
            
            return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        tblSearchResults.reloadData()
    }
}

