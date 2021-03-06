import CleanArchitecture
import MarkdownHero
import MessageUI

class SettingsView:View<SettingsPresenter>, MFMailComposeViewControllerDelegate {
    private let hero = Hero()
    private let url = "itunes.apple.com/\(Locale.current.regionCode!.lowercased())/app/argonaut/id1436394937"
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeOutlets()
    }
    
    func mailComposeController(_:MFMailComposeViewController, didFinishWith:MFMailComposeResult, error:Error?) {
        Application.navigation.dismiss(animated:true)
    }
    
    private func makeOutlets() {
        let close = Button(#imageLiteral(resourceName: "iconSave.pdf"))
        close.addTarget(presenter, action:#selector(presenter.close), for:.touchUpInside)
        let bar = Bar(.local("SettingsView.title"), right:[close])
        view.addSubview(bar)
        
        bar.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = false
        icon.clipsToBounds = true
        icon.image = #imageLiteral(resourceName: "iconLogo.pdf")
        icon.contentMode = .center
        view.addSubview(icon)
        
        let labelName = UILabel()
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.isUserInteractionEnabled = false
        labelName.textColor = .white
        labelName.textAlignment = .center
        labelName.text = .local("SettingsView.labelName")
        labelName.font = .systemFont(ofSize:18, weight:.medium)
        view.addSubview(labelName)
        
        let labelVersion = UILabel()
        labelVersion.translatesAutoresizingMaskIntoConstraints = false
        labelVersion.isUserInteractionEnabled = false
        labelVersion.textColor = .white
        labelVersion.textAlignment = .center
        labelVersion.numberOfLines = 0
        labelVersion.text = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
        labelVersion.font = .systemFont(ofSize:10, weight:.ultraLight)
        view.addSubview(labelVersion)
        
        let contact = UIButton()
        contact.translatesAutoresizingMaskIntoConstraints = false
        contact.setTitle(.local("SettingsView.contact"), for:[])
        contact.setTitleColor(.white, for:.normal)
        contact.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        contact.titleLabel!.font = .systemFont(ofSize:14, weight:.light)
        contact.addTarget(self, action:#selector(email), for:.touchUpInside)
        view.addSubview(contact)
        
        let share = UIButton()
        share.translatesAutoresizingMaskIntoConstraints = false
        share.setTitle(.local("SettingsView.share"), for:[])
        share.setTitleColor(.white, for:.normal)
        share.setTitleColor(UIColor(white:0, alpha:0.1), for:.highlighted)
        share.titleLabel!.font = .systemFont(ofSize:14, weight:.light)
        share.addTarget(self, action:#selector(shareUrl), for:.touchUpInside)
        view.addSubview(share)
        
        let review = UIButton()
        review.translatesAutoresizingMaskIntoConstraints = false
        review.setTitle(.local("SettingsView.review"), for:[])
        review.setTitleColor(.white, for:.normal)
        review.setTitleColor(UIColor(white:0, alpha:0.1), for:.highlighted)
        review.titleLabel!.font = .systemFont(ofSize:14, weight:.light)
        review.addTarget(self, action:#selector(reviewUrl), for:.touchUpInside)
        view.addSubview(review)
        
        let separatorLeft = UIView()
        separatorLeft.translatesAutoresizingMaskIntoConstraints = false
        separatorLeft.isUserInteractionEnabled = false
        separatorLeft.backgroundColor = UIColor(white:1, alpha:0.2)
        view.addSubview(separatorLeft)
        
        let separatorRight = UIView()
        separatorRight.translatesAutoresizingMaskIntoConstraints = false
        separatorRight.isUserInteractionEnabled = false
        separatorRight.backgroundColor = UIColor(white:1, alpha:0.2)
        view.addSubview(separatorRight)
        
        let labelHq = UILabel()
        labelHq.translatesAutoresizingMaskIntoConstraints = false
        labelHq.isUserInteractionEnabled = false
        labelHq.numberOfLines = 0
        labelHq.textColor = .white
        labelHq.attributedText = hero.parse(string:.local("SettingsView.labelHq"))
        view.addSubview(labelHq)
        
        let hq = UISwitch()
        hq.translatesAutoresizingMaskIntoConstraints = false
        hq.onTintColor = .greekBlue
        hq.tintColor = .greekBlue
        hq.setOn(presenter.profile.highQuality, animated:false)
        hq.addTarget(presenter, action:#selector(presenter.hqChange(hq:)), for:.valueChanged)
        view.addSubview(hq)
        
        icon.topAnchor.constraint(equalTo:bar.bottomAnchor, constant:60).isActive = true
        icon.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant:75).isActive = true
        icon.heightAnchor.constraint(equalToConstant:75).isActive = true
        
        labelName.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo:icon.bottomAnchor, constant:10).isActive = true
        
        labelVersion.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        labelVersion.topAnchor.constraint(equalTo:labelName.bottomAnchor).isActive = true
        
        contact.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        contact.topAnchor.constraint(equalTo:labelVersion.bottomAnchor, constant:50).isActive = true
        contact.widthAnchor.constraint(equalToConstant:105).isActive = true
        contact.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        share.rightAnchor.constraint(equalTo:contact.leftAnchor).isActive = true
        share.topAnchor.constraint(equalTo:contact.topAnchor).isActive = true
        share.widthAnchor.constraint(equalTo:contact.widthAnchor).isActive = true
        share.heightAnchor.constraint(equalTo:contact.heightAnchor).isActive = true
        
        review.leftAnchor.constraint(equalTo:contact.rightAnchor).isActive = true
        review.topAnchor.constraint(equalTo:contact.topAnchor).isActive = true
        review.widthAnchor.constraint(equalTo:contact.widthAnchor).isActive = true
        review.heightAnchor.constraint(equalTo:contact.heightAnchor).isActive = true
        
        separatorLeft.centerYAnchor.constraint(equalTo:contact.centerYAnchor).isActive = true
        separatorLeft.rightAnchor.constraint(equalTo:contact.leftAnchor).isActive = true
        separatorLeft.widthAnchor.constraint(equalToConstant:1).isActive = true
        separatorLeft.heightAnchor.constraint(equalToConstant:14).isActive = true
        
        separatorRight.centerYAnchor.constraint(equalTo:contact.centerYAnchor).isActive = true
        separatorRight.leftAnchor.constraint(equalTo:contact.rightAnchor).isActive = true
        separatorRight.widthAnchor.constraint(equalToConstant:1).isActive = true
        separatorRight.heightAnchor.constraint(equalToConstant:14).isActive = true
        
        hq.topAnchor.constraint(equalTo:contact.bottomAnchor, constant:80).isActive = true
        hq.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-20).isActive = true
        
        labelHq.topAnchor.constraint(equalTo:hq.topAnchor).isActive = true
        labelHq.leftAnchor.constraint(equalTo:view.leftAnchor, constant:20).isActive = true
        labelHq.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-20).isActive = true
        
        if #available(iOS 11.0, *) {
            bar.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            bar.topAnchor.constraint(equalTo:view.topAnchor, constant:20).isActive = true
        }
    }
    
    @objc private func email() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["argonaut@iturbi.de"])
            mail.setSubject(.local("SettingsView.sendEmailSubject"))
            mail.setMessageBody(.local("SettingsView.sendEmailBody"), isHTML:false)
            Application.navigation.present(mail, animated:true)
        } else {
            let alert = UIAlertController(
                title:.local("SettingsView.sendEmailFailed"), message:nil, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title:.local("SettingsView.sendEmailContinue"), style:.default, handler:nil))
            Application.navigation.present(alert, animated:true)
        }
    }
    
    @objc private func shareUrl() {
        let view = UIActivityViewController(activityItems:[URL(string:"https://\(url)")!], applicationActivities:nil)
        if let popover = view.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = .zero
            popover.permittedArrowDirections = .any
        }
        Application.navigation.present(view, animated:true)
    }
    
    @objc private func reviewUrl() {
        UIApplication.shared.openURL(URL(string:"itms-apps://\(url)")!)
    }
}
