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
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var courseLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var stateLabel: UILabel!
    @IBOutlet private weak var populationLabel: UILabel!
    @IBOutlet private weak var reachTypeLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet private weak var deadlinesCollectionView: DynamicCollectionView!
    @IBOutlet private weak var tasksCollectionView: UICollectionView!
    
    @IBOutlet weak var deadlineCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tasksCollectionViewHeight: NSLayoutConstraint!
    
    private var CVcontentSizeObservation: [NSKeyValueObservation]?
    
    private var initialCollectionViewsHeight: InitialCollectionViewsHeight?
    
    weak var university: University?
    private var cardState: cardState!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get costraint initial(maximum) values
        initialCollectionViewsHeight = InitialCollectionViewsHeight(deadlines: deadlineCollectionViewHeight.constant, tasks: tasksCollectionViewHeight.constant)
        observeCollectionView()
        
        deadlinesCollectionView.delegate = self
        deadlinesCollectionView.dataSource = self
        
        tasksCollectionView.delegate = self
        tasksCollectionView.dataSource = self
        
        
        guard let university = university else{
            return 
        }
        
        navigationController?.isNavigationBarHidden = true
        
        
        self.cardState = .normal
    }
    
    deinit {
        CVcontentSizeObservation?.forEach({$0.invalidate()})
    }
    
    private func observeCollectionView(){
        
        CVcontentSizeObservation = [

            deadlinesCollectionView.observe(\.contentSize, options: .new, changeHandler: {[weak self] (cv, _) in
                
                guard let self = self else { return }
                    
                if cv.collectionViewLayout.collectionViewContentSize.height < self.initialCollectionViewsHeight!.deadlines{
                    
                    self.deadlineCollectionViewHeight.constant = cv.collectionViewLayout.collectionViewContentSize.height
                    
                }
            }),
            
            tasksCollectionView.observe(\.contentSize, options: .new, changeHandler: {[weak self] (cv, _) in
                
                guard let self = self else { return }
                    
                if cv.collectionViewLayout.collectionViewContentSize.height < self.initialCollectionViewsHeight!.tasks{
                    
                    self.tasksCollectionViewHeight.constant = cv.collectionViewLayout.collectionViewContentSize.height
                }
            })
        ]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DataManager.shared.getUniversities(withNameContaining: self.university?.name){[weak self] result in
            switch result {
            case .success(let universities):
                guard universities.isEmpty == false else{return}
                self?.university = universities[0]
                print(self?.university?.course)
            case .failure(let error):
                //TODO:  TODO: handle error
                print(error)
            }
            self?.tasksCollectionView.reloadData()
            self?.deadlinesCollectionView.reloadData()
        }
        
        guard let university = university else{return}
        
        self.title = university.name
        nameLabel.text = university.name
        courseLabel.text = university.course
        countryLabel.text = university.country?.isoCountryCode
        stateLabel.text = university.baseModel?.state
        populationLabel.text = university.baseModel?.population ?? "na"
        reachTypeLabel.text = university.reachType

        
       
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func didPressLinkButton(_ sender: Any){
        
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
            return university?.getTodos()?.count ?? 0
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
    
            if let task = university?.getTodos()?[indexPath.row] {
                cell.setup(task: task){ isChecked in
                    if isChecked {
                        
                    }else{
                        
                    }
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == deadlinesCollectionView{ //deadline collectionview
            //fixCollectionViewHeight()
            return(CGSize(width: collectionView.frame.width, height: collectionView.frame.height/3))
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
            guard let selectedTask = university?.getTodos()?[indexPath.row] else{
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
 
//Mark: draggable card view implementation
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
//        fixCollectionViewHeight()
        self.view.layoutIfNeeded()
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
