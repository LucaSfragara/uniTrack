//
//  CollegeDetailViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 23/11/20.
//

import UIKit

class CollegeDetailViewController: UIViewController {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var gradientView: UIView!
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var courseLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var stateLabel: UILabel!
    @IBOutlet private weak var populationLabel: UILabel!
    @IBOutlet private weak var reachTypeLabel: UILabel!
    @IBOutlet weak var linkButton: DesignableButton!
    
    @IBOutlet private var reachTypeStackView: UIStackView!
    
    @IBOutlet private weak var deadlinesCollectionView: DynamicCollectionView!
    @IBOutlet private weak var tasksCollectionView: UICollectionView!
    
    weak var university: University?
    private var cardState: cardState!
    
    private var deadlineCellHeight: CGFloat?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        deadlinesCollectionView.delegate = self
        deadlinesCollectionView.dataSource = self
        
        tasksCollectionView.delegate = self
        tasksCollectionView.dataSource = self
        
       
        
        addGradient(toView: gradientView)
        self.cardState = .normal
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        super.viewWillAppear(true)

        DataManager.shared.getUniversities(withNameContaining: self.university?.name){[weak self] result in
            switch result {
            case .success(let universities):
                guard universities.isEmpty == false else{return}
                self?.university = universities[0]

            case .failure(let error):
                //TODO:  TODO: handle error
                print(error)
            }
            DispatchQueue.main.async {
                self?.tasksCollectionView.reloadData()
                self?.deadlinesCollectionView.reloadData()
                self?.deadlineCellHeight = (self?.deadlinesCollectionView.frame.height)!/3
            }
            
        }
        
        guard let university = university else{return}
        
        self.title = university.name
        nameLabel.text = university.name
        courseLabel.text = university.course
        countryLabel.text = university.country?.isoCountryCode
        stateLabel.text = university.state
        
        if !(String(university.population).isEmpty){
            populationLabel.text = (university.population == 0 ? "--" : String(university.population))
        }else{
            populationLabel.text = "--"
        }
        
        reachTypeLabel.text = university.reachType
        
