//
//  ViewController.swift
//  Flix-Project
//
//  Created by Lexie Hvostal on 1/20/22.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Creation of array of dictionaries
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Network Request
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                self.tableView.reloadData()
            }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // generate movie cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // access movie in the array dictionary
        let movie = movies[indexPath.row]
        // cast movie title as type String
        let title = movie["title"] as! String
        // cast movie synopsis as type String
        let synopsis = movie["overview"] as! String
        
        // set tile of movie as title of cell (Swift optional)
        cell.titleLabel!.text = title
        // set synopsis of movie as synopsis of cell (Swift optional)
        cell.synopsisLabel.text = synopsis
        
        // get base url for movie poster
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        // add url to poster path
        let posterPath = movie["poster_path"] as! String
        // need poster url that combines base url with poster path
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Loading up the details screen")
        
        // Find the selected movie
        // cell tapped on
        let cell = sender as! UITableViewCell
        // what is the index of the movie in the table view
        let indexPath = tableView.indexPath(for: cell)!
        // access movie from array
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        // set vies controller movie to be the movie we just accessed
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

