import CleanArchitecture
import Argonaut
import MarkdownHero

class HomePresenter:Presenter {
    private let map = Map()
    private let session = Factory.makeSession()
    private let parser = Parser()
    private let formatter = DateComponentsFormatter()
    
    func refresh() { session.load { [weak self] (projects:[Project]) in self?.loaded(projects:projects) } }
    
    func deleteConfirm(project:Project) {
        Application.navigation.dismiss(animated:true)
        session.delete(project:project)
        refresh()
    }
    
    @objc func planMap() {
        Application.navigation.pushViewController(PlanView(), animated:true)
    }
    
    @objc func open(cell:HomeCellView) {
        DispatchQueue.global(qos:.background).async { [weak self] in self?.makeWidget(project:cell.viewModel.project) }
        let view = TravelView()
        view.presenter.project = cell.viewModel.project
        Application.navigation.setViewControllers([view], animated:true)
    }
    
    @objc func settings() {
        Application.navigation.setViewControllers([SettingsView()], animated:true)
    }
    
    @objc func delete(button:UIButton) {
        let view = HomeDeleteView(presenter:self)
        view.viewModel = (button.superview as! HomeCellView).viewModel
        Application.navigation.present(view, animated:true)
    }
    
    @objc func deleteCancel() {
        Application.navigation.dismiss(animated:true)
    }
    
    override func didLoad() {
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute, .hour]
    }
    
    override func didAppear() {
        DispatchQueue.global(qos:.background).async { Widget.remove() }
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
    
    private func loaded(projects:[Project]) {
        var viewModel = Home()
        if projects.isEmpty {
            viewModel.buttonHidden = false
            viewModel.iconHidden = false
        } else {
            viewModel.items = makeItems(projects:projects)
        }
        update(viewModel:viewModel)
        DispatchQueue.global(qos:.background).async { [weak self] in self?.map.cleanDisk() }
    }
    
    private func makeItems(projects:[Project]) -> [HomeItem] {
        return projects.sorted { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending }.map { project in
            var item = HomeItem()
            item.title = makeTitle(project:project)
            item.project = project
            return item
        }
    }
    
    private func makeWidget(project:Project) {
        let widget = Widget()
        widget.origin = make(mark:project.origin)
        widget.destination = make(mark:project.destination)
        widget.store()
    }
    
    private func make(mark:Mark) -> WidgetMark {
        var widget = WidgetMark()
        widget.title = mark.title
        widget.latitude = mark.point.latitude
        widget.longitude = mark.point.longitude
        return widget
    }
}
