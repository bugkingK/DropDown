//
//  BKDropDown.swift
//  BKDropDown
//
//  Created by moon on 23/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import UIKit

struct BKDropDownItem {
    var title:String
    var image:UIImage
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
    private var arrItems:[String] = []
    private var firstItem:Int?
    
    /// setLayoutOfLabel
    private var textNormalOfLabel:UIColor = .black
    private var textHighlightOfLabel:UIColor = .black
    private var fontOfLabel:UIFont = .systemFont(ofSize: 12)
    private var alignmentOfLabel:NSTextAlignment = .left
    
    /// setLayoutOfCell
    private var selectedOfCell:UIColor = .white
    private var unSelectedOfCell:UIColor = .white
    private var heightOfCell:CGFloat = 25
    
    /// setLayoutCornerRadius
    private var cornerRadius:CGFloat = 5
    
    /// setDidSelectRowAt
    typealias EVENT = (Int, BKDropDown)->()
    private var didSelectEvent:EVENT?
    
    //MARK:- @Inner
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.borderWidth = 0.5
        rootView.cornerRadius = cornerRadius
        rootView.borderColor = .lightGray
    }
    
    //MARK:- @Public
    static public let new: BKDropDown = {
        return UIStoryboard(name: "BKDropDown", bundle: nil)
                    .instantiateViewController(withIdentifier: "BKDropDown") as! BKDropDown
    }()
    
    public func bind(_ items:[String], first:Int?=nil) -> BKDropDown {
        if let first = first {
            assert(first > -1, "It cannot be negative.")
            assert(items.count > first, "OverFlows, You cannot exceed the range of items.")
        }
        
        arrItems = items
        firstItem = first
        return self
    }
    
    public func setLayoutOfLabel(_ normal:UIColor?=nil, highlight:UIColor?=nil, font:UIFont?=nil, alignment:NSTextAlignment?=nil) -> BKDropDown {
        if let font = font {
            fontOfLabel = font
        }
        if let normal = normal {
            textNormalOfLabel = normal
        }
        if let highlight = highlight {
            textHighlightOfLabel = highlight
        }
        if let alignment = alignment {
            alignmentOfLabel = alignment
        }
        return self
    }
    
    public func setLayoutOfCell(_ selected:UIColor?=nil, unSelected:UIColor?=nil, height:CGFloat?=nil) -> BKDropDown {
        if let selected = selected {
            selectedOfCell = selected
        }
        if let unSelected = unSelected {
            unSelectedOfCell = unSelected
        }
        if let height = height {
            heightOfCell = height
        }
        return self
    }
    
    public func setLayoutCornerRadius(_ radius:CGFloat) -> BKDropDown {
        cornerRadius = radius
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
        // DispatchQueue.main
        
        target.present(self, animated: false) { [weak self] in
            guard let `self` = self else { return }
//            let paddingHeight = self.m_paddingFrame.top + self.m_paddingFrame.bottom
            self.rootViewLeft.constant = targetFrame.origin.x
            self.rootViewTop.constant = targetFrame.origin.y + targetFrame.height /*+ self.m_from_target_top_margin*/
            self.rootViewWidth.constant = targetFrame.size.width
            self.rootViewHeight.constant = (CGFloat(self.arrItems.count) * self.heightOfCell) /*+ paddingHeight*/
            
            var targetViewHeight:CGFloat = target.view.frame.height;
            
            if #available(iOS 11.0, *) {
                targetViewHeight = target.view.frame.height - (target.view.safeAreaInsets.top + target.view.safeAreaInsets.bottom)
            }
            
            // DropDown뷰의 위치Y+높이가 보여질 뷰보다 클 경우 DropUp으로 전환
            if self.rootViewTop.constant + self.rootViewHeight.constant > targetViewHeight
            {
                
////                    debugPrint(d:self.rootViewTop.constant, self.rootViewHeight.constant, target.view.frame.height)
//                    if self.rootViewTop.constant - self.rootViewHeight.constant > 0
//                    {
//                        // 반전 O, 조건 = 반전했을때 vc_view's top에 도달하지 않을 경우
//                        self.rootViewTop.constant -= (targetFrame.size.height + self.rootViewHeight.constant)
//                        self.m_from_target_top_margin = -self.m_from_target_top_margin
//                    }
//                    else
                if ((targetViewHeight / 2) + UIApplication.shared.statusBarFrame.height + targetFrame.height) < self.rootViewTop.constant
                {
                    // 반전 O, 조건 = 반전 안했을때의 높이값보다 반전했을때의 높이값이 아이템을 더 많이 보여줄 수 있을 경우
                    // 기준 = 뷰중앙 + 타겟뷰의 높이값이 DropDown rootViewTop보다 작을 경우
                    
                    
                    // DropDown메뉴가 작을 수 있음
                    let height1 = self.rootViewHeight.constant // 기존 사이즈
                    let height2 = targetFrame.origin.y - UIApplication.shared.statusBarFrame.height /*- self.m_bottom_margin*/ // 뷰에 표시할 수 있는 최상단
                    if height1 < height2{ // DropDown메뉴 크기가 작을 경우
                        self.rootViewTop.constant = targetFrame.origin.y - height1
                        // bottomMargin 적용해야할듯 => topMargin으로
                    }
                    else{
                        // 뷰의 높이값 vc_view's top까지
                        self.rootViewHeight.constant = height2
                        self.rootViewTop.constant = UIApplication.shared.statusBarFrame.height /*+ self.m_bottom_margin*/
                        
                        //self.rootViewHeight.constant -= self.m_from_target_top_margin
                    }
                }
                else
                {
                    // 반전 X, 뷰의 높이값 vc_view's bottom까지
                    self.rootViewHeight.constant = targetViewHeight - self.rootViewTop.constant
                    
                    // Margin Bottom
                    //self.rootViewHeight.constant -= self.m_bottom_margin
                }
            }else
            {
                if self.rootViewTop.constant + self.rootViewHeight.constant > (targetViewHeight /*- self.m_bottom_margin*/)
                {
                    self.rootViewHeight.constant = targetViewHeight /*- self.m_bottom_margin*/
                }
            }
            
            
            DispatchQueue.main.async {
                //                    self.view_shadow.layer.shadowPath = UIBezierPath(rect: self.view_shadow.bounds).cgPath
//                self.view_shadow.layer.shadowPath = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: self.view_width.constant, height: self.rootViewHeight.constant)).cgPath
//                self.view_shadow.isHidden = false
//                self.tv_main.reloadData()
                
//                if let valid_default_selection_title = self.m_default_selection_title
//                {
//                    for idx in stride(from:0, to:self.m_arr_title.count, by:1)
//                    {
//                        if self.m_arr_title[idx] == valid_default_selection_title
//                        {
//                            self.tv_main.selectRow(at: IndexPath(row: idx, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
//                            break
//                        }
//                    }
//                }
                if let firstItem = self.firstItem {
                    self.tableView.selectRow(at: IndexPath(row: firstItem, section: 0), animated: false, scrollPosition: .none)
                }
            }
            
//            UIView.animate(withDuration: 0.15) {
//                self.view_combo.alpha = 1
//                self.view_shadow.alpha = 1
//            }
            
            
            
        }
    }
}

