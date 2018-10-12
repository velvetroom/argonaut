import CleanArchitecture
import MessageUI

class SettingsView:View<SettingsPresenter>, MFMailComposeViewControllerDelegate {
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
        let close = Button(#imageLiteral(resourceName: "iconCancel.pdf"))
        close.addTarget(presenter, action:#selector(presenter.close), for:.touchUpInside)
        let bar = Bar(.local("SettingsView.title"), left:[close])
        view.addSubview(bar)
        
        bar.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        bar.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        
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
        labelName.font = .systemFont(ofSize:16, weight:.medium)
        view.addSubview(labelName)
        
        let labelVersion = UILabel()
        labelVersion.translatesAutoresizingMaskIntoConstraints = false
        labelVersion.isUserInteractionEnabled = false
        labelVersion.textColor = .white
        labelVersion.textAlignment = .center
        labelVersion.numberOfLines = 0
        labelVersion.text = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
        labelVersion.font = .systemFont(ofSize:11, weight:.ultraLight)
        view.addSubview(labelVersion)
        
        let contact = UIButton()
        contact.translatesAutoresizingMaskIntoConstraints = false
        contact.setTitle(NSLocalizedString("SettingsView.contact", comment:String()), for:[])
        contact.setTitleColor(.white, for:.normal)
        contact.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        contact.titleLabel!.font = .systemFont(ofSize:14, weight:.light)
        contact.addTarget(self, action:#selector(email), for:.touchUpInside)
        view.addSubview(contact)
        
        let share = UIButton()
        share.translatesAutoresizingMaskIntoConstraints = false
        share.setTitle(NSLocalizedString("SettingsView.share", comment:String()), for:[])
        share.setTitleColor(.white, for:.normal)
        share.setTitleColor(UIColor(white:0, alpha:0.1), for:.highlighted)
        share.titleLabel!.font = .systemFont(ofSize:14, weight:.light)
        share.addTarget(self, action:#selector(shareUrl), for:.touchUpInside)
        view.addSubview(share)
        
        let review = UIButton()
        review.translatesAutoresizingMaskIntoConstraints = false
        review.setTitle(NSLocalizedString("SettingsView.review", comment:String()), for:[])
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
    }
    
    @objc private func email() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["argonaut@iturbi.de"])
            mail.setSubject(NSLocalizedString("SettingsView.sendEmailSubject", comment:String()))
            mail.setMessageBody(NSLocalizedString("SettingsView.sendEmailBody", comment:String()), isHTML:false)
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
