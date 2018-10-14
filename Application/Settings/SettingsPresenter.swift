import CleanArchitecture
import Argonaut

class SettingsPresenter:Presenter {
    let profile = Factory.makeSession().profile()
    
    @objc func close() {
        Application.navigation.setViewControllers([HomeView()], animated:true)
    }
    
    @objc func hqChange(hq:UISwitch) {
        profile.highQuality = hq.isOn
        Factory.makeSession().save()
    }
}
