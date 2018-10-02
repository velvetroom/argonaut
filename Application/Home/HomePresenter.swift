import CleanArchitecture

class HomePresenter:Presenter {
    @objc func map() {
        Application.navigation.pushViewController(PlanView(), animated:true)
    }
    
    override func didAppear() {
        update(viewModel:[HomeItem()])
    }
}
