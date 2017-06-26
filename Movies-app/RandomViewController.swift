
import UIKit
import XLPagerTabStrip

class RandomViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Random")//, image: UIImage(named: "i_random"))
    }
}
