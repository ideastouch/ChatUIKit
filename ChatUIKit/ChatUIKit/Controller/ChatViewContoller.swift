//
//  CocoaChatViewContoller.swift
//  TroupeFitTrainer
//
//  Created by Gustavo Halperin on 11/10/18.
//  Copyright © 2018 TroupeFit. All rights reserved.
//

import UIKit

open class ChatViewController: UIViewController {
    static public let CellIdentifier = "ChatCellIdentifier"
    public var navigationTitle = "Messages"
    public var dataSource: UITableViewDataSource? { didSet {
        if let _ = self.viewIfLoaded, let tableView = self.tableView {
            tableView.dataSource = self.dataSource } } }
    public var delegate: UITableViewDelegate? { didSet {
        if let _ = self.viewIfLoaded, let tableView = self.tableView {
            tableView.delegate = self.delegate } } }
    public var sendMessageBlock: ((_ message:String, _ complete:@escaping ()->Void)->Void)?
    public var refreshControlBlock: (()->Void)?
    
    @IBOutlet public weak var tableView: UITableView! {
        didSet {
            if self.tableView != nil {
                self.tableView.register(BubbleTableViewCell.self, forCellReuseIdentifier: ChatViewController.CellIdentifier) } } }
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navToSafeAreaLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var toolbarBackground: UIImageView!
    @IBOutlet weak var textBackground: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toolbarHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromBottomSafeareaLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction public func tapGestureRecognizerViewAction(_ sender: Any) {
        if self.textView.isFirstResponder {
            self.textView.resignFirstResponder() } }
    
    public init() {
        super.init(nibName: "ChatViewController", bundle: ChatUIKit.bundle()) }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: ChatUIKit.bundle())
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        self.view = nibView
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.translatesAutoresizingMaskIntoConstraints = true }
    
    
    @objc func refreshControlAction() {
        self.refreshControlBlock?()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(BubbleTableViewCell.self, forCellReuseIdentifier: ChatViewController.CellIdentifier)
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self.delegate
        self.checkOnNavigationPosition()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(ChatViewController.refreshControlAction),
                                 for: UIControl.Event.valueChanged)
        self.tableView.refreshControl = refreshControl }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChatViewController.keyboardWillChangeFrameNotificationAction(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChatViewController.keyboardDidChangeFrameNotificationAction(_:)),
            name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        self.navigationItem.title = self.navigationTitle
        self.sendButton.isEnabled = self.textView.text.count > 0 }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkOnNavigationPosition() }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) }
    
    fileprivate func keyboardUserInfoValues(_ userInfo:NSDictionary) -> (UInt32, TimeInterval, CGFloat)? {
        if let animationCurveUser = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uint32Value,
            let animationDurationUser = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let frameEndUser = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let frame = self.view.frame
            let frameEnd = self.view.convert(frameEndUser, from: self.view.window)
            let heightEnd = frame.origin.y + frame.size.height - frameEnd.origin.y
            return (animationCurveUser, animationDurationUser, heightEnd) }
        else {
            return nil } }
    
    fileprivate func keyboardAnimationLegacy(_ notification:Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let (animationCurveUser, animationDurationUser, heightEnd) =
            self.keyboardUserInfoValues(userInfo as NSDictionary) else {
                return }
        let animationOptions =  UIView.AnimationOptions(rawValue: UInt(animationCurveUser))
        if self.fromBottomSafeareaLayoutConstraint.constant == -heightEnd { return }
        let animationBlock = { () in
            self.fromBottomSafeareaLayoutConstraint.constant = -heightEnd
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded() }
        if animationDurationUser == 0 {
            animationBlock()
            return
        }
        UIView.animate(withDuration: animationDurationUser,
                       delay: 0,
                       options: animationOptions,
                       animations: animationBlock,
                       completion: { (Bool) in })
    }
    
    fileprivate func keyboardAnimation(_ notification:Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let (animationCurveUser, animationDurationUser, _) =
            self.keyboardUserInfoValues(userInfo as NSDictionary) else {
                return }
        let animationOptions =  UIView.AnimationOptions(rawValue: UInt(animationCurveUser))
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return }
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -self.additionalSafeAreaInsets.bottom)
        let intersection = safeAreaFrame.intersection(keyboardFrameInView)
        UIView.animate(withDuration: animationDurationUser, delay: 0, options: animationOptions,
                       animations: {
                        self.additionalSafeAreaInsets.bottom = intersection.height
                        self.view.layoutIfNeeded() },
                       completion: nil)
    }
    
    @objc func keyboardWillChangeFrameNotificationAction(_ notification:Notification){
        if #available(iOS 11.0, *) {
            self.keyboardAnimation(notification)
        }
        else {
            self.keyboardAnimationLegacy(notification)
        } }
    
    @objc func keyboardDidChangeFrameNotificationAction(_ notification:Notification){
        if #available(iOS 11.0, *) {
            self.resetTablePosition()
            return }
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let (_, _, heightEnd) =
            self.keyboardUserInfoValues(userInfo as NSDictionary) else {
                return }
        if self.fromBottomSafeareaLayoutConstraint.constant != -heightEnd {
            let animationBlock = { () in
                self.fromBottomSafeareaLayoutConstraint.constant = -heightEnd
                self.view.layoutIfNeeded() }
            animationBlock() }
        self.resetTablePosition() }
    
    func checkOnNavigationPosition () {
        if #available(iOS 11.0, *) { return }
        let originY = CGFloat(20)
        let duration = TimeInterval(0.5)
        if (self.navigationBar.frame.origin.y != originY) {
            UIView.animate(withDuration: duration) {
                self.navToSafeAreaLayoutConstraint.constant = 20 - self.navigationBar.frame.origin.y
                self.view.layoutIfNeeded() } } }
    
    override open func viewSafeAreaInsetsDidChange() {
        self.checkOnNavigationPosition() }
    
    
    public func resetTablePosition(){
        guard let dataSource = self.tableView?.dataSource else { return }
        guard let sectionCount = dataSource.numberOfSections?(in: self.tableView) else { return }
        if sectionCount == 0 { return }
        let rowCount = dataSource.tableView(self.tableView, numberOfRowsInSection: sectionCount - 1)
        if rowCount == 0 { return }
        let indexPath = NSIndexPath(indexes:[0, rowCount - 1], length:2) as IndexPath
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true) }
    
    
    @IBAction func sendAction(_ sender: Any) {
        if self.textView.isFirstResponder {
            self.textView.resignFirstResponder() }
        guard let message = self.textView.text, message.count > 0 else { return }
        self.sendMessageBlock?(message, { self.textView.text = nil }) }
}
