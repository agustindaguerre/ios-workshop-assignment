
import UIKit
import XLPagerTabStrip
import DZNEmptyDataSet

class RandomViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {
    
    let RANDOM_SERIE_SEGUE = "randomDetails"
    
    var selectedSerie: Serie?
    
    let FIRST_PICKER = 1
    let SECOND_PICKER = 2
    let THIRD_PICKER = 3
    let IMAGE = 4
    let TITLE = 5
    let SUMMARY = 6
    
    let ids = ["10759", "16", "35", "80", "99", "18", "10751", "10762", "9648", "10763", "10764", "10765", "10766", "10767", "10768", "37"]
    
    var firstId = "10759"
    var secondId = "10759"
    var thirdId = "10759"
    
    let genres = [
        "Action & Adventures",
        "Animation",
        "Comedy",
        "Crime",
        "Documentary",
        "Drame",
        "Family",
        "Kids",
        "Mistery",
        "News",
        "Reality",
        "Sci-fi & Fantasy",
        "Soap",
        "Talk",
        "War & Politics",
        "Western"
    ]
    
    var series = [Serie]()
    
    @IBOutlet weak var PickerViewOne: UIPickerView!
    @IBOutlet weak var PickerViewTwo: UIPickerView!
    @IBOutlet weak var PickerViewThree: UIPickerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PickerViewOne.delegate = self
        PickerViewOne.dataSource = self
        
        PickerViewTwo.delegate = self
        PickerViewTwo.dataSource = self
        
        PickerViewThree.delegate = self
        PickerViewThree.dataSource = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.prepareEmptyDataSet()
    }
    
    @IBAction func SearchRandom(_ sender: Any) {
        let ids = "\(self.firstId),\(self.secondId),\(self.thirdId)"
        
        MoviesApi.getRandomTvSeries(ids: ids, completionHandler: self.onReceiveRandomSeries)
    }
    
    func onReceiveRandomSeries(series: [Serie]) {
        self.series = series
        print(self.series.toJSONString(prettyPrint: true) ?? "vacio")
        tableView.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Random")
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genres[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genres.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == FIRST_PICKER {
            firstId = ids[row]
        } else if pickerView.tag == SECOND_PICKER {
            secondId = ids[row]
        } else {
            thirdId = ids[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let currentSerie = series[indexPath.row]
        
        let imageView = cell?.viewWithTag(IMAGE) as! UIImageView
        
        if let poster = currentSerie.poster {
            imageView.image = poster
        }
        
        let label = cell?.viewWithTag(TITLE) as! UILabel
        
        let summaryLabel = cell?.viewWithTag(SUMMARY) as! UILabel
        
        if let summary = currentSerie.summary {
            summaryLabel.text = summary
        }
        
        label.text = currentSerie.name!
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RANDOM_SERIE_SEGUE {
            let movieDetailsController = segue.destination as! MovieDetailsViewController
            movieDetailsController.movieId = selectedSerie!.id
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedSerie = series[indexPath.row]
        performSegue(withIdentifier: RANDOM_SERIE_SEGUE, sender: self)
    }
}

extension RandomViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "i_random")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)]
        return NSAttributedString(string: "Select categories to pick a random TV Show", attributes: attributes)
    }
    
    func prepareEmptyDataSet() {
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.tableFooterView = UIView()
    }
}
