//
//  MenuDropDownPopupVC.swift
//  BanapressoForStoreFramework
//
//  Created by 바나플 on 2018. 6. 1..
//  Copyright © 2018년 바나플. All rights reserved.
//

/*
import UIKit

class MenuDropDownPopupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view_combo.alpha = 0
        (view_combo as? CustomView)?.cornerRadius = m_cornerRadius
        view_combo_top_padding.constant = m_paddingFrame.top
        view_combo_bottom_padding.constant = m_paddingFrame.bottom
        if !m_hidden_shadow {
            self.view_shadow.alpha = 0
            view_shadow.layer.shadowPath = UIBezierPath(rect: view_shadow.bounds).cgPath
            view_shadow.layer.shadowColor = UIColor.black.cgColor
            view_shadow.layer.shadowOpacity = 0.4
            view_shadow.layer.shadowOffset = CGSize.zero
            view_shadow.layer.shadowRadius = 5
        }
        
        self.tv_main.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller /using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:- @IBOutlet
    @IBOutlet weak var view_combo_top_padding:NSLayoutConstraint!
    @IBOutlet weak var view_combo_bottom_padding:NSLayoutConstraint!
    @IBOutlet weak var view_shadow:UIView!
    
    //MARK:- Member
    fileprivate var m_from_target_top_margin:CGFloat = 1 // targetFrame과의 Vertical Margin 거리
    fileprivate var m_bottom_margin:CGFloat = 10 // 스크린 하단과의 Margin 거리
    fileprivate var m_cornerRadius:CGFloat = 6
    fileprivate var m_paddingFrame = PADDING(left: 15, top: 5, right: 15, bottom: 5)
    fileprivate var m_hidden_shadow:Bool = false
    fileprivate var m_division_color:UIColor?
    
    /// 메뉴를 표시할 수 있는 최대 Frame 영역
    fileprivate var m_default_frame:CGRect? = nil
    
    class PADDING
    {
        var top:CGFloat = 0
        var left:CGFloat = 0
        var right:CGFloat = 0
        var bottom:CGFloat = 0
        
        private init()
        {
            
        }
        
        init(left:CGFloat, top:CGFloat, right:CGFloat, bottom:CGFloat) {
            self.left = left
            self.top = top
            self.right = right
            self.bottom = bottom
        }
        
        static var zero: PADDING
        {
            get
            {
                return PADDING()
            }
        }
    }
    
    /// 콤보박스 모서리 BorderRadius 설정
    func setComboViewCornerRadius(_ cornerRadius:CGFloat) -> MenuDropDownPopupVC
    {
        self.m_cornerRadius = cornerRadius
        return self
    }
    
    /// TopMargin 설정 (Default = 1)
    func setTopMargin(_ topMargin:CGFloat) -> MenuDropDownPopupVC
    {
        self.m_from_target_top_margin = topMargin
        return self
    }
    
    func setShadow(isHidden:Bool) -> MenuDropDownPopupVC {
        m_hidden_shadow = isHidden
        return self
    }
    
    
    func setViewPadding(padding:PADDING) -> MenuDropDownPopupVC
    {
        self.m_paddingFrame = padding
        return self
    }
    
    
    func setDivisionLine(_ color:UIColor) -> MenuDropDownPopupVC
    {
        self.m_division_color = color
        return self
    }
    
    //MARK: Method - Popup Show
    func popup_show(_ vc: UIViewController?, _ target_view:UIView)
    {
        var tmpView:UIView? = target_view.superview
        var tmpRect = target_view.frame
        while tmpView != vc?.view
        {
            tmpRect = tmpView?.convert(tmpRect, to: tmpView?.superview) ?? tmpRect
            tmpView = tmpView?.superview
        }
        popup_show(vc, tmpRect)
    }
    
    func popup_show(_ vc: UIViewController?, _ target_frame:CGRect)
    {
        guard let valid_vc = vc else { return }
        DispatchQueue.main.async {
            valid_vc.present(self, animated: false) {
                
                let paddingHeight = self.m_paddingFrame.top + self.m_paddingFrame.bottom
                self.view_left.constant = target_frame.origin.x
                self.view_top.constant = target_frame.origin.y + target_frame.height + self.m_from_target_top_margin
                self.view_width.constant = target_frame.size.width
                
                self.view_height.constant = (CGFloat(self.m_arr_title.count) * self.tv_main_cell_height) + paddingHeight
                
                var target_view_height:CGFloat = valid_vc.view.frame.height;
                
                if #available(iOS 11.0, *) {
                    target_view_height = valid_vc.view.frame.height - (valid_vc.view.safeAreaInsets.top + valid_vc.view.safeAreaInsets.bottom)
                }
                
                // DropDown뷰의 위치Y+높이가 보여질 뷰보다 클 경우 DropUp으로 전환
                if self.view_top.constant + self.view_height.constant > target_view_height
                {
                    
////                    debugPrint(d:self.view_top.constant, self.view_height.constant, valid_vc.view.frame.height)
//                    if self.view_top.constant - self.view_height.constant > 0
//                    {
//                        // 반전 O, 조건 = 반전했을때 vc_view's top에 도달하지 않을 경우
//                        self.view_top.constant -= (target_frame.size.height + self.view_height.constant)
//                        self.m_from_target_top_margin = -self.m_from_target_top_margin
//                    }
//                    else
                    if ((target_view_height / 2) + UIApplication.shared.statusBarFrame.height + target_frame.height) < self.view_top.constant
                    {
                        // 반전 O, 조건 = 반전 안했을때의 높이값보다 반전했을때의 높이값이 아이템을 더 많이 보여줄 수 있을 경우
                        // 기준 = 뷰중앙 + 타겟뷰의 높이값이 DropDown view_top보다 작을 경우
                        
                        
                        // DropDown메뉴가 작을 수 있음
                        let height1 = self.view_height.constant // 기존 사이즈
                        let height2 = target_frame.origin.y - UIApplication.shared.statusBarFrame.height - self.m_bottom_margin // 뷰에 표시할 수 있는 최상단
                        if height1 < height2{ // DropDown메뉴 크기가 작을 경우
                            self.view_top.constant = target_frame.origin.y - height1
                            // bottomMargin 적용해야할듯 => topMargin으로
                        }
                        else{
                            // 뷰의 높이값 vc_view's top까지
                            self.view_height.constant = height2
                            self.view_top.constant = UIApplication.shared.statusBarFrame.height + self.m_bottom_margin
                            
                            self.view_height.constant -= self.m_from_target_top_margin
                        }
                    }
                    else
                    {
                        // 반전 X, 뷰의 높이값 vc_view's bottom까지
                        self.view_height.constant = target_view_height - self.view_top.constant
                        
                        // Margin Bottom
                        self.view_height.constant -= self.m_bottom_margin
                    }
                }else
                {
                    if self.view_top.constant + self.view_height.constant > (target_view_height - self.m_bottom_margin)
                    {
                        self.view_height.constant = target_view_height - self.m_bottom_margin
                    }
                }
                
                
                DispatchQueue.main.async {
                    //                    self.view_shadow.layer.shadowPath = UIBezierPath(rect: self.view_shadow.bounds).cgPath
                    self.view_shadow.layer.shadowPath = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: self.view_width.constant, height: self.view_height.constant)).cgPath
                    self.view_shadow.isHidden = false
                    self.tv_main.reloadData()
                    
                    if let valid_default_selection_title = self.m_default_selection_title
                    {
                        for idx in stride(from:0, to:self.m_arr_title.count, by:1)
                        {
                            if self.m_arr_title[idx] == valid_default_selection_title
                            {
                                self.tv_main.selectRow(at: IndexPath(row: idx, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
                                break
                            }
                        }
                    }
                }
                
                UIView.animate(withDuration: 0.15) {
                    self.view_combo.alpha = 1
                    self.view_shadow.alpha = 1
                }
            }
        }
    }
    
    func addView(_ parentView: UIView, _ menuView_frame:CGRect)
    {
        if let vc = parentView.findViewController()
        {
            DispatchQueue.main.async {
                vc.addChild(self)
                parentView.addSubview(self.view)
                
                let paddingHeight = self.m_paddingFrame.top + self.m_paddingFrame.bottom
                
                let view_x = menuView_frame.origin.x
                let view_y = menuView_frame.origin.y + self.m_from_target_top_margin
                let view_w = menuView_frame.size.width
                let view_h = min(menuView_frame.height  - self.m_from_target_top_margin - self.m_bottom_margin, (CGFloat(self.m_arr_title.count) * self.tv_main_cell_height) + paddingHeight)
                self.view.frame = CGRect(x: view_x, y: view_y, width: view_w, height: view_h)
                
                self.m_default_frame = CGRect(x: view_x, y: view_y, width: view_w, height: menuView_frame.height  - self.m_from_target_top_margin - self.m_bottom_margin)
                
                self.view_left.constant = 0
                self.view_top.constant = 0
                self.view_width.constant = view_w
                self.view_height.constant = view_h
                
                
                DispatchQueue.main.async {
                    //                    self.view_shadow.layer.shadowPath = UIBezierPath(rect: self.view_shadow.bounds).cgPath
                    self.view_shadow.layer.shadowPath = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: self.view_width.constant, height: self.view_height.constant)).cgPath
                    self.view_shadow.isHidden = false
                    self.tv_main.reloadData()
                    
                    if let valid_default_selection_title = self.m_default_selection_title
                    {
                        for idx in stride(from:0, to:self.m_arr_title.count, by:1)
                        {
                            if self.m_arr_title[idx] == valid_default_selection_title
                            {
                                self.tv_main.selectRow(at: IndexPath(row: idx, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
                                break
                            }
                        }
                    }
                }
                
                UIView.animate(withDuration: 0.15) {
                    self.view_combo.alpha = 1
                    self.view_shadow.alpha = 1
                }
            }
        }
    }
    
    @IBAction func popup_dismiss()
    {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.15, animations: {
                self.view_combo.alpha = 0
                self.view_shadow.alpha = 0
            }) { (finished) in
                if finished
                {
                    self.m_event = nil
                    self.m_arr_title = [String]()
                    self.tv_main.delegate = nil
                    self.dismiss(animated: false, completion:nil)
                    // Completion에 넣었는데 Fire가 안일어남
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }
            }
        }
    }
    
    public func popup_dismiss(_ completion:@escaping ()->()) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.15, animations: {
                self.view_combo.alpha = 0
                self.view_shadow.alpha = 0
            }) { (finished) in
                if finished
                {
                    self.m_event = nil
                    self.m_arr_title = [String]()
                    self.tv_main.delegate = nil
                    self.dismiss(animated: false, completion:completion)
                    // Completion에 넣었는데 Fire가 안일어남
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }
            }
        }
    }
    
    //MARK: Method - Modify
    func reloadData(_ arr_title:[String], _ default_select:String? = nil, _ event:@escaping EVENT )
    {
        self.m_arr_title = arr_title
        self.m_default_selection_title = default_select
        self.m_event = event
        DispatchQueue.main.async {
            if let default_frame = self.m_default_frame
            {
                let paddingHeight = self.m_paddingFrame.top + self.m_paddingFrame.bottom
                self.view.frame = default_frame
                let view_h = min(default_frame.height  - self.m_from_target_top_margin - self.m_bottom_margin, (CGFloat(self.m_arr_title.count) * self.tv_main_cell_height) + paddingHeight)
                // min(default_frame.height, (CGFloat(self.m_arr_title.count) * self.tv_main_cell_height) + paddingHeight) - self.m_from_target_top_margin - self.m_bottom_margin
                self.view.frame.size.height = view_h
                
                
                self.view_left.constant = 0
                self.view_top.constant = 0
                self.view_width.constant = default_frame.width
                self.view_height.constant = self.view.frame.size.height
                self.view_shadow.layer.shadowPath = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: self.view_width.constant, height: self.view_height.constant)).cgPath
            }
            self.tv_main.delegate = self
            self.tv_main.reloadData()
        }
    }
}

/// extension MenuDropDownPopupVC : UITableViewDataSource, UITableViewDelegate
extension MenuDropDownPopupVC : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_arr_title.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "1", for: indexPath) as?  MenuDropDownPopupTVC
        {
            cell.lbl_title.text = m_arr_title[indexPath.row]
            cell.lbl_title.font = self.tv_main_cell_lbl_font
            cell.lbl_title.textColor = self.tv_main_cell_lbl_color
            if let valid_highlight_color = self.tv_main_cell_lbl_selected_color
            {
                cell.lbl_title.highlightedTextColor = valid_highlight_color
            }
            
            cell.lbl_title_margin_left.constant = m_paddingFrame.left
            cell.lbl_title_margin_right.constant = m_paddingFrame.right
            cell.lbl_title.textAlignment = tv_main_cell_lbl_alignment
            
            let selectionView = UIView.init()
            selectionView.backgroundColor = tv_main_cell_selected_color
            cell.selectedBackgroundView = selectionView
            
            if indexPath.row != m_arr_title.count-1 {
                if let divisionColor = self.m_division_color {
                    let divisionView = UIView(frame: CGRect(x: 10, y: cell.frame.height-1.0, width: cell.frame.width-20.0, height: 1))
                    divisionView.backgroundColor = divisionColor
                    divisionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    selectionView.addSubview(divisionView)
                    cell.addSubview(divisionView)
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.m_event?(indexPath.row, self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tv_main_cell_height
    }
}

*/
