//
//  GameViewController.swift
//  Word Search
//
//  Created by Mike Stoltman on 2020-05-09.
//  Copyright © 2020 Mike Stoltman. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var difficulty: Difficulty? = .Easy
    private var grid: [[String]] = []
    
    private var currentPhrase: String = ""
    private var currentPositions: [CGPoint] = []
    
    private var wordList: [String] = []
    private var completedWordIndices: [Bool] = []
    private var completedLetterPositions: [CGPoint] = []
    
    private var previousPosition: CGPoint?
    
    private let cellSize: CGSize = CGSize(width: 40.0, height: 40.0)
    
    private var topContainerView: UIView!
    private var topContainerViewTopConstraint: NSLayoutConstraint?
    private var topContainerViewLandscapeBottomConstraint: NSLayoutConstraint?
    private var topContainerViewPortraitBottomConstraint: NSLayoutConstraint?
    private var topContainerViewLeadingConstraint: NSLayoutConstraint?
    private var topContainerViewLandscapeTrailingConstraint: NSLayoutConstraint?
    private var topContainerViewPortraitTrailingConstraint: NSLayoutConstraint?
    
    private var bottomContainerView: UIView!
    private var bottomContainerViewLandscapeTopConstraint: NSLayoutConstraint?
    private var bottomContainerViewPortraitTopConstraint: NSLayoutConstraint?
    private var bottomContainerViewBottomConstraint: NSLayoutConstraint?
    private var bottomContainerViewLandscapeLeadingConstraint: NSLayoutConstraint?
    private var bottomContainerViewPortraitLeadingConstraint: NSLayoutConstraint?
    private var bottomContainerViewTrailingConstraint: NSLayoutConstraint?
    
    private var topContainerScrollView: UIScrollView!
    private var collectionView: UICollectionView!
    
    private var statsView: UIView!
    private var timer: Timer?
    private var elapsedTime: Double = 0.0
    private var timerLabel: UILabel!
    private var wordLabel: UILabel!
    private var tableView: UITableView!
    
    private var quitButton: UIButton!
    private var quitButtonBackground: UIView!
    private var quitButtonLabel: UILabel!
    
    private var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupWordList()
        setupGrid()
        setupCollectionViewSize()
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startTimer()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            if UIApplication.shared.statusBarOrientation.isLandscape {
                self.updateConstraints(.Landscape)
            }else{
                self.updateConstraints(.Portrait)
            }
        })
    }
    
}

// MARK: View Functions
extension GameViewController {
    
    private func setupViews() {
        // Top Container View
        topContainerView = UIView(frame: CGRect.zero)
        topContainerView.backgroundColor = .gray
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topContainerView)
        
