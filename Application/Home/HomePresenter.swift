import CleanArchitecture
import Argonaut
import MarkdownHero

class HomePresenter:Presenter {
    private let session = Factory.makeSession()
    private let hero = Hero()
    private let formatter = DateComponentsFormatter()
    
    func refresh() { session.load { [weak self] (projects:[Project]) in self?.loaded(projects:projects) } }
    
    func delete(item:HomeItem) {
        let view = HomeDeleteView(presenter:self)
        view.viewModel = item
        Application.navigation.present(view, animated:true)
    }
    
    func deleteConfirm(project:Project) {
        Application.navigation.dismiss(animated:true)
        session.delete(project:project)
        refresh()
    }
    
    func viewFor(cell:HomeCellView) -> TravelView {
        let view = TravelView()
        view.presenter.project = cell.viewModel.project
        return view
    }
    
    @objc func planMap() {
        Application.navigation.pushViewController(PlanView(), animated:true)
    }
    
    @objc func open(cell:HomeCellView) {
        Application.navigation.setViewControllers([viewFor(cell:cell)], animated:true)
    }
    
    @objc func settings() {
        Application.navigation.setViewControllers([SettingsView()], animated:true)
    }
    
    @objc func delete(button:UIButton) {
        delete(item:(button.superview as! HomeCellView).viewModel)
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
            distance.unitStyle = .long
            distance.unitOptions = .naturalScale
            distance.numberFormatter.maximumFractionDigits = 1
            string += " - " + distance.string(from:Measurement(value:project.distance, unit:UnitLength.meters))
        }
        return hero.parse(string:string)
    }
    
    private func loaded(projects:[Project]) {
        let projects = projects.sorted { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending }
        var viewModel = Home()
        if projects.isEmpty {
            viewModel.buttonHidden = false
            viewModel.iconHidden = false
        } else {
            viewModel.items = makeItems(projects:projects)
        }
        update(viewModel:viewModel)
        makeShortcuts(projects:projects)
        Map().cleanDisk()
    }
    
    private func makeItems(projects:[Project]) -> [HomeItem] {
        return projects.map { project in
            var item = HomeItem()
            item.title = makeTitle(project:project)
            item.project = project
            return item
        }
    }
    
    private func makeShortcuts(projects:[Project]) {
        let icon:UIApplicationShortcutIcon
        if #available(iOS 9.1, *) {
            icon = UIApplicationShortcutIcon(type:.markLocation)
        } else {
            icon = UIApplicationShortcutIcon(type:.location)
        }
        UIApplication.shared.shortcutItems = projects.map { project in
            return UIApplicationShortcutItem(type:"argonaut.map", localizedTitle:project.name, localizedSubtitle:nil,
                                             icon:icon, userInfo:["id":project.id as NSSecureCoding])
        }
    }
}
