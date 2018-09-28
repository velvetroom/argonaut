import CleanArchitecture
import Argonaut
import MapKit

class PlanPresenter:Presenter {
    private let map = Map()
    
    @available(iOS 9.3, *)
    func update(results:[MKLocalSearchCompletion]) {
        DispatchQueue.global(qos:.background).async { [weak self] in self?.safeUpdate(results:results) }
    }
    
    func save(rect:MKMapRect) {
        map.onSuccess = { url in
            let view = TestView()
            view.url = url
            Application.navigation.pushViewController(view, animated:true)
        }
        map.onFail = { error in
            print(error)
        }
        map.makeMap(rect:rect)
    }
    
    @available(iOS 9.3, *)
    private func safeUpdate(results:[MKLocalSearchCompletion]) {
        update(viewModel:results.map { result -> (NSAttributedString, MKLocalSearchCompletion) in
            let title = NSMutableAttributedString(string:result.title, attributes:
                [.font:UIFont.systemFont(ofSize:13, weight:.ultraLight)])
            let subtitle = NSMutableAttributedString(string:result.subtitle, attributes:
                [.font:UIFont.systemFont(ofSize:11, weight:.ultraLight)])
            result.titleHighlightRanges.forEach { range in
                title.addAttribute(.font, value:UIFont.systemFont(ofSize:13, weight:.bold), range:range as! NSRange)
            }
            result.subtitleHighlightRanges.forEach { range in
                subtitle.addAttribute(.font, value:UIFont.systemFont(ofSize:11, weight:.bold), range:range as! NSRange)
            }
            let string = NSMutableAttributedString()
            string.append(title)
            string.append(NSAttributedString(string:"\n"))
            string.append(subtitle)
            return (string, result)
        })
    }
}