        if university.URL != nil {
            linkButton.enableButton()
        }else{
            linkButton.disableButton()
        }
        if let reachType = university.reachType, !reachType.isEmpty{
            reachTypeStackView.isHidden = false
            reachTypeLabel.text = university.reachType
        }else{
            reachTypeStackView.isHidden = true
        }
        
    }
    
    @IBAction func didPressNotesButton(){
        let notesVC = NotesViewController()
        notesVC.university = self.university
        self.navigationController?.pushViewController(notesVC, animated: true)
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func didPressLinkButton(_ sender: Any){
        
        guard let URLToOpen = university?.URL else{return}
        let webViewVC = WebViewController(url: URLToOpen)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    @IBAction func didTapAddDeadline(_ sender: Any) {
    
        let addDeadlineVC = AddDeadlineViewController()
        addDeadlineVC.delegate = self
        addDeadlineVC.modalPresentationStyle = .overFullScreen
        present(addDeadlineVC, animated: true, completion: nil)
    }
    
    @IBAction func didTapAddTask(_ sender: Any) {

        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = self
        addTaskVC.modalPresentationStyle = .overFullScreen
        present(addTaskVC, animated: true, completion: nil)
    }
    
    @IBAction func didTapEditButton(_ sender: Any){
        let collegegeEditVC = self.storyboard?.instantiateViewController(withIdentifier: "CollegeEditVCID") as! CollegeEditViewController
        collegegeEditVC.university = self.university
        navigationController?.pushViewController(collegegeEditVC, animated: true)
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//TODO: add peek and pop logic to UICollectionview cells

//MARK: CollectionViews delegate and datasource

extension CollegeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == deadlinesCollectionView{ //deadline collectionView
            return university?.getDeadlines()?.count ?? 0
        }else{ //to-dos collectionView
            return university?.getTasks()?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == deadlinesCollectionView { //deadline collectionview
            deadlinesCollectionView.register(UINib(nibName: "DetailDeadlinesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "detailDeadlinesCellID")
            let cell = deadlinesCollectionView.dequeueReusableCell(withReuseIdentifier: "detailDeadlinesCellID", for: indexPath) as! DetailDeadlinesCollectionViewCell
            if let deadline = university?.getDeadlines()?[indexPath.row]{
                cell.setup(deadline: deadline)
            }
            return cell
            
        }else{ //to-dos collectionview
            tasksCollectionView.register(UINib(nibName: "DetailTodosCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "detailTodosCellID")
            let cell = tasksCollectionView.dequeueReusableCell(withReuseIdentifier: "detailTodosCellID", for: indexPath) as! DetailTodosCollectionViewCell
    
            if let task = university?.getTasks()?[indexPath.row] {
                cell.setup(task: task)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == deadlinesCollectionView{ //deadline collectionview
            //fixCollectionViewHeight()
            
            return(CGSize(width: collectionView.frame.width, height: 54))
            //return(CGSize(width: collectionView.frame.width, height: collectionView.frame.height))
        }else{ //todos collection view
            return(CGSize(width: collectionView.frame.width, height: collectionView.frame.height/2))
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == tasksCollectionView{ //todos collectionview
            return 15.0
        }else { //deadline collectionview
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tasksCollectionView{ //todos collectionview
            let taskDetailVC = TaskDetailViewController()
            guard let selectedTask = university?.getTasks()?[indexPath.row] else{
                return
            }
            taskDetailVC.task = selectedTask
            self.navigationController?.pushViewController(taskDetailVC, animated: true)
        }else { //deadline collectionview
            let deadlineDetailVC = DeadlineDetailViewController()
            guard let selectedDeadline = university?.getDeadlines()?[indexPath.row] else{
                return
            }
            deadlineDetailVC.deadline = selectedDeadline
            self.navigationController?.pushViewController(deadlineDetailVC, animated: true)
        }
    }
}
 
//MARK: GRADIENT BACKGROUND
extension CollegeDetailViewController{
    
    func addGradient(toView view: UIView){
        
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [UIColor.white.cgColor,UIColor(named: "uniTrack Light Orange")?.cgColor]
                
        //define locations of colors as NSNumbers in range from 0.0 to 1.0
        //if locations not provided the colors will spread evenly
        gradientLayer.locations = [0.0, 0.8]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
    
        
        //define frame
        gradientLayer.frame = view.bounds
        
        //insert the gradient layer to the view layer
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}

//MARK: draggable card view implementation
extension CollegeDetailViewController{
    
    @IBAction private func panGestureRecognizer(_ panRecognizer: UIPanGestureRecognizer){
        
        var cardPanStartingTopCostraint = CGFloat()
        let translation = panRecognizer.translation(in: self.view)
        
        guard let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
              let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom else{print("safe Area height or bottom padding not available"); return}
        
        switch panRecognizer.state{
        
        case .began:
            cardPanStartingTopCostraint = cardViewTopConstraint.constant
        case .changed:
            
            if translation.y < 0 && self.cardState == .normal{
                expandCard()
                self.cardState = .expanded
            }else if translation.y > 0 && self.cardState == .expanded{
                retractCard()
                self.cardState = .normal
            }
        case .ended:
            break
        default:
            return
        }
        
    }
    
    //Animations
    private func expandCard(){
        
        self.view.layoutIfNeeded()
        
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            
            self.cardViewTopConstraint.constant = self.view.frame.height * 1/15
        }
        
        let cardAnimation = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn){
            self.view.layoutIfNeeded()
        }
        
        cardAnimation.startAnimation()
        
    }
    
    private func retractCard(){
        
        self.view.layoutIfNeeded()
        
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
        }
        
        self.cardViewTopConstraint.constant = self.view.frame.height * 69/224
        
        
        let cardAnimation = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn){
            self.view.layoutIfNeeded()
        }
        
        cardAnimation.startAnimation()
    }
    
    
    enum cardState{
        case normal
        case expanded
    }
    
}

//MARK: add task button delegate
extension CollegeDetailViewController: AddTaskButtonDelegate{
    func didPressAddTask(title: String, text: String?) {
        guard let university = self.university else{return}
        let newTask = Task(taskTitle: title, taskText: (text ?? ""), forUniversity: university)
        university.addTask(newTask)
        PersistantService.saveContext()
        tasksCollectionView.reloadData()
    }
}

//MARK: add deadline button delegate
extension CollegeDetailViewController: addDeadlineButtonDelegate{
    func didPressAddDeadline(title: String, date: Date) {
        guard let university = self.university else{return}
        let newDeadline = Deadline(date: date, title: title, forUniversity: university)
        university.addDeadline(newDeadline)
        PersistantService.saveContext()
        deadlinesCollectionView.reloadData()
    }
}

//MARK: CUSTOM TYPES
extension CollegeDetailViewController{
    private struct InitialCollectionViewsHeight{
        var deadlines: CGFloat
        var tasks: CGFloat
    }
}
