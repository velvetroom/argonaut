import CleanArchitecture

class HomePresenter:Presenter {
    override func didAppear() {
        update(viewModel:[HomeItem()])
    }
}
