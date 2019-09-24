//
//  BKDropDown.swift
//  BKDropDown
//
//  Created by moon on 23/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import UIKit

struct BKItem {
    var title:String
    var image:UIImage?
}

class BKDropDown: UIViewController {
    
    //MARK:- @IBOutlet
    @IBOutlet weak private var tableView:UITableView!
    @IBOutlet weak private var rootView:UIView!
    
    @IBOutlet weak private var rootViewX:NSLayoutConstraint!
    @IBOutlet weak private var rootViewY:NSLayoutConstraint!
    
    @IBOutlet weak private var tableViewWidth:NSLayoutConstraint!
    @IBOutlet weak private var tableViewHeight:NSLayoutConstraint!
    @IBOutlet weak private var tableViewTop:NSLayoutConstraint!
    @IBOutlet weak private var tableViewBottom:NSLayoutConstraint!
    @IBOutlet weak private var tableViewLeading:NSLayoutConstraint!
    @IBOutlet weak private var tableViewTrailing:NSLayoutConstraint!

    private struct Appearance {
        struct Title {
            var textNormal:UIColor = .black
            var textHighlight:UIColor = .white
            var font:UIFont = .systemFont(ofSize: 12)
            var alignment:NSTextAlignment = .left
        }
        
        struct Cell {
            var viewNormal:UIColor = .white
            var viewHighlight:UIColor = .lightGray
            var rowHeight:CGFloat = 25
            var visibleItems:Int?
        }
        
        struct Padding {
            var top:CGFloat = 0
            var bottom:CGFloat = 0
            var leading:CGFloat = 0
            var trailing:CGFloat = 0
        }
        
        struct View {
            var cornerRadius:CGFloat = 0
            var borderWidth:CGFloat = 0
            var borderColor:UIColor = .lightGray
            var backgroundColor:UIColor = .white
        }
        
        var title = Title()
        var cell = Cell()
        var padding = Padding()
        var view = View()
    }
    private var appearance = Appearance()
    
    /// bind
    private var arrItems:[BKItem] = []
    private var firstItem:Int?
    private var mPrevItem:Int?
    
    /// setDelayAnimation
    private var delayAnimation:TimeInterval = 0.15
    
    /// setDidSelectRowAt
    typealias EVENT = (Int, BKDropDown)->()
    private var didSelectEvent:EVENT?
    
