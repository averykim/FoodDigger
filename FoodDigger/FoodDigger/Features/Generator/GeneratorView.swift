//
//  Generator.swift
//  FoodDigger
//
//  Created by JihyeKim on 1/19/26.
//

import UIKit

class Generatorview: UIView {

    var onHomeButtonTapped: (() -> Void)?
    var onReplayButtonTapped: (() -> Void)?
    var onGoButtonTapped: (() -> Void)?

    let title = UILabel()
    let subtitle = UILabel()
    let resultBox = UILabel()
    let scrathCard = ScratchCardView()
    let replayButton = UIButton()
    let goButton =  UIButton()
    let buttonStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = DiggerColor.mainBackgroundColor

        title.text = "What's for today...?"
        title.font = UIFont(name: "BMJUA", size: 28)
        title.textAlignment = .center
        title.textColor = DiggerColor.mainTextColor

        subtitle.text = "Scratch  the card to find out "
        subtitle.font = UIFont(name: "BMJUA", size: 16)
        subtitle.textColor = DiggerColor.placeholderColor
        subtitle.textAlignment = .center
        let titleStack = UIStackView(arrangedSubviews: [title, subtitle])
        titleStack.axis = .vertical
        titleStack.spacing = 8
        titleStack.distribution = .fillProportionally
        addSubview(titleStack, anchors: [.top(150), .centerX(0)])

        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addSubview(closeButton, anchors: [.top(100), .trailing(-50)])
        closeButton.addTarget(self, action: #selector(pressHomeButton), for: .touchUpInside)

        scrathCard.translatesAutoresizingMaskIntoConstraints  = false
        addSubview(scrathCard, anchors: [.centerX(0), .centerY(0), .width(300), .height(250)])

        replayButton.setTitle("Replay", for: .normal)
        replayButton.setTitleColor(DiggerColor.mainTextColor, for: .normal)
        replayButton.setBackgroundImage(UIImage(named: "buttonBackground"), for: .normal)
        replayButton.clipsToBounds = true
        replayButton.layer.cornerRadius = 12
        replayButton.titleLabel?.font = UIFont(name: "BMJUA", size: 16)
        replayButton.addTarget(self, action: #selector(pressReplayButton), for: .touchUpInside)

        goButton.setTitle("Let's Go!", for: .normal)
        goButton.setTitleColor(DiggerColor.mainTextColor, for: .normal)
        goButton.setBackgroundImage(UIImage(named: "buttonBackground"), for: .normal)
        goButton.clipsToBounds = true
        goButton.layer.cornerRadius = 12
        goButton.titleLabel?.font = UIFont(name: "BMJUA", size: 16)
        goButton.addTarget(self, action: #selector(pressGoButton), for: .touchUpInside)

        buttonStackView.addArrangedSubview(replayButton)
        buttonStackView.addArrangedSubview(goButton)
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 16
        buttonStackView.alpha = 0
        addSubview(buttonStackView, anchors: [.height(50), .bottom(-100), .leading(30), .trailing(-30)])

    }

    func updateTitle() {
        title.text = "We have a winner!"
        subtitle.text = "Hope you enjoy your meal"

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.buttonStackView.alpha = 1.0
            self.buttonStackView.transform = CGAffineTransform(translationX: 0, y: -10)
        })
    }

    @objc
    func pressHomeButton() {
        onHomeButtonTapped?()
    }

    @objc
    func pressReplayButton() {
        onReplayButtonTapped?()
    }

    @objc
    func pressGoButton() {
        onGoButtonTapped?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ScratchCardView: UIView {

    var onScratchFinished: (() -> Void)?

    private let coverview = UIView()
    private let coverLabel = UILabel()
    private let resultview = UIView()
    private let resultLabel = UILabel()
    private let scratchPath = UIBezierPath()
    private let maskLayer = CAShapeLayer()

    //calculation variable
    private var ScratchedGrid: Set<String> = []
    private let gridSize: CGFloat = 30.0
    private var isRevealed =  false

    //Haptic
    let selectionHaptic = UISelectionFeedbackGenerator()
    let impactHaptiic = UIImpactFeedbackGenerator(style: .heavy)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        //Card cover view
        coverview.backgroundColor = .systemGray4
        coverview.layer.cornerRadius = 16
        coverview.clipsToBounds = true

        coverLabel.text = "Scratch Here"
        coverLabel.font = UIFont(name: "BMJUA", size: 20)
        coverLabel.textColor = DiggerColor.textBoxColor
        coverLabel.textAlignment = .center

        resultview.backgroundColor  = DiggerColor.headColor
        resultview.layer.cornerRadius = 16
        resultview.clipsToBounds = true

        resultLabel.text = "Hmm..."
        resultLabel.font = UIFont(name: "BMJUA", size: 20)
        resultLabel.textColor = DiggerColor.mainTextColor
        resultLabel.textAlignment = .center

        addSubview(coverview)
        coverview.addSubview(coverLabel)

        addSubview(resultview)
        resultview.addSubview(resultLabel)

        coverview.frame = self.bounds
        coverview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coverLabel.frame = self.bounds
        coverLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]


        resultview.frame = self.bounds
        resultview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        resultLabel.frame = self.bounds
        resultLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.lineWidth = 40
        maskLayer.lineCap = .round
        maskLayer.lineJoin = .round
        maskLayer.fillColor = nil

        resultview.layer.mask = maskLayer

        //Card glow effect
        self.layer.shadowColor = DiggerColor.headColor.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 30.0
        self.layer.cornerRadius = 16

        setupGesture()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16).cgPath
    }

    func setResutlText(_ text: String) {
        resultLabel.text = text
        //Reset scratching path
        scratchPath.removeAllPoints()
        maskLayer.path = nil
    }

    func resetScratch() {
        isRevealed = false
        ScratchedGrid.removeAll()
        scratchPath.removeAllPoints()
        maskLayer.path = nil
        insertSubview(coverview, belowSubview: resultview)
        resultview.layer.mask = maskLayer
    }

    // Gesture
    private func setupGesture()  {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.addGestureRecognizer(panGesture)
    }

    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if isRevealed {return}
        let touchPoint = gesture.location(in: self)

        switch gesture.state {
        case .began:
            scratchPath.move(to: touchPoint)
        case .changed:
            scratchPath.addLine(to: touchPoint)
            maskLayer.path = scratchPath.cgPath

            //calculate path
            calculatePercentage(at: touchPoint)

            //Haptic
            selectionHaptic.selectionChanged()
        default:
            break
        }
    }

    private func calculatePercentage(at point: CGPoint) {
        let gridX = Int(point.x / gridSize)
        let gridY = Int(point.y / gridSize)
        let gridKey = "\(gridX),\(gridY)"

        ScratchedGrid.insert(gridKey)
        let totalGridX = Int(self.bounds.width / gridSize)
        let totalGridY = Int(self.bounds.height / gridSize)
        let totalGrids = max(1, totalGridX * totalGridY)

        let percent = CGFloat(ScratchedGrid.count) / CGFloat(totalGrids)

        if percent >= 0.60 {
            revealAll()
        }
    }

    private func revealAll() {
        isRevealed = true
        impactHaptiic.impactOccurred()
        UIView.transition(with: self, duration: 0.5, animations: {
            self.resultview.layer.mask = nil
        }, completion: { _ in
            self.coverview.removeFromSuperview()

            self.onScratchFinished?()
        })

        UIView.animate(withDuration: 0.15, animations: {
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 40.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, animations: {
                self.layer.shadowOpacity = 0.6
                self.layer.shadowRadius = 30.0
            })
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
