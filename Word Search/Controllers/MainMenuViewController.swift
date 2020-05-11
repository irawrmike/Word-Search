//
//  ViewController.swift
//  Word Search
//
//  Created by Mike Stoltman on 2020-05-06.
//  Copyright © 2020 Mike Stoltman. All rights reserved.
//

import SpriteKit

class MainMenuViewController: UIViewController {
    
    private var backgroundSceneView: SKView!
    
    private var containerView: UIView!
    
    private var logoView: UIImageView!
    
    private var easyButton: UIButton!
    private var easyButtonBackground: UIView!
    private var easyButtonLabel: UILabel!
    
    private var normalButton: UIButton!
    private var normalButtonBackground: UIView!
    private var normalButtonLabel: UILabel!
    
    private var hardButton: UIButton!
    private var hardButtonBackground: UIView!
    private var hardButtonLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

}

// MARK: View Functions
extension MainMenuViewController {
    
    private func setupViews() {
        // Background View
        backgroundSceneView = SKView(frame: CGRect.zero)
        backgroundSceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundSceneView)
        
        // Background Scene
        var sceneLength: CGFloat = 0
        if view.frame.size.width > view.frame.size.height {
            sceneLength = view.frame.size.width
        }else{
            sceneLength = view.frame.size.height
        }
        
        let scene = MainMenuScene(size: CGSize(width: sceneLength, height: sceneLength))
        
        scene.scaleMode = .aspectFill
        scene.size = view.frame.size
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    
        backgroundSceneView.ignoresSiblingOrder = true
        
        backgroundSceneView.showsFPS = false
        backgroundSceneView.showsNodeCount = false
        backgroundSceneView.presentScene(scene)
        
        // Container View
        containerView = UIView(frame: CGRect.zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Logo View
        logoView = UIImageView(frame: CGRect.zero)
        logoView.contentMode = .scaleAspectFit
        logoView.image = UIImage(named: "word-search-logo")
        logoView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(logoView)
        
        // Difficulty Buttons
        easyButtonBackground = UIView(frame: CGRect.zero)
        easyButtonBackground.backgroundColor = UIColor.gray
        easyButtonBackground.layer.cornerRadius = 20.0
        easyButtonBackground.layer.borderWidth = 1.0
        easyButtonBackground.layer.borderColor = UIColor.darkGray.cgColor
        easyButtonBackground.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(easyButtonBackground)
        
        easyButtonLabel = UILabel(frame: CGRect.zero)
        easyButtonLabel.text = "Easy"
        easyButtonLabel.numberOfLines = 1
        easyButtonLabel.textAlignment = .center
        easyButtonLabel.textColor = UIColor.white
        easyButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(easyButtonLabel)
        
        easyButton = UIButton(frame: CGRect.zero)
        easyButton.tag = 0
        easyButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        easyButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(easyButton)
        
        normalButtonBackground = UIView(frame: CGRect.zero)
        normalButtonBackground.backgroundColor = UIColor.gray
        normalButtonBackground.layer.cornerRadius = 20.0
        normalButtonBackground.layer.borderWidth = 1.0
        normalButtonBackground.layer.borderColor = UIColor.darkGray.cgColor
        normalButtonBackground.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(normalButtonBackground)
        
        normalButtonLabel = UILabel(frame: CGRect.zero)
        normalButtonLabel.text = "Normal"
        normalButtonLabel.numberOfLines = 1
        normalButtonLabel.textAlignment = .center
        normalButtonLabel.textColor = UIColor.white
        normalButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(normalButtonLabel)
        
        normalButton = UIButton(frame: CGRect.zero)
        normalButton.tag = 1
        normalButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        normalButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(normalButton)
        
        hardButtonBackground = UIView(frame: CGRect.zero)
        hardButtonBackground.backgroundColor = UIColor.gray
        hardButtonBackground.layer.cornerRadius = 20.0
        hardButtonBackground.layer.borderWidth = 1.0
        hardButtonBackground.layer.borderColor = UIColor.darkGray.cgColor
        hardButtonBackground.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(hardButtonBackground)
        
        hardButtonLabel = UILabel(frame: CGRect.zero)
        hardButtonLabel.text = "Hard"
        hardButtonLabel.numberOfLines = 1
        hardButtonLabel.textAlignment = .center
        hardButtonLabel.textColor = UIColor.white
        hardButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(hardButtonLabel)
        
        hardButton = UIButton(frame: CGRect.zero)
        hardButton.tag = 2
        hardButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        hardButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(hardButton)
    }
    