        // Bottom Container View
        bottomContainerView = UIView(frame: CGRect.zero)
        bottomContainerView.backgroundColor = .gray
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomContainerView)
        
        // Top Container Scroll View
        topContainerScrollView = UIScrollView(frame: CGRect.zero)
        topContainerScrollView.isScrollEnabled = true
        topContainerScrollView.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(topContainerScrollView)
        
        // Collection View
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(WordSearchCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        topContainerScrollView.addSubview(collectionView)
        
        // Stats View
        statsView = UIView(frame: CGRect.zero)
        statsView.backgroundColor = .gray
        statsView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.addSubview(statsView)
        
        // Current Word Label
        wordLabel = UILabel(frame: CGRect.zero)
        wordLabel.numberOfLines = 1
        wordLabel.textAlignment = .left
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(wordLabel)
        
        // Timer Label
        timerLabel = UILabel(frame: CGRect.zero)
        timerLabel.numberOfLines = 1
        timerLabel.textAlignment = .right
        timerLabel.text = "0:00"
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(timerLabel)
        
        // Table View
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.addSubview(tableView)
        
        // Quit Button
        quitButtonBackground = UIView(frame: CGRect.zero)
        quitButtonBackground.backgroundColor = UIColor.gray
        quitButtonBackground.layer.cornerRadius = 20.0
        quitButtonBackground.layer.borderWidth = 1.0
        quitButtonBackground.layer.borderColor = UIColor.darkGray.cgColor
        quitButtonBackground.translatesAutoresizingMaskIntoConstraints = false
        quitButtonBackground.isHidden = true
        view.addSubview(quitButtonBackground)
        
        quitButtonLabel = UILabel(frame: CGRect.zero)
        quitButtonLabel.text = "Quit"
        quitButtonLabel.textAlignment = .center
        quitButtonLabel.textColor = UIColor.white
        quitButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        quitButtonLabel.isHidden = true
        view.addSubview(quitButtonLabel)
        
        quitButton = UIButton(frame: CGRect.zero)
        quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.isHidden = true
        view.addSubview(quitButton)
        
        // Pause Button
        pauseButton = UIButton(frame: CGRect.zero)
        pauseButton.setImage(UIImage(named: "pause-button"), for: .normal)
        pauseButton.imageView?.tintColor = UIColor.white
        pauseButton.imageView?.contentMode = .scaleAspectFit
        pauseButton.backgroundColor = UIColor.gray
        pauseButton.layer.cornerRadius = 20.0
        pauseButton.layer.borderWidth = 1.0
        pauseButton.layer.borderColor = UIColor.darkGray.cgColor
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseButton)
    }
    
    private func setupConstraints() {
        // Top Container View
        topContainerViewTopConstraint = topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0)
        topContainerViewLandscapeBottomConstraint = topContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0)
        topContainerViewPortraitBottomConstraint = topContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0.0)
        topContainerViewLeadingConstraint = topContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0.0)
        topContainerViewLandscapeTrailingConstraint = topContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0.0)
        topContainerViewPortraitTrailingConstraint = topContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0.0)
        
        // Bottom Container View
        bottomContainerViewLandscapeTopConstraint = bottomContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0)
        bottomContainerViewPortraitTopConstraint = bottomContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 0.0)
        bottomContainerViewBottomConstraint = bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0)
        bottomContainerViewLandscapeLeadingConstraint = bottomContainerView.leadingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: 0.0)
        bottomContainerViewPortraitLeadingConstraint = bottomContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0.0)
        bottomContainerViewTrailingConstraint = bottomContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0.0)
        
        // Top Container ScrollView
        topContainerScrollView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 0.0).isActive = true
        topContainerScrollView.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 0.0).isActive = true
        topContainerScrollView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 0.0).isActive = true
        topContainerScrollView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: 0.0).isActive = true
        
        // Collection View
        collectionView.topAnchor.constraint(equalTo: topContainerScrollView.topAnchor, constant: 0.0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: topContainerScrollView.bottomAnchor, constant: 0.0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: topContainerScrollView.leadingAnchor, constant: 0.0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: topContainerScrollView.trailingAnchor, constant: 0.0).isActive = true
        
        // Stats View
        statsView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 0.0).isActive = true
        statsView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 0.0).isActive = true
        statsView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: 0.0).isActive = true
        statsView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        // Current Word Label
        wordLabel.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 0.0).isActive = true
        wordLabel.bottomAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 0.0).isActive = true
        wordLabel.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 10.0).isActive = true
        wordLabel.trailingAnchor.constraint(equalTo: statsView.centerXAnchor, constant: -5.0).isActive = true
        
        // Timer Label
        timerLabel.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 0.0).isActive = true
        timerLabel.bottomAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 0.0).isActive = true
        timerLabel.leadingAnchor.constraint(equalTo: statsView.centerXAnchor, constant: 5.0).isActive = true
        timerLabel.trailingAnchor.constraint(equalTo: statsView.trailingAnchor, constant: -10.0).isActive = true
        
        // Table View
        tableView.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 0.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: 0.0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 0.0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: 0.0).isActive = true
        
        // Quit Button
        quitButtonBackground.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor).isActive = true
        quitButtonBackground.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor).isActive = true
        quitButtonBackground.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        quitButtonLabel.topAnchor.constraint(equalTo: quitButtonBackground.topAnchor, constant: 5.0).isActive = true
        quitButtonLabel.bottomAnchor.constraint(equalTo: quitButtonBackground.bottomAnchor, constant: -5.0).isActive = true
        quitButtonLabel.leadingAnchor.constraint(equalTo: quitButtonBackground.leadingAnchor, constant: 20.0).isActive = true
        quitButtonLabel.trailingAnchor.constraint(equalTo: quitButtonBackground.trailingAnchor, constant: -20.0).isActive = true
        
        quitButton.topAnchor.constraint(equalTo: quitButtonBackground.topAnchor).isActive = true
        quitButton.bottomAnchor.constraint(equalTo: quitButtonBackground.bottomAnchor).isActive = true
        quitButton.leadingAnchor.constraint(equalTo: quitButtonBackground.leadingAnchor).isActive = true
        quitButton.trailingAnchor.constraint(equalTo: quitButtonBackground.trailingAnchor).isActive = true
        
        // Pause Button
        pauseButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        pauseButton.widthAnchor.constraint(equalTo: pauseButton.heightAnchor, multiplier: 1.0).isActive = true
        pauseButton.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -20.0).isActive = true
        pauseButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -20.0).isActive = true
        
        pauseButton.imageView?.topAnchor.constraint(equalTo: pauseButton.topAnchor, constant: 5.0).isActive = true
        pauseButton.imageView?.bottomAnchor.constraint(equalTo: pauseButton.bottomAnchor, constant: -5.0).isActive = true
        pauseButton.imageView?.leadingAnchor.constraint(equalTo: pauseButton.leadingAnchor, constant: 5.0).isActive = true
        pauseButton.imageView?.trailingAnchor.constraint(equalTo: pauseButton.trailingAnchor, constant: -5.0).isActive = true
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            updateConstraints(.Landscape)
        }else{
            updateConstraints(.Portrait)
        }
    }
    
    // FIXME: Constraint error when switching to landscape
    private func updateConstraints(_ orientation: ScreenOrientation) {
        topContainerViewTopConstraint?.isActive = true
        topContainerViewLeadingConstraint?.isActive = true
        
        bottomContainerViewBottomConstraint?.isActive = true
        bottomContainerViewTrailingConstraint?.isActive = true
        
        switch orientation {
        case .Landscape:
            topContainerViewPortraitBottomConstraint?.isActive = false
            topContainerViewLandscapeBottomConstraint?.isActive = true
            topContainerViewPortraitTrailingConstraint?.isActive = false
            topContainerViewLandscapeTrailingConstraint?.isActive = true
            
            bottomContainerViewPortraitTopConstraint?.isActive = false
            bottomContainerViewLandscapeTopConstraint?.isActive = true
            bottomContainerViewPortraitLeadingConstraint?.isActive = false
            bottomContainerViewLandscapeLeadingConstraint?.isActive = true
        case .Portrait:
            topContainerViewLandscapeBottomConstraint?.isActive = false
            topContainerViewPortraitBottomConstraint?.isActive = true
            topContainerViewLandscapeTrailingConstraint?.isActive = false
            topContainerViewPortraitTrailingConstraint?.isActive = true
            
            bottomContainerViewLandscapeTopConstraint?.isActive = false
            bottomContainerViewPortraitTopConstraint?.isActive = true
            bottomContainerViewLandscapeLeadingConstraint?.isActive = false
            bottomContainerViewPortraitLeadingConstraint?.isActive = true
        }
    }
    
    private func setupCollectionViewSize() {
        if let difficulty = difficulty {
            collectionView.heightAnchor.constraint(equalToConstant: cellSize.height * gridSize(difficulty).height).isActive = true
            collectionView.widthAnchor.constraint(equalToConstant: cellSize.width * gridSize(difficulty).width).isActive = true
        }else{
            fatalError("GameViewController requires difficulty")
        }
    }
    
}

