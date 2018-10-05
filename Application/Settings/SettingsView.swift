import CleanArchitecture
import MarkdownHero

class SettingsView:View<SettingsPresenter> {
    private let parser = Parser()
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeOutlets()
    }
    
    private func makeOutlets() {
        let close = Button(image:#imageLiteral(resourceName: "iconCancel.pdf"))
        close.addTarget(presenter, action:#selector(presenter.close), for:.touchUpInside)
        let bar = Bar(.local("SettingsView.title"), left:[close])
        view.addSubview(bar)
        
        let clean = UIView()
        clean.translatesAutoresizingMaskIntoConstraints = false
        clean.backgroundColor = .midnightBlue
        clean.clipsToBounds = true
        clean.layer.cornerRadius = 6
        view.addSubview(clean)
        
        let cleanMessage = UILabel()
        cleanMessage.isUserInteractionEnabled = false
        cleanMessage.translatesAutoresizingMaskIntoConstraints = false
        cleanMessage.numberOfLines = 0
        cleanMessage.textColor = .white
        clean.addSubview(cleanMessage)
        
        bar.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        clean.topAnchor.constraint(equalTo:bar.bottomAnchor, constant:20).isActive = true
        clean.leftAnchor.constraint(equalTo:bar.leftAnchor, constant:20).isActive = true
        clean.rightAnchor.constraint(equalTo:bar.rightAnchor, constant:-20).isActive = true
        clean.heightAnchor.constraint(equalToConstant:100).isActive = true
        
        cleanMessage.topAnchor.constraint(equalTo:clean.topAnchor, constant:20).isActive = true
        cleanMessage.leftAnchor.constraint(equalTo:clean.leftAnchor, constant:20).isActive = true
        
        if #available(iOS 11.0, *) {
            bar.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            bar.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
        
        parser.parse(string:.local("SettingsView.clean")) { [weak cleanMessage] string in
            cleanMessage?.attributedText = string
        }
    }
}
