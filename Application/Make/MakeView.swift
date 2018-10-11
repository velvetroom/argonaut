import CleanArchitecture
import MarkdownHero

class MakeView:View<MakePresenter> {
    private weak var progress:UIProgressView!
    private weak var load:LoadingView!
    private weak var error:UIImageView!
    private weak var retry:ButtonBlue!
    private weak var message:UILabel!
    private let hero = Hero()
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        makeOutlets()
        configureViewModel()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated:Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func makeOutlets() {
        let load = LoadingView()
        load.tintColor = .white
        view.addSubview(load)
        self.load = load
        
        let error = UIImageView(image:#imageLiteral(resourceName: "iconError.pdf"))
        error.clipsToBounds = true
        error.contentMode = .center
        error.translatesAutoresizingMaskIntoConstraints = false
        error.isUserInteractionEnabled = false
        error.isHidden = true
        view.addSubview(error)
        self.error = error
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        view.addSubview(label)
        hero.parse(string:.local("MakeView.label")) { [weak label] string in label?.attributedText = string }
        
        let message = UILabel()
        message.isUserInteractionEnabled = false
        message.translatesAutoresizingMaskIntoConstraints = false
        message.textColor = .white
        message.numberOfLines = 0
        message.textAlignment = .center
        view.addSubview(message)
        self.message = message
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.setTitle(.local("MakeView.cancel"), for:[])
        cancel.setTitleColor(UIColor(white:1, alpha:0.6), for:.normal)
        cancel.setTitleColor(UIColor(white:1, alpha:0.2), for:.highlighted)
        cancel.titleLabel!.font = .systemFont(ofSize:14, weight:.regular)
        cancel.addTarget(presenter, action:#selector(presenter.cancel), for:.touchUpInside)
        view.addSubview(cancel)
        
        let retry = ButtonBlue(.local("MakeView.retry"))
        retry.addTarget(presenter, action:#selector(presenter.retry), for:.touchUpInside)
        retry.isHidden = true
        view.addSubview(retry)
        self.retry = retry
        
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.trackTintColor = UIColor(white:1, alpha:0.1)
        progress.progressTintColor = .white
        progress.isUserInteractionEnabled = false
        view.addSubview(progress)
        self.progress = progress
        
        load.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        load.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        error.centerXAnchor.constraint(equalTo:load.centerXAnchor).isActive = true
        error.centerYAnchor.constraint(equalTo:load.centerYAnchor).isActive = true
        error.widthAnchor.constraint(equalToConstant:75).isActive = true
        error.heightAnchor.constraint(equalToConstant:75).isActive = true
        
        label.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        
        cancel.heightAnchor.constraint(equalToConstant:50).isActive = true
        cancel.widthAnchor.constraint(equalToConstant:120).isActive = true
        cancel.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        
        progress.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        progress.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        progress.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        progress.heightAnchor.constraint(equalToConstant:10).isActive = true
        
        message.widthAnchor.constraint(equalToConstant:300).isActive = true
        message.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        message.bottomAnchor.constraint(equalTo:retry.topAnchor, constant:-30).isActive = true
        
        retry.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        retry.bottomAnchor.constraint(equalTo:cancel.topAnchor, constant:-60).isActive = true
        
        if #available(iOS 11.0, *) {
            label.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:30).isActive = true
            cancel.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor, constant:-50).isActive = true
        } else {
            label.topAnchor.constraint(equalTo:view.topAnchor, constant:30).isActive = true
            cancel.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-50).isActive = true
        }
    }
    
    private func configureViewModel() {
        presenter.viewModel { [weak self] (progress:Float) in
            self?.progress.setProgress(progress, animated:true)
        }
        presenter.viewModel { [weak self] (viewModel:Make) in
            self?.load.isHidden = viewModel.loadHidden
            self?.error.isHidden = viewModel.errorHidden
            self?.retry.isHidden = viewModel.retryHidden
            self?.message.attributedText = viewModel.message
        }
    }
}