// MARK: Timer Functions

extension GameViewController {
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTicked), userInfo: nil, repeats: true)
    }
    
    @objc private func timerTicked() {
        elapsedTime += 1.0
        
        let minutes = (elapsedTime / 60).rounded(.down)
        let seconds = elapsedTime - (minutes * 60)
        
        timerLabel.text = "\(String(format: "%d", Int(minutes))):\(String(format: "%02d", Int(seconds)))"
    }
    
}

// MARK: Grid/Word Functions

extension GameViewController {
    
    private func gridSize(_ difficulty: Difficulty?) -> CGSize {
        switch difficulty {
        case .Easy:
            return CGSize(width: 20, height: 20)
        case .Normal:
            return CGSize(width: 30, height: 30)
        case .Hard:
            return CGSize(width: 40, height: 40)
        default:
            return CGSize.zero
        }
    }
    
    private func setupWordList() {
        switch difficulty {
        case .Easy: wordList = Words.easy
        case .Normal: wordList = Words.normal
        case .Hard: wordList = Words.hard
        default:
            wordList.removeAll()
        }
        wordList.sort(by: { $0.uppercased() < $1.uppercased() })
        
        completedLetterPositions.removeAll()
        
        completedWordIndices.removeAll()
        for _ in wordList {
            completedWordIndices.append(false)
        }
    }
    
