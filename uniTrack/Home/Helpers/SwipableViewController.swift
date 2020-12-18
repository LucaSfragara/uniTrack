//
//  SwipableViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 14/12/20.
//

import UIKit

class SwipableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeGesture()
        // Do any additional setup after loading the view.
    }
    
    private func setupSwipeGesture(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc
    func handleSwipe(_ swipe: UISwipeGestureRecognizer){
        if swipe.direction == .right{
            if  (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }else if swipe.direction == .left{
            if (self.tabBarController?.selectedIndex)! <= (self.tabBarController?.children.count)!{
                self.tabBarController?.selectedIndex += 1
            }
        }
        let selectedVC = self.tabBarController?.children[self.tabBarController!.selectedIndex]
        self.tabBarController?.delegate?.tabBarController?(self.tabBarController!, didSelect: selectedVC!)
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
