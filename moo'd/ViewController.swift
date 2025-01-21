import UIKit

class ViewController: UIViewController {
    // format question label class
    let qLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // format subsection label
    let subsectionLabel: UILabel = {
        let label2 = UILabel()
        label2.textAlignment = .center
        label2.numberOfLines = 0
        label2.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label2.textColor = UIColor.black
        label2.translatesAutoresizingMaskIntoConstraints = false
        return label2
    }()
    
    // create format for feedback label based on user's mood
    let feedbackLabel: UILabel = {
        let label = UILabel()
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = UIFont(name: "HelveticaNeue", size: 16)
            label.textColor = UIColor.black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    //  displays the quiz buttons vertically
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // creates progress bar format so user can see how far into the quiz they are
    let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.trackTintColor = UIColor.lightGray
        progress.progressTintColor = UIColor.purple
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    // creates format for the button that will transition between questions
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    
    var points = 0;
    let answerPoints = [5, 3, 2, 1];
    var mood = "";
    let questions = [
        ("What do you consider your primary source(s) of stress?", ["Academics", "Relationships", "Extracurriculars", "Future", "Work and Job"]),
        ("How often do you feel happy?", ["Rarely", "Sometimes", "Often", "Always"]),
        ("How often do you feel anxious?", ["Never", "Sometimes", "Often", "Always"]),
        ("How often do you sleep well?", ["Rarely", "Sometimes", "Often", "Always"])
    ]
    var currQuestionIndex = 0
    var totalQs: Int {
        return questions.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showQuestion()
        nextButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(qLabel)
        view.addSubview(subsectionLabel)
        view.addSubview(feedbackLabel)
        view.addSubview(stackView)
        view.addSubview(progressBar)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            qLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            qLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            qLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subsectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subsectionLabel.topAnchor.constraint(equalTo: qLabel.bottomAnchor, constant: 20),
            subsectionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            feedbackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            feedbackLabel.topAnchor.constraint(equalTo: subsectionLabel.bottomAnchor, constant: 10),
            feedbackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: subsectionLabel.bottomAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBar.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            nextButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 30),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    

    func showQuestion() {
        guard currQuestionIndex < totalQs else {
            showResult()
            return
        }
        
        let currQuestion = questions[currQuestionIndex]
        qLabel.text = currQuestion.0
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, answer) in currQuestion.1.enumerated() {
            let button = UIButton(type: .system)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.tag = index // lets us find tracking answer index
            button.addTarget(self, action: #selector(currentquestion(_:)), for: .touchUpInside)
            button.setTitle(answer, for: .normal)
            button.backgroundColor = .white
            stackView.addArrangedSubview(button)
        }
        // updates progress bar to reflect user progress
        progressBar.progress = Float(currQuestionIndex) / Float(totalQs)
        nextButton.isHidden = true
    }
    
    @objc func currentquestion(_ sender: UIButton) {
        if sender.tag < answerPoints.count {
            points += answerPoints[sender.tag]
        }
        
        stackView.arrangedSubviews.forEach { // changes color of selected button
            ($0 as? UIButton)?.backgroundColor = .white
        }
        sender.backgroundColor = UIColor.systemGray5
        
        nextButton.isHidden = false
    }
    
    // assigns value to mood based on total # of points at end of quiz
    @objc func decideMood(){
        if(points >= 20){
            mood = "good"
            feedbackLabel.text = "Yay :)"
        }
        else if(points >= 10){
            mood = "neutral"
            subsectionLabel.text = "Here are some things you can do to uplift your mood: "
            feedbackLabel.text = "Don't worry be happy! :)"
        }
        else{
            mood = "bad"
            subsectionLabel.text = "Here are some things you can do to uplift your mood: "
            feedbackLabel.text = "Go for an arb walk, read, get some sun! Things will look up :)"
            
        }
    }
    // move to the next question
    @objc func nextQuestion() {
        currQuestionIndex += 1
        showQuestion()
    }
    
    
    func showResult() {
        decideMood()
        qLabel.text = "Quiz Complete! \nYou seem to be in a \(mood) mood."
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        progressBar.isHidden = true
        nextButton.isHidden = true
    }
}