    private func setupGrid() {
        grid.removeAll()
        
        for _ in 0..<Int(gridSize(difficulty).height) {
            var row: [String] = []
            for _ in 0..<Int(gridSize(difficulty).width) {
                row.append("?")
            }
            grid.append(row)
        }
        
        for i in 0..<wordList.count {
            if let orientation = WordOrientation.allCases.randomElement() {
                let word = Array(wordList[i])
                
                switch orientation {
                case .HorizontalRight:
                    let wordHeight: Int = 1
                    let wordLength: Int = word.count
                    
                    var positionValid = false
                    while (positionValid == false) {
                        positionValid = true
                        
                        let yPosition = Int.random(in: 0..<(grid.count - wordHeight))
                        let xPosition = Int.random(in: 0..<(grid[yPosition].count - wordLength))
                        
                        for j in 0..<wordLength {
                            if grid[yPosition][xPosition + j] != "?" && grid[yPosition][xPosition + j].uppercased() != String(word[j]).uppercased() {
                                positionValid = false
                            }
                        }
                        
                        if positionValid {
                            for j in 0..<wordLength {
                                grid[yPosition][xPosition + j] = String(word[j]).uppercased()
                            }
                            print("added word: \(wordList[i])")
                        }
                    }
                    break
                case .HorizontalLeft:
                    let wordHeight: Int = 1
                    let wordLength: Int = word.count
                    
                    var positionValid = false
                    while (positionValid == false) {
                        positionValid = true
                        
                        let yPosition = Int.random(in: 0..<(grid.count - wordHeight))
                        let xPosition = Int.random(in: 0..<(grid[yPosition].count - wordLength))
                        
                        for j in 0..<wordLength {
                            let index = (wordLength - 1) - j
                            
                            if grid[yPosition][xPosition + j] != "?" && grid[yPosition][xPosition + j].uppercased() != String(word[index]).uppercased() {
                                positionValid = false
                            }
                        }
                        
                        if positionValid {
                            for j in 0..<wordLength {
                                let index = (wordLength - 1) - j
                                grid[yPosition][xPosition + j] = String(word[index]).uppercased()
                            }
                            print("added word: \(wordList[i])")
                        }
                    }
                    break
                case .VerticalDown:
                    let wordHeight: Int = word.count
                    let wordLength: Int = 1
                    
                    var positionValid = false
                    while (positionValid == false) {
                        positionValid = true
                        
                        let yPosition = Int.random(in: 0..<(grid.count - wordHeight))
                        let xPosition = Int.random(in: 0..<(grid[yPosition].count - wordLength))
                        
                        for j in 0..<wordHeight {
                            if grid[yPosition + j][xPosition] != "?" && grid[yPosition + j][xPosition].uppercased() != String(word[j]).uppercased() {
                                positionValid = false
                            }
                        }
                        
                        if positionValid {
                            for j in 0..<wordHeight {
                                grid[yPosition + j][xPosition] = String(word[j]).uppercased()
                            }
                            print("added word: \(wordList[i])")
                        }
                    }
                    break
                case .VerticalUp:
                    let wordHeight: Int = word.count
                    let wordLength: Int = 1
                    
                    var positionValid = false
                    while (positionValid == false) {
                        positionValid = true
                        
                        let yPosition = Int.random(in: 0..<(grid.count - wordHeight))
                        let xPosition = Int.random(in: 0..<(grid[yPosition].count - wordLength))
                        
                        for j in 0..<wordLength {
                            let index = (wordLength - 1) - j
                            
                            if grid[yPosition + j][xPosition] != "?" && grid[yPosition + j][xPosition].uppercased() != String(word[index]).uppercased() {
                                positionValid = false
                            }
                        }
                        
                        if positionValid {
                            for j in 0..<wordHeight {
                                let index = (wordHeight - 1) - j
                                grid[yPosition + j][xPosition] = String(word[index]).uppercased()
                            }
                            print("added word: \(wordList[i])")
                        }
                    }
                    break
                }
            }else{
                print("Failed to add word: \(wordList[i])")
            }
        }
        
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                if grid[i][j] == "?" {
                    if let letter = Alphabet.letters.randomElement() {
                        grid[i][j] = letter
                    }else{
                        grid[i][j] = "?"
                    }
                }
            }
        }
        
    }
    
}

