
import UIKit
import XLPagerTabStrip

class SearchViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Search")
    }
}
