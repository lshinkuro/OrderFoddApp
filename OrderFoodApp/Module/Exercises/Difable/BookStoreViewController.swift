//
//  BookStoreViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/10/24.
//

import UIKit
import IQKeyboardManagerSwift
import SnapKit


// MARK: - Models
struct Profile: Hashable {
    let id = UUID()
    var name: String
    var email: String
}

struct Setting: Hashable {
    let id: String // Ganti dari UUID menjadi String
    let title: String
    var isEnabled: Bool

    init(id: String, title: String, isEnabled: Bool) {
        self.id = id
        self.title = title
        self.isEnabled = isEnabled
    }
}

struct TextInput: Hashable {
    let id: String // Ganti UUID ke String
    let placeholder: String
    var text: String

    init(id: String, placeholder: String, text: String) {
        self.id = id
        self.placeholder = placeholder
        self.text = text
    }
}

enum Section: Hashable {
    case profile, settings, input, actions
    
    var title: String {
        switch self {
        case .profile: return "Profile"
        case .settings: return "Settings"
        case .input: return "Input"
        case .actions: return "Actions"
        }
    }
}

enum Item: Hashable {
    case profile(Profile)
    case setting(Setting)
    case textInput(TextInput)
    case action(String)
}

// MARK: - View Controller
class BookStoreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: UITableViewDiffableDataSource<Section, Item>!
    private var activeTextField: UITextField?
    
    // Sample data
    private var profile = Profile(name: "John Doe", email: "john@example.com")
    private var settings = [
        Setting(id: "notifications", title: "Notifications", isEnabled: true),
        Setting(id: "darkMode", title: "Dark Mode", isEnabled: false),
        Setting(id: "autoUpdate", title: "Auto Update", isEnabled: true)
    ]
    private var textInputs = [
        TextInput(id: "username", placeholder: "Enter Username", text: ""),
        TextInput(id: "bio", placeholder: "Enter Bio", text: "")
    ]
    private let actions = ["Save", "Reset", "Share"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureDataSource()
        applyInitialSnapshot()
        setupKeyboardHandling()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.reuseIdentifier)
        tableView.register(InputCell.self, forCellReuseIdentifier: InputCell.reuseIdentifier)
        tableView.register(ActionCell.self, forCellReuseIdentifier: ActionCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupKeyboardHandling() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - DataSource Configuration
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { [weak self] tableView, indexPath, item in
            return self?.cell(for: item, at: indexPath)
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    private func cell(for item: Item, at indexPath: IndexPath) -> UITableViewCell? {
        switch item {
        case .profile(let profile):
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as! ProfileCell
            cell.configure(with: profile)
            return cell
        case .setting(let setting):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath) as! SettingCell
            cell.configure(with: setting) { [weak self] isEnabled in
                self?.handleSettingToggle(setting, isEnabled: isEnabled)
            }
            return cell
        case .textInput(let input):
            let cell = tableView.dequeueReusableCell(withIdentifier: InputCell.reuseIdentifier, for: indexPath) as! InputCell
            cell.configure(with: input) { [weak self] text in
                self?.handleTextInput(input, newText: text)
            }
            cell.textField.delegate = self
            return cell
        case .action(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: ActionCell.reuseIdentifier, for: indexPath) as! ActionCell
            cell.configure(with: title)
            return cell
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.profile, .settings, .input, .actions])
        snapshot.appendItems([.profile(profile)], toSection: .profile)
        snapshot.appendItems(settings.map { .setting($0) }, toSection: .settings)
        snapshot.appendItems(textInputs.map { .textInput($0) }, toSection: .input)
        snapshot.appendItems(actions.map { .action($0) }, toSection: .actions)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
   
    
    // Update individual item only without full reload
    private func handleSettingToggle(_ setting: Setting, isEnabled: Bool) {
        guard let index = settings.firstIndex(where: { $0.id == setting.id }) else { return }
         settings[index].isEnabled = isEnabled

         var snapshot = dataSource.snapshot()
         let item = Item.setting(settings[index])

         if snapshot.itemIdentifiers.contains(item) {
             snapshot.reloadItems([item])
             dataSource.apply(snapshot, animatingDifferences: true)
         }
    }

    // Delayed TextField update to prevent rapid refreshing on each keystroke
    private var textUpdateWorkItem: DispatchWorkItem?

    private func handleTextInput(_ input: TextInput, newText: String) {
        guard let index = textInputs.firstIndex(where: { $0.id == input.id }) else { return }
        textInputs[index].text = newText
        
        var snapshot = dataSource.snapshot()
        let item = Item.textInput(textInputs[index])

        if snapshot.itemIdentifiers.contains(item) {
            snapshot.reloadItems([item])
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let activeTextField = activeTextField else { return }
        
        let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: view).maxY
        let topOfKeyboard = view.frame.height - keyboardSize.height
        if bottomOfTextField > topOfKeyboard {
            view.frame.origin.y = -(bottomOfTextField - topOfKeyboard + 10)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

// MARK: - UITableViewDelegate
extension BookStoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if case .action(let title) = dataSource.itemIdentifier(for: indexPath) {
            print("Action tapped: \(title)")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UITextFieldDelegate
extension BookStoreViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - Custom Cells
class ProfileCell: UITableViewCell {
    static let reuseIdentifier = "ProfileCell"
    
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let imageProfile = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(imageProfile)
        contentView.addSubview(stackView)
        imageProfile.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(100)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageProfile.snp.bottom).offset(10)
            make.verticalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emailLabel.font = .systemFont(ofSize: 14)
        emailLabel.textColor = .secondaryLabel
        
        imageProfile.contentMode = .scaleAspectFill
    }
    
    func configure(with profile: Profile) {
        nameLabel.text = profile.name
        emailLabel.text = profile.email
        imageProfile.image =  UIImage(named: "ads1")
    }
}

class SettingCell: UITableViewCell {
    static let reuseIdentifier = "SettingCell"
    
    private let titleLabel = UILabel()
    private let toggle = UISwitch()
    private var toggleHandler: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 16)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggle)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        toggle.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
    }
    
    func configure(with setting: Setting, handler: @escaping (Bool) -> Void) {
        titleLabel.text = setting.title
        toggle.isOn = setting.isEnabled
        toggleHandler = handler
    }
    
    @objc private func toggleChanged() {
        toggleHandler?(toggle.isOn)
    }
}

class InputCell: UITableViewCell {
    static let reuseIdentifier = "InputCell"
    
    let textField = UITextField()
    private var textChangeHandler: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
            make.height.equalTo(40)
        }
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func configure(with input: TextInput, handler: @escaping (String) -> Void) {
        textField.placeholder = input.placeholder
        textField.text = input.text
        textChangeHandler = handler
    }
    
    @objc private func textFieldDidChange() {
        textChangeHandler?(textField.text ?? "")
    }
}

class ActionCell: UITableViewCell {
    static let reuseIdentifier = "ActionCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        textLabel?.textAlignment = .center
        textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        textLabel?.textColor = .systemBlue
    }
    
    func configure(with title: String) {
        textLabel?.text = title
    }
}
