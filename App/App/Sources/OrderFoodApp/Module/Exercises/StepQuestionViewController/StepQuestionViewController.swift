//
//  StepQuestionViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/11/24.
//

import Foundation
import UIKit
import SnapKit

struct Question {
    let title: String
    let subtitle: String
    let options: [QuestionOption]
}

struct QuestionOption {
    let icon: String
    let text: String
}

class OptionTableViewCell: UITableViewCell {
    static let identifier = "OptionCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.addSubview(optionLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
            make.height.equalTo(56)
        }
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func configure(with option: QuestionOption, isSelected: Bool) {
        iconView.image = UIImage(systemName: option.icon)
        optionLabel.text = option.text
        containerView.backgroundColor = isSelected ? .systemYellow.withAlphaComponent(0.3) : .systemGray6
    }
}

class StepQuestionViewController: UIViewController {
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.register(OptionTableViewCell.self, forCellReuseIdentifier: OptionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    var answers: [String] = []

    private let dummyQuestions: [Question] = [
        Question(
            title: "What's the plan?",
            subtitle: "If you have an idea already, great!\nHere's some inspo, if you need any.",
            options: [
                QuestionOption(icon: "pencil", text: "Write your own"),
                QuestionOption(icon: "cup.and.saucer", text: "Meet for coffee"),
                QuestionOption(icon: "pizza", text: "Let's grab a bite"),
                QuestionOption(icon: "sun.max", text: "Something outdoors"),
                QuestionOption(icon: "music.note", text: "Live music or a show"),
                QuestionOption(icon: "gamecontroller", text: "Games night")
            ]
        ),
        Question(
            title: "What's the vibe?",
            subtitle: "Looking for something cozy or lively?\nPick your ideal vibe.",
            options: [
                QuestionOption(icon: "house", text: "Cozy and relaxed"),
                QuestionOption(icon: "moon", text: "Calm and quiet"),
                QuestionOption(icon: "flame", text: "Hot and exciting"),
                QuestionOption(icon: "sparkles", text: "Fun and vibrant"),
                QuestionOption(icon: "cloud.sun", text: "Easy-going"),
                QuestionOption(icon: "sun.dust", text: "Chill with a breeze")
            ]
        ),
        Question(
            title: "What's your budget?",
            subtitle: "How much are you willing to spend?\nChoose a range that works for you.",
            options: [
                QuestionOption(icon: "creditcard", text: "Under $20"),
                QuestionOption(icon: "creditcard.fill", text: "$20 - $50"),
                QuestionOption(icon: "creditcard.circle", text: "$50 - $100"),
                QuestionOption(icon: "wallet.pass", text: "$100 and above"),
                QuestionOption(icon: "bag", text: "No limit, just feel it out"),
                QuestionOption(icon: "cart", text: "Whatever feels fair")
            ]
        ),
        Question(
            title: "Who are we with?",
            subtitle: "Will this be solo, or a group outing?\nSelect the group size.",
            options: [
                QuestionOption(icon: "person", text: "Solo"),
                QuestionOption(icon: "person.2", text: "Just a couple of us"),
                QuestionOption(icon: "person.3", text: "Small group (3-5 people)"),
                QuestionOption(icon: "person.3.fill", text: "Medium group (6-10 people)"),
                QuestionOption(icon: "person.3.circle", text: "Large group (10+ people)"),
                QuestionOption(icon: "person.2.fill", text: "Big celebration!")
            ]
        ),
        Question(
            title: "What's your activity level?",
            subtitle: "Are you up for something active or just chilling?\nPick your style.",
            options: [
                QuestionOption(icon: "figure.walk", text: "Active and energetic"),
                QuestionOption(icon: "figure.run", text: "Workout time"),
                QuestionOption(icon: "figure.snowboard", text: "Outdoor adventure"),
                QuestionOption(icon: "snow", text: "Chill and relaxed"),
                QuestionOption(icon: "bicycle", text: "Cycling or something sporty"),
                QuestionOption(icon: "hand.raised", text: "Dance or movement")
            ]
        ),
        Question(
            title: "How much time do we have?",
            subtitle: "Are we on a time crunch or do we have the whole day?\nSelect the time frame.",
            options: [
                QuestionOption(icon: "clock", text: "Less than an hour"),
                QuestionOption(icon: "clock.fill", text: "1-2 hours"),
                QuestionOption(icon: "clock.arrow.2.circlepath", text: "Half day"),
                QuestionOption(icon: "sunset", text: "A few hours"),
                QuestionOption(icon: "sunrise", text: "Whole day"),
                QuestionOption(icon: "moon.stars", text: "Overnight plans")
            ]
        ),
        Question(
            title: "What kind of food are you feeling?",
            subtitle: "Hoping for something specific?\nSelect your food mood.",
            options: [
                QuestionOption(icon: "burger", text: "Burgers and fries"),
                QuestionOption(icon: "pizza", text: "Pizza night"),
                QuestionOption(icon: "leaf.arrow.triangle.circlepath", text: "Healthy and fresh"),
                QuestionOption(icon: "taco", text: "Mexican food"),
                QuestionOption(icon: "sushi", text: "Sushi and Japanese"),
                QuestionOption(icon: "cupcake", text: "Sweet treats")
            ]
        )
    ]

    
    private var currentQuestionIndex = 0
    private var selectedOptionIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateTime()
        displayCurrentQuestion()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(timeLabel)
        view.addSubview(questionLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(tableView)
        view.addSubview(nextButton)
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func updateTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: Date())
    }
    
    private func displayCurrentQuestion() {
        guard currentQuestionIndex < dummyQuestions.count else { return }
        
        let question = dummyQuestions[currentQuestionIndex]
        questionLabel.text = question.title
        subtitleLabel.text = question.subtitle
        selectedOptionIndex = nil
        tableView.reloadData()
    }
    
    @objc private func nextButtonTapped() {
        if currentQuestionIndex <= dummyQuestions.count {
            currentQuestionIndex += 1
            displayCurrentQuestion()
        } else {
            print("answer \(answers)")
            print("navigation to other")
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension StepQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyQuestions[currentQuestionIndex].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.identifier, for: indexPath) as? OptionTableViewCell else {
            return UITableViewCell()
        }
        
        let option = dummyQuestions[currentQuestionIndex].options[indexPath.row]
        let isSelected = selectedOptionIndex == indexPath.row
        cell.configure(with: option, isSelected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOptionIndex = indexPath.row
        guard currentQuestionIndex < dummyQuestions.count else { return }
        let question = dummyQuestions[currentQuestionIndex]
        answers.append(question.options[indexPath.row].text)
        tableView.reloadData()
    }
}
