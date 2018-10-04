import CleanArchitecture
import Argonaut
import MarkdownHero

class HomePresenter:Presenter {
    private let session = Factory.makeSession()
    private let parser = Parser()
    private let formatter = DateComponentsFormatter()
    
    @objc func map() {
        Application.navigation.pushViewController(PlanView(), animated:true)
    }
    
    @objc func open(cell:HomeCellView) {
        let view = TravelView()
        view.presenter.project = cell.viewModel.project
        Application.navigation.setViewControllers([view], animated:true)
    }
    
    @objc func settings() {
        Application.navigation.setViewControllers([SettingsView()], animated:true)
    }
    
    override func didLoad() {
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute, .hour]
    }
    
    override func didAppear() {
        session.load { [weak self] (projects:[Project]) in
            let items = projects.map { project -> HomeItem in
                var item = HomeItem()
                if let title = self?.makeTitle(project:project) { item.title = title }
                item.project = project
                return item
            }
            self?.update(viewModel:items)
        }
    }
    
    private func makeTitle(project:Project) -> NSAttributedString {
        var string = "**\(project.name)**\n"
        string += formatter.string(from:project.duration)!
        if #available(iOS 10.0, *) {
            let distance = MeasurementFormatter()
            distance.unitStyle = .medium
            distance.unitOptions = .naturalScale
            distance.numberFormatter.maximumFractionDigits = 1
            string += " - " + distance.string(from:Measurement(value:project.distance, unit:UnitLength.meters))
        }
        return parser.parse(string:string)
    }
}
