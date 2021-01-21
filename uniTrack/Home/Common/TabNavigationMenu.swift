//
//  TabNavigationMenu.swift
//  uniTrack
//
//  Created by Luca Sfragara on 21/01/21.
//

import UIKit

class TabNavigationMenu: UIView {

    var itemTapped: ((_ tab: Int)-> ())?
    var activeItem: Int = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect){
        
        self.init(frame: frame)
        
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        var tabBarMenuItems: [UIView] = []
        
        for i in 0 ..< menuItems.count {
            
            let itemWidth = self.frame.width / CGFloat(menuItems.count)
            let leadingAnchor = itemWidth * CGFloat(i)
        
            let itemView = self.createTabItem(item: menuItems[i])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = i
            tabBarMenuItems.append(itemView)
            
        //self.addSubview(itemView)
//        NSLayoutConstraint.activate([
//                itemView.heightAnchor.constraint(equalTo: self.heightAnchor),
//                itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor),
//                itemView.topAnchor.constraint(equalTo: self.topAnchor),
//            ])
        }
        
        //setup stackView
        let stackView = UIStackView(arrangedSubviews: tabBarMenuItems)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.activateTab(tab: 0)
        
    }
    
    func createTabItem(item: TabItem) -> UIView{
        
        let tabBarItem = UIView(frame: CGRect.zero)
        let itemIconView = UIImageView(frame: CGRect.zero)
        
        itemIconView.image = item.icon.withRenderingMode(.automatic)
        itemIconView.contentMode = .scaleAspectFit
        itemIconView.translatesAutoresizingMaskIntoConstraints = false
        itemIconView.clipsToBounds = true
        
        tabBarItem.layer.backgroundColor = UIColor.white.cgColor
        tabBarItem.addSubview(itemIconView)
        tabBarItem.translatesAutoresizingMaskIntoConstraints = false
        tabBarItem.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            
            itemIconView.bottomAnchor.constraint(equalTo: tabBarItem.bottomAnchor),
            itemIconView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 0),
            itemIconView.leadingAnchor.constraint(equalTo: tabBarItem.leadingAnchor, constant: 0),
            itemIconView.trailingAnchor.constraint(equalTo: tabBarItem.trailingAnchor, constant: 0)
            
        ])

        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap))) // Each item should be able to trigger and action on tap
        return tabBarItem
        
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.switchTab(from: self.activeItem, to: sender.view!.tag)
    }
    
    func switchTab(from: Int, to: Int) {
        self.deactivateTab(tab: from)
        self.activateTab(tab: to)
    }
    func activateTab(tab: Int) {
        
       
        self.itemTapped?(tab)
        self.activeItem = tab
        
    }
    func deactivateTab(tab: Int) {
       
    }
    

}


//setup stackView
//        let stackView = UIStackView(arrangedSubviews: tabBarMenuItems)
//        stackView.axis = .horizontal
//        stackView.distribution = .equalSpacing
//        stackView.alignment = .fill
//        stackView.spacing = 20
//        stackView.backgroundColor = .red
//        let otherView = UIView()
//        otherView.backgroundColor = .red
//        self.addSubview(otherView)
//        NSLayoutConstraint.activate([
//            otherView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            otherView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            otherView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            otherView.topAnchor.constraint(equalTo: self.topAnchor)
//        ])
//        NSLayoutConstraint.activate([
//
//            NSLayoutConstraint(item: otherView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
//            NSLayoutConstraint(item: otherView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
//            NSLayoutConstraint(item: otherView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
//            NSLayoutConstraint(item: otherView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
//
//        ])