extension BKDropDown: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BKDropDownCell", for: indexPath) as? BKDropDownCell else {
            return UITableViewCell.init()
        }
        
        let item = arrItems[indexPath.row]
        cell.lbTitle.text = item
        cell.lbTitle.font = fontOfLabel
        cell.lbTitle.textColor = textNormalOfLabel
        cell.lbTitle.highlightedTextColor = textHighlightOfLabel
        cell.lbTitle.textAlignment = alignmentOfLabel
//        cell.lbl_title_margin_left.constant = m_paddingFrame.left
//        cell.lbl_title_margin_right.constant = m_paddingFrame.right
//
//        let selectionView = UIView.init()
//        selectionView.backgroundColor = tv_main_cell_selected_color
//        cell.selectedBackgroundView = selectionView
//
//        if indexPath.row != m_arr_title.count-1 {
//            if let divisionColor = self.m_division_color {
//                let divisionView = UIView(frame: CGRect(x: 10, y: cell.frame.height-1.0, width: cell.frame.width-20.0, height: 1))
//                divisionView.backgroundColor = divisionColor
//                divisionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                selectionView.addSubview(divisionView)
//                cell.addSubview(divisionView)
//            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectEvent?(indexPath.row, self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell
    }
}

class BKDropDownCell: UITableViewCell {
    @IBOutlet fileprivate weak var lbTitle:UILabel!
    @IBOutlet fileprivate weak var lbTitleLeft:NSLayoutConstraint!
    @IBOutlet fileprivate weak var lbTitleRight:NSLayoutConstraint!
}
