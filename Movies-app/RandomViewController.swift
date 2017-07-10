
import UIKit
import XLPagerTabStrip

class RandomViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, IndicatorInfoProvider {
    
    let FIRST_PICKER = 1
    let SECOND_PICKER = 2
    let THIRD_PICKER = 3
    
    let ids = ["10759", "16", "35", "80", "99", "18", "10751", "10762", "9648", "10763", "10764", "10765", "10766", "10767", "10768", "37"]
    
    var firstId = "10759"
    var secondId = "10759"
    var thirdId = "19759"
    
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
    
    @IBOutlet weak var PickerViewOne: UIPickerView!
    @IBOutlet weak var PickerViewTwo: UIPickerView!
    @IBOutlet weak var PickerViewThree: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PickerViewOne.delegate = self
        PickerViewOne.dataSource = self
        
        PickerViewTwo.delegate = self
        PickerViewTwo.dataSource = self
        
        PickerViewThree.delegate = self
        PickerViewThree.dataSource = self
    }
    
    @IBAction func SearchRandom(_ sender: Any) {
        let ids = "\(self.firstId),\(self.secondId),\(self.thirdId)"
        
        MoviesApi.getRandomTvSeries(ids: ids, completionHandler: self.callback)
    }
    
    func callback(series: [Serie]) {
        print(series.count)
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
}