    //MARK:- @Inner
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.alpha = 0
        rootView.layer.borderWidth = appearance.view.borderWidth
        rootView.layer.borderColor = appearance.view.borderColor.cgColor
        rootView.layer.cornerRadius = appearance.view.cornerRadius
        rootView.backgroundColor = appearance.view.backgroundColor
        tableView.backgroundColor = appearance.view.backgroundColor
    }
    
    //MARK:- @Public
    static public func instance() -> BKDropDown {
        return UIStoryboard(name: "BKDropDown", bundle: nil)
        .instantiateViewController(withIdentifier: "BKDropDown") as! BKDropDown
    }
    
    public func bind(_ items:[String], first:Int?=nil) -> BKDropDown {
        if let first = first {
            assert(first > -1, "It cannot be negative.")
            assert(items.count > first, "OverFlows, You cannot exceed the range of items.")
        }
        var tmpArray:[BKItem] = []
        for item in items {
            tmpArray.append(BKItem(title: item, image: nil))
        }
        arrItems = tmpArray
        firstItem = first
        return self
    }
    
    public func bind(_ items:[BKItem], first:Int?=nil) -> BKDropDown {
        if let first = first {
            assert(first > -1, "It cannot be negative.")
            assert(items.count > first, "OverFlows, You cannot exceed the range of items.")
        }
        
        arrItems = items
        firstItem = first
        return self
    }
    
    public func setLayoutTitle(normal:UIColor?=nil, highlight:UIColor?=nil, font:UIFont?=nil, alignment:NSTextAlignment?=nil) -> BKDropDown {
        if let font = font {
            appearance.title.font = font
        }
        if let normal = normal {
            appearance.title.textNormal = normal
        }
        if let highlight = highlight {
            appearance.title.textHighlight = highlight
        }
        if let alignment = alignment {
            appearance.title.alignment = alignment
        }
        return self
    }
    
    public func setLayoutCell(normal:UIColor?=nil, highlight:UIColor?=nil, height:CGFloat?=nil, visibleItems:Int?=nil) -> BKDropDown {
        if let normal = normal {
            appearance.cell.viewNormal = normal
        }
        if let highlight = highlight {
            appearance.cell.viewHighlight = highlight
        }
        if let height = height {
            appearance.cell.rowHeight = height
        }
        if let visibleItems = visibleItems {
            appearance.cell.visibleItems = visibleItems
        }
        return self
    }
    
    public func setPadding(top:CGFloat?=nil, bottom:CGFloat?=nil, leading:CGFloat?=nil, trailing:CGFloat?=nil) -> BKDropDown {
        if let top = top {
            appearance.padding.top = top
        }
        if let bottom = bottom {
            appearance.padding.bottom = bottom
        }
        if let leading = leading {
            appearance.padding.leading = leading
        }
        if let trailing = trailing {
            appearance.padding.trailing = trailing
        }
        return self
    }
    
    public func setViewLayer(cornerRadius:CGFloat?=nil, borderWidth:CGFloat?=nil, borderColor:UIColor?=nil) -> BKDropDown {
        if let cornerRadius = cornerRadius {
            appearance.view.cornerRadius = cornerRadius
        }
        if let borderWidth = borderWidth {
            appearance.view.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            appearance.view.borderColor = borderColor
        }
        return self
    }
    
    public func setDelayAnimation(_ interval:TimeInterval) -> BKDropDown {
        delayAnimation = interval
        return self
    }
    
    public func setDidSelectRowAt(_ event:@escaping EVENT) -> BKDropDown {
        didSelectEvent = event
        return self
    }
    
    public func show(_ target:UIViewController, targetView:UIView) {
        var tmpView = targetView.superview
        var tmpRect = targetView.frame
        while tmpView != target.view {
            tmpRect = tmpView?.convert(tmpRect, to: tmpView?.superview) ?? tmpRect
            tmpView = tmpView?.superview
        }
        show(target, targetFrame: tmpRect)
    }
    
    public func show(_ target:UIViewController, targetFrame:CGRect) {
        target.present(self, animated: false) { [weak self] in
            guard let `self` = self else { return }
            self.tableViewTop.constant = self.appearance.padding.top
            self.tableViewBottom.constant = self.appearance.padding.bottom
            self.tableViewLeading.constant = self.appearance.padding.leading
            self.tableViewTrailing.constant = self.appearance.padding.trailing
            
            self.rootViewX.constant = targetFrame.origin.x
            self.rootViewY.constant = targetFrame.origin.y + targetFrame.height
            self.tableViewWidth.constant = targetFrame.size.width
            // 보여줄 Cell의 갯수를 입력받으면 제한을 건다
            let rowHeight = self.appearance.cell.rowHeight
            if let visibleItems = self.appearance.cell.visibleItems {
                self.tableViewHeight.constant = CGFloat(visibleItems) * rowHeight + rowHeight/2
            } else {
                self.tableViewHeight.constant = CGFloat(self.arrItems.count) * rowHeight
            }

            var targetViewHeight:CGFloat = target.view.frame.height
            if #available(iOS 11.0, *) {
                targetViewHeight = target.view.frame.height - (target.view.safeAreaInsets.top + target.view.safeAreaInsets.bottom)
            }
            
            // DropDown뷰의 위치Y+높이가 보여질 뷰보다 클 경우 DropUp으로 전환
            let isDropUp:Bool = self.rootViewY.constant + self.tableViewHeight.constant > targetViewHeight
            if isDropUp {
                let isReverse = (targetViewHeight/2 + UIApplication.shared.statusBarFrame.height + targetFrame.height) < self.rootViewY.constant
                if !isReverse {
                    // 반전 X
                    self.tableViewHeight.constant = targetViewHeight - self.rootViewY.constant
                    
                } else {
                    // 반전 O, 조건 = 반전 안했을때의 높이값보다 반전했을때의 높이값이 아이템을 더 많이 보여줄 수 있을 경우
                    // 기준 = 뷰중앙 + 타겟뷰의 높이값이 DropDown rootViewTop보다 작을 경우
                    // DropDown메뉴가 작을 수 있음
                    let height1 = self.tableViewHeight.constant // 기존 사이즈
                    let height2 = targetFrame.origin.y - UIApplication.shared.statusBarFrame.height // 뷰에 표시할 수 있는 최상단
                    if height1 < height2 { // DropDown메뉴 크기가 작을 경우
                        self.rootViewY.constant = targetFrame.origin.y - height1 - targetFrame.height
                        
                    } else {
                        self.tableViewHeight.constant = height2
                        self.rootViewY.constant = UIApplication.shared.statusBarFrame.height
                    }
                }
            }
            
            if let prevItem = self.mPrevItem {
                self.tableView.selectRow(at: IndexPath(row: prevItem, section: 0), animated: false, scrollPosition: .none)
            } else {
                if let firstItem = self.firstItem {
                    self.tableView.selectRow(at: IndexPath(row: firstItem, section: 0), animated: false, scrollPosition: .none)
                }
            }
            
            UIView.animate(withDuration: self.delayAnimation) {
                self.rootView.alpha = 1
            }
        }
    }
    
    @IBAction private func actionHide() {
        hide()
    }
    
    public func hide(_ completion:(()->())?=nil) {
        UIView.animate(withDuration: delayAnimation, animations: {
            self.rootView.alpha = 0
        }) { (finished) in
            if finished {
                self.dismiss(animated: false, completion:completion)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }
}

extension BKDropDown: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = arrItems[row]
        let identifier = item.image != nil ? "BKDropDownImageCell" : "BKDropDownCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? BKDropDownCell else {
            return UITableViewCell.init()
        }
        
        cell.lbTitle.text = item.title
        cell.lbTitle.font = appearance.title.font
        cell.lbTitle.textColor = appearance.title.textNormal
        cell.lbTitle.highlightedTextColor = appearance.title.textHighlight
        cell.lbTitle.textAlignment = appearance.title.alignment
        cell.ivLogo?.image = item.image
        
        cell.backgroundColor = appearance.cell.viewNormal
        cell.selectedBackgroundView?.backgroundColor = appearance.cell.viewHighlight

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mPrevItem = indexPath.row
        didSelectEvent?(indexPath.row, self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return appearance.cell.rowHeight
    }
}

class BKDropDownCell: UITableViewCell {
    @IBOutlet fileprivate weak var lbTitle:UILabel!
    @IBOutlet fileprivate weak var ivLogo:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectionView = UIView(frame: frame)
        selectedBackgroundView = selectionView
    }
}
