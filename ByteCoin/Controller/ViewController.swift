import UIKit

class ViewController: UIViewController {
    var coinManager = CoinManager()
    
    let titleLabel = UILabel().then {
        $0.text = "ByteCoin"
        $0.font = .systemFont(ofSize: 50, weight: .thin)
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "Title Color")
    }
    
    let bitcoinLabel = UILabel().then {
        $0.text = "..."
        $0.textColor = .white
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 25)
    }
    
    let imageView = UIImageView(image: UIImage(systemName: "bitcoinsign.circle.fill")).then {
        $0.tintColor = UIColor(named: "Icon Color")
    }
    
    let currencyLabel = UILabel().then {
        $0.text = "USD"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 25)
    }
    
    let currencyPicker = UIPickerView()
    
    lazy var titleStack = UIStackView(arrangedSubviews: [imageView, bitcoinLabel, currencyLabel]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 10
    }
    
    lazy var titleView = UIView().then {
        $0.addSubview(titleStack)
        $0.backgroundColor = .tertiaryLabel
        $0.layer.cornerRadius = 40
    }
    
    lazy var stack = UIStackView(arrangedSubviews: [titleLabel, titleView, UIView(), currencyPicker]).then {
        $0.spacing = 25
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        configureAppearance()
    }
}

extension ViewController {
    func setupViews() {
        view.addSubview(stack)
    }
    
    func layoutViews() {
        let margin = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: margin.topAnchor),
            stack.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
            titleStack.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleStack.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleStack.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -10),
            titleStack.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            currencyPicker.heightAnchor.constraint(equalToConstant: 216),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80)
            
            
        ])
    }
    
    func configureAppearance() {
        view.backgroundColor = UIColor(named: "Background Color")
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        coinManager.delegate = self
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
}

extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
}
