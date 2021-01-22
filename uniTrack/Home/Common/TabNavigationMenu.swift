//
//  TabNavigationMenu.swift
//  uniTrack
//
//  Created by Luca Sfragara on 21/01/21.
//

import UIKit

class TabNavigationMenu: UIView {

    var itemTapped: ((_ tab: Int)-> ())? = {tab in
        
    }
    var activeItem: Int = 0
    var tabBarMenuItems: [TabItemView] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect){
        
        self.init(frame: frame)
    
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 30
        
        //Add shadow to tabBar
        self.layer.shadowColor = UIColor(named:"uniTrack Light Blue")!.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.7
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        for i in 0 ..< menuItems.count {
            
            let itemWidth = self.frame.width / CGFloat(menuItems.count)
            let leadingAnchor = itemWidth * CGFloat(i)
        
            let itemView = self.createTabItem(item: menuItems[i])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = i
            tabBarMenuItems.append(itemView)

        }
        
        //setup stackView
        let stackView = UIStackView(arrangedSubviews: tabBarMenuItems)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.activateTab(tab: 0)
        
    }
    
    func createTabItem(item: TabItem) -> TabItemView{
        
        let tabBarItem = TabItemView(item: item)
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap))) // Each item should be able to trigger and action on tap
        return tabBarItem
        
    }
    
//    func changeItemIcon(tab: Int, toState: TabState){
//
//    }
//
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
        tabBarMenuItems[tab].activate()
        
    }
    
    func deactivateTab(tab: Int) {
        tabBarMenuItems[tab].deactivate()
    }
    
    private enum TabState{
        case active
        case notActive
    }
    
}


class TabItemView: UIView{
    
    var imageView: UIImageView!
    var item: TabItem!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(item: TabItem){
        self.init(frame: CGRect.zero)
        
        self.item = item
        
        self.backgroundColor = UIColor.white
        translatesAutoresizingMaskIntoConstraints = false
        
        imageView = UIImageView()
        
        imageView.image = item.icon
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = false
        
        addSubview(imageView)
        
        //Constraints
        NSLayoutConstraint.activate([
            
            imageView.heightAnchor.constraint(equalToConstant: 35),
            imageView.heightAnchor.constraint(equalToConstant: 35),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
            
        ])
    }
    
    func activate(){
        
        self.imageView.image = item.selectedIcon
        
        imageView.layer.shadowColor = UIColor(named:"uniTrack Light Orange")!.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.4
        
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func deactivate(){
        self.imageView.image = item.icon
        imageView.layer.shadowOpacity = 0
    }
    
}
