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
    @IBOutlet weak private var rootView:CustomBorderView!
    
    @IBOutlet weak private var rootViewLeft:NSLayoutConstraint!
    @IBOutlet weak private var rootViewTop:NSLayoutConstraint!
    @IBOutlet weak private var rootViewWidth:NSLayoutConstraint!
    @IBOutlet weak private var rootViewHeight:NSLayoutConstraint!

    /// bind
    private var arrItems:[BKItem] = []
    private var firstItem:Int?
    private var mPrevItem:Int?
    
    /// setLayoutTitle
    private var titleTextNormal:UIColor = .black
    private var titleTextHighlight:UIColor = .black
    private var titleFont:UIFont = .systemFont(ofSize: 12)
    private var titleAlignment:NSTextAlignment = .left
    
    /// setLayoutCell
    private var cellViewNormal:UIColor = .white
    private var cellViewHighlight:UIColor = .red
    private var cellRowHeight:CGFloat = 25
    
    private var cellDivisionColor:UIColor?
    
    /// setLayoutCornerRadius
    private var rootViewCornerRadius:CGFloat = 5
    
    /// setLayoutPadding
    private struct BKPadding {
        var top:CGFloat
        var bottom:CGFloat
        var left:CGFloat
        var right:CGFloat
    }
    private var rootViewPadding:BKPadding = BKPadding(top: 5, bottom: 5, left: 15, right: 15)
    
    /// setDidSelectRowAt
    typealias EVENT = (Int, BKDropDown)->()
    private var didSelectEvent:EVENT?
    
    //MARK:- @Inner
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.alpha = 0
        rootView.borderWidth = 0.5
        rootView.cornerRadius = rootViewCornerRadius
        rootView.borderColor = .lightGray
    }
    
    //MARK:- @Public
    static public let new: BKDropDown = {
        return UIStoryboard(name: "BKDropDown", bundle: nil)
                    .instantiateViewController(withIdentifier: "BKDropDown") as! BKDropDown
    }()
    
    public func bind(_ items:[BKItem], first:Int?=nil) -> BKDropDown {
        if let first = first {
            assert(first > -1, "It cannot be negative.")
            assert(items.count > first, "OverFlows, You cannot exceed the range of items.")
        }
        
        arrItems = items
        firstItem = first
        return self
    }
    
    public func setLayoutTitle(_ normal:UIColor?=nil, highlight:UIColor?=nil, font:UIFont?=nil, alignment:NSTextAlignment?=nil) -> BKDropDown {
        if let font = font {
            titleFont = font
        }
        if let normal = normal {
            titleTextNormal = normal
        }
        if let highlight = highlight {
            titleTextHighlight = highlight
        }
        if let alignment = alignment {
            titleAlignment = alignment
        }
        return self
    }
    
    public func setLayoutCell(_ normal:UIColor?=nil, highlight:UIColor?=nil, height:CGFloat?=nil) -> BKDropDown {
        if let normal = normal {
            cellViewNormal = normal
        }
        if let highlight = highlight {
            cellViewHighlight = highlight
        }
        if let height = height {
            cellRowHeight = height
        }
        return self
    }
    
    public func setLayoutPadding(_ top:CGFloat=0, bottom:CGFloat=0, left:CGFloat=0, right:CGFloat=0) -> BKDropDown {
        rootViewPadding = BKPadding(top: top, bottom: bottom, left: left, right: right)
        return self
    }
    
    public func setLayoutCornerRadius(_ radius:CGFloat) -> BKDropDown {
        rootViewCornerRadius = radius
        return self
    }
    
    public func setDidSelectRowAt(_ event:@escaping EVENT) -> BKDropDown {
        didSelectEvent = event
        return self
    }
    
    public func setDivisionColor(_ color:UIColor) -> BKDropDown {
        cellDivisionColor = color
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
        // DispatchQueue.main
        
        target.present(self, animated: false) { [weak self] in
            guard let `self` = self else { return }
            let paddingHeight = self.rootViewPadding.top + self.rootViewPadding.bottom
            self.rootViewLeft.constant = targetFrame.origin.x
            self.rootViewTop.constant = targetFrame.origin.y + targetFrame.height
            self.rootViewWidth.constant = targetFrame.size.width
            // 여기서 보여줄 Cell의 갯수를 입력받으면 제한을 걸어야함
            /*
             if ~~가 있다면 (갯수 * self.cellRowHeight) + paddingHeight
             */
            self.rootViewHeight.constant = (CGFloat(self.arrItems.count) * self.cellRowHeight) + paddingHeight
            
            var targetViewHeight:CGFloat = target.view.frame.height
            
            if #available(iOS 11.0, *) {
                targetViewHeight = target.view.frame.height - (target.view.safeAreaInsets.top + target.view.safeAreaInsets.bottom)
            }
            
            // DropDown뷰의 위치Y+높이가 보여질 뷰보다 클 경우 DropUp으로 전환
            let isDropUp:Bool = self.rootViewTop.constant + self.rootViewHeight.constant > targetViewHeight
            if isDropUp {
                let isReverse = (targetViewHeight/2 + UIApplication.shared.statusBarFrame.height + targetFrame.height) < self.rootViewTop.constant
                if !isReverse {
                    // 반전 X
                    self.rootViewHeight.constant = targetViewHeight - self.rootViewTop.constant
                    
                } else {
                    // 반전 O, 조건 = 반전 안했을때의 높이값보다 반전했을때의 높이값이 아이템을 더 많이 보여줄 수 있을 경우
                    // 기준 = 뷰중앙 + 타겟뷰의 높이값이 DropDown rootViewTop보다 작을 경우
                    // DropDown메뉴가 작을 수 있음
                    let height1 = self.rootViewHeight.constant // 기존 사이즈
                    let height2 = targetFrame.origin.y - UIApplication.shared.statusBarFrame.height // 뷰에 표시할 수 있는 최상단
                    if height1 < height2 { // DropDown메뉴 크기가 작을 경우
                        self.rootViewTop.constant = targetFrame.origin.y - height1
                        
                    } else {
                        self.rootViewHeight.constant = height2
                        self.rootViewTop.constant = UIApplication.shared.statusBarFrame.height
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
            
            UIView.animate(withDuration: 0.15) {
                self.rootView.alpha = 1
            }
        }
    }
    
    @IBAction private func actionHide() {
        hide()
    }
    
    public func hide(_ completion:(()->())?=nil) {
        UIView.animate(withDuration: 0.15, animations: {
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
        let item = arrItems[indexPath.row]
        let identifier = item.image != nil ? "BKDropDownImageCell" : "BKDropDownCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? BKDropDownCell else {
            return UITableViewCell.init()
        }
        
        cell.lbTitle.text = item.title
        cell.lbTitle.font = titleFont
        cell.lbTitle.textColor = titleTextNormal
        cell.lbTitle.highlightedTextColor = titleTextHighlight
        cell.lbTitle.textAlignment = titleAlignment
        cell.ivLogo?.image = item.image
        cell.paddingLeft.constant = rootViewPadding.left
        cell.paddingRight.constant = rootViewPadding.right
        
        cell.backgroundColor = cellViewNormal
        let selectionView = UIView.init()
        selectionView.backgroundColor = cellViewHighlight
        cell.selectedBackgroundView = selectionView
        
        // Add Division Line
        guard indexPath.row == arrItems.count-1,
            let divisionColor = cellDivisionColor else {
            return cell
        }
        
        let divisionView = UIView(frame: CGRect(x: 10, y: cell.frame.height-1.0, width: cell.frame.width-20.0, height: 1))
        divisionView.backgroundColor = divisionColor
        divisionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectionView.addSubview(divisionView)
        cell.addSubview(divisionView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mPrevItem = indexPath.row
        didSelectEvent?(indexPath.row, self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellRowHeight
    }
}

class BKDropDownCell: UITableViewCell {
    @IBOutlet fileprivate var paddingLeft: NSLayoutConstraint!
    @IBOutlet fileprivate var paddingRight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var lbTitle:UILabel!
    @IBOutlet fileprivate weak var ivLogo:UIImageView?
}