    private func setupConstraints() {
        // Background View
        backgroundSceneView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundSceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundSceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundSceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // Container View
        containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1.0).isActive = true
        
        // Logo View
        logoView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0).isActive = true
        logoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0).isActive = true
        logoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0).isActive = true
        logoView.heightAnchor.constraint(lessThanOrEqualTo: logoView.widthAnchor, multiplier: 0.5).isActive = true
        
        // Difficulty Buttons
        easyButtonBackground.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 40.0).isActive = true
        easyButtonBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0).isActive = true
        easyButtonBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0).isActive = true
        easyButtonBackground.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        easyButtonLabel.topAnchor.constraint(equalTo: easyButtonBackground.topAnchor, constant: 5.0).isActive = true
        easyButtonLabel.bottomAnchor.constraint(equalTo: easyButtonBackground.bottomAnchor, constant: -5.0).isActive = true
        easyButtonLabel.leadingAnchor.constraint(equalTo: easyButtonBackground.leadingAnchor, constant: 20.0).isActive = true
        easyButtonLabel.trailingAnchor.constraint(equalTo: easyButtonBackground.trailingAnchor, constant: -20.0).isActive = true
        
        easyButton.topAnchor.constraint(equalTo: easyButtonBackground.topAnchor).isActive = true
        easyButton.bottomAnchor.constraint(equalTo: easyButtonBackground.bottomAnchor).isActive = true
        easyButton.leadingAnchor.constraint(equalTo: easyButtonBackground.leadingAnchor).isActive = true
        easyButton.trailingAnchor.constraint(equalTo: easyButtonBackground.trailingAnchor).isActive = true
        
        normalButtonBackground.topAnchor.constraint(equalTo: easyButtonBackground.bottomAnchor, constant: 20.0).isActive = true
        normalButtonBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0).isActive = true
        normalButtonBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0).isActive = true
        normalButtonBackground.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        normalButtonLabel.topAnchor.constraint(equalTo: normalButtonBackground.topAnchor, constant: 5.0).isActive = true
        normalButtonLabel.bottomAnchor.constraint(equalTo: normalButtonBackground.bottomAnchor, constant: -5.0).isActive = true
        normalButtonLabel.leadingAnchor.constraint(equalTo: normalButtonBackground.leadingAnchor, constant: 20.0).isActive = true
        normalButtonLabel.trailingAnchor.constraint(equalTo: normalButtonBackground.trailingAnchor, constant: -20.0).isActive = true
        
        normalButton.topAnchor.constraint(equalTo: normalButtonBackground.topAnchor).isActive = true
        normalButton.bottomAnchor.constraint(equalTo: normalButtonBackground.bottomAnchor).isActive = true
        normalButton.leadingAnchor.constraint(equalTo: normalButtonBackground.leadingAnchor).isActive = true
        normalButton.trailingAnchor.constraint(equalTo: normalButtonBackground.trailingAnchor).isActive = true
        
        hardButtonBackground.topAnchor.constraint(equalTo: normalButtonBackground.bottomAnchor, constant: 20.0).isActive = true
        hardButtonBackground.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0).isActive = true
        hardButtonBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0).isActive = true
        hardButtonBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0).isActive = true
        hardButtonBackground.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        hardButtonLabel.topAnchor.constraint(equalTo: hardButtonBackground.topAnchor, constant: 5.0).isActive = true
        hardButtonLabel.bottomAnchor.constraint(equalTo: hardButtonBackground.bottomAnchor, constant: -5.0).isActive = true
        hardButtonLabel.leadingAnchor.constraint(equalTo: hardButtonBackground.leadingAnchor, constant: 20.0).isActive = true
        hardButtonLabel.trailingAnchor.constraint(equalTo: hardButtonBackground.trailingAnchor, constant: -20.0).isActive = true
        
        hardButton.topAnchor.constraint(equalTo: hardButtonBackground.topAnchor).isActive = true
        hardButton.bottomAnchor.constraint(equalTo: hardButtonBackground.bottomAnchor).isActive = true
        hardButton.leadingAnchor.constraint(equalTo: hardButtonBackground.leadingAnchor).isActive = true
        hardButton.trailingAnchor.constraint(equalTo: hardButtonBackground.trailingAnchor).isActive = true
    }
    
}

extension MainMenuViewController {
    
    @objc private func buttonTapped(sender: UIButton) {
        guard let difficulty = Difficulty(rawValue: sender.tag) else { return }
        
        let gameController = GameViewController()
        gameController.difficulty = difficulty
        navigationController?.pushViewController(gameController, animated: true)
    }
    
}

