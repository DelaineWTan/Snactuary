//
//  StatsUIView.swift
//  Pet Bullet Heaven
//
//  Created by Faiz on 11-04-2024.
//
import UIKit

class StatsUIView: UIView {
    var mainMenuButtonTappedHandler: (() -> Void)?
    
    lazy var mainMenuButton: UIButton = {
        let button = Utilities.makeButton(title: "Main Menu", image: UIImage(named: "cloud_pink.png"), backgroundColor: .blue, target: self, action: #selector(mainMenuButtonTapped))
        return button
    }()
    
    // Labels to display statistics
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .white
        label.text = "Statistics"
        return label
    }()
    
    let totalScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.text = ("Total Score: \(Globals.totalScore)")
        return label
    }()
    
    let stagesPassedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.text = ("Stages Passed: \(Globals.stagesPassed)")
        return label
    }()
    
    let snacksEatenLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.text = ("Snacks Eaten: \(Globals.snacksEaten)")
        return label
    }()
    
    let damageDoneLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.text = ("Damage Done: \(Globals.damageDone)")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(totalScoreLabel)
        addSubview(stagesPassedLabel)
        addSubview(snacksEatenLabel)
        addSubview(damageDoneLabel)
        addSubview(mainMenuButton)
        
        // Layout constraints for labels
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
        
        totalScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalScoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            totalScoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
        ])
        
        stagesPassedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stagesPassedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stagesPassedLabel.topAnchor.constraint(equalTo: totalScoreLabel.bottomAnchor, constant: 30)
        ])
        
        snacksEatenLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            snacksEatenLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            snacksEatenLabel.topAnchor.constraint(equalTo: stagesPassedLabel.bottomAnchor, constant: 30)
        ])
        
        damageDoneLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            damageDoneLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            damageDoneLabel.topAnchor.constraint(equalTo: snacksEatenLabel.bottomAnchor, constant: 30)
        ])
        
        // Layout constraints for buttons
        mainMenuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainMenuButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainMenuButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            mainMenuButton.widthAnchor.constraint(equalToConstant: 147),
            mainMenuButton.heightAnchor.constraint(equalToConstant: 98)
        ])
    }
    
    func updateStatistics() {
        totalScoreLabel.text = "Total Score: \(Globals.totalScore)"
        stagesPassedLabel.text = "Stages Passed: \(Globals.stagesPassed)"
        snacksEatenLabel.text = "Snacks Eaten: \(Globals.snacksEaten)"
        damageDoneLabel.text = "Damage Done: \(Globals.damageDone)"
    }
    
    @objc private func mainMenuButtonTapped() {
        mainMenuButtonTappedHandler?()
    }
}
