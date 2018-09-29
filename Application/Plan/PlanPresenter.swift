import CleanArchitecture
import MapKit

class PlanPresenter:Presenter {
    func make(plan:[MKAnnotation]) {
        let view = MakeView()
        view.presenter.plan = plan
        Application.navigation.pushViewController(view, animated:true)
    }
    
    @available(iOS 9.3, *)
    func update(results:[MKLocalSearchCompletion]) {
        DispatchQueue.global(qos:.background).async { [weak self] in self?.safeUpdate(results:results) }
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
