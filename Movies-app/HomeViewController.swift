
import UIKit
import XLPagerTabStrip

class HomeViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Home")//, image: UIImage(named: "i_home"))
    }
}