// MARK: UICollectionView Data Source and Delegate Functions
extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(gridSize(difficulty).height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(gridSize(difficulty).width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? WordSearchCell else { return UICollectionViewCell() }
        cell.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
        cell.titleLabel?.text = grid[indexPath.section][indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousPosition = previousPosition {
            if Int(previousPosition.x) != indexPath.item || Int(previousPosition.y) != indexPath.section {
                if CGFloat(indexPath.section) >= (previousPosition.y - 1) && CGFloat(indexPath.section) <= (previousPosition.y + 1) {
                    if CGFloat(indexPath.item) >= (previousPosition.x - 1) && CGFloat(indexPath.item) <= (previousPosition.x + 1) {
                        self.previousPosition = CGPoint(x: indexPath.item, y: indexPath.section)
                        currentPhrase = currentPhrase + grid[indexPath.section][indexPath.item]
                        currentPositions.append(CGPoint(x: indexPath.item, y: indexPath.section))
                    }else{
                        self.previousPosition = nil
                        currentPhrase = ""
                        currentPositions.removeAll()
                    }
                }else{
                    self.previousPosition = nil
                    currentPhrase = ""
                    currentPositions.removeAll()
                }
            }
        }else{
            self.previousPosition = CGPoint(x: indexPath.item, y: indexPath.section)
            currentPhrase = grid[indexPath.section][indexPath.item]
        }
        
        // Check if new letter completes a word
        for i in 0..<wordList.count {
            if currentPhrase.uppercased() == wordList[i].uppercased() {
                // Word Completed
                completedLetterPositions.append(contentsOf: currentPositions)
                completedWordIndices[i] = true
                
                tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .none)
                
                self.previousPosition = nil
                currentPhrase = ""
                currentPositions.removeAll()
            }
        }
        
        // Check if all words have been found
        var foundAllWords = true
        for i in 0..<completedWordIndices.count {
            if !completedWordIndices[i] {
                foundAllWords = false
                break
            }
        }
        if foundAllWords {
            // End Game
            timer?.invalidate()
            currentPhrase = "GAME OVER"
            collectionView.allowsSelection = false
            
            quitButtonBackground.isHidden = false
            quitButtonLabel.isHidden = false
            quitButton.isHidden = false
            
            pauseButton.isHidden = true
        }
        
        wordLabel.text = currentPhrase
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
}

// MARK: UITableView Data Source and Delegate Functions
extension GameViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = wordList[indexPath.row]
        
        if completedWordIndices[indexPath.row] {
            cell.showLine = true
        }else{
            cell.showLine = false
        }
        
        return cell
    }
    
    // FIXME: Cell height collapsing
    
}

// MARK: Button Functions
extension GameViewController {
    
    @objc private func pauseButtonTapped() {
        if quitButton.isHidden {
            timer?.invalidate()
            
            pauseButton.setImage(UIImage(named: "play-button"), for: .normal)
            
            quitButtonBackground.isHidden = false
            quitButtonLabel.isHidden = false
            quitButton.isHidden = false
        }else{
            pauseButton.setImage(UIImage(named: "pause-button"), for: .normal)
            
            quitButtonBackground.isHidden = true
            quitButtonLabel.isHidden = true
            quitButton.isHidden = true
            
            startTimer()
        }
    }
    
    @objc private func quitButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
