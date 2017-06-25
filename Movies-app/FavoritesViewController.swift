
import UIKit
import XLPagerTabStrip

class FavoritesViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Favorites")//, image: UIImage(named: "i_favorites"))
    }
}
