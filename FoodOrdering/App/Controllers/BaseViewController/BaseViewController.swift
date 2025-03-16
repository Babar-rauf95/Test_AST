//
//  ViewController.swift
//  UpLevel
//
//  Created by techelix_iOS on 3/19/24.
//

import UIKit
import FirebaseMessaging
import MessageUI

enum AttendanceDuration{
    case fromTodayLastThirtyDays
    case currentMonthStartEnd
    case oneWeek
}

class BaseViewController: UIViewController, IdentifiableProtocol, Alertable {
    
    private var viewModel: BaseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BaseViewModel()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.sessionExpired),
                                               name: Notification.Name("SessionExpired"),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @objc func sessionExpired(){
        emptyUserValues()
    }
    
    func emptyUserValues() {
        
        updateFCMToken()
        
        AppConfig.shared.ACCESS_TOKEN             = nil // Automatically removes access token data from UserDefaults
        AppConfig.shared.USER_DETAILS             = nil // Automatically removes user details data from UserDefaults
        AppConfig.shared.PERMISSIONS              = nil // Automatically removes permissions data from UserDefaults
        AppConfig.shared.INSIGHT_DATA             = nil
        AppConfig.shared.CONTACT_DATA             = nil
        AppConfig.shared.RANK_SYSTEM              = nil
        AppConfig.shared.INSIGHTS_BY_LOCATION     = [:]
        
        ClientStorage.shared.remove(storageType: .widgetData)
        IntercomManager.shared.stopSession()
        LocationManager.sharedInstance.stopMonitoring()
        navigateToLogin()
    }
    
    func updateFCMToken(){
        
        TopicManager.shared.unsubscribeFromAll()
        
        Messaging.messaging().deleteToken { error in
            print("DELETE FCM ERROR")
            AppConfig.shared.FIREBASE_TOKEN = nil // Automatically removes firebase token data from UserDefaults
        }
        
        Messaging.messaging().token { fcm , error in
            AppConfig.shared.FIREBASE_TOKEN = fcm
        }
    }
    
    func navigateToLogin(){
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = StoryBoard.Auth.instantiateViewController(withIdentifier: LoginViewController.name) as! LoginViewController
        vc.setupViewModel(viewModel: LoginViewModel())
        
        let navVC = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = navVC
        appDelegate.window?.makeKeyAndVisible()
        
        //self.makeNewRootVC(UINavigationController(rootViewController: vc))
    }
}

//MARK: - Helper Methods
extension BaseViewController{
    
    //MARK: HideKeyBoard
    func hideKeyboardWhenTappedAround() {
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func handlePhoneCall(phoneNumbers: [String]) {
        if phoneNumbers.count == 0{
            showAlertWithSingleButton(title: "Error", buttonTitle: "OK", message: "No phone number available to call") {
                self.dismiss(animated: true) }
        }
        else if phoneNumbers.count == 1 {
            makePhoneCall(number: phoneNumbers[0])
        } else if phoneNumbers.count > 1 {
            showNumberSelectionPopup(with: phoneNumbers)
        } else {
            showAlertWithSingleButton(title: "Error", buttonTitle: "OK", message: "No phone number available") {
                self.dismiss(animated: true)
            }
        }
    }
    
    
    func openEmailComposer(to recipients: [String], subject: String, body: String, viewController: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            // Create the mail compose view controller
            let mailComposeVC = MFMailComposeViewController()
            
            // Set the delegate to self to handle the result
            mailComposeVC.mailComposeDelegate = viewController as? MFMailComposeViewControllerDelegate
            
            // Pre-fill the email details
            mailComposeVC.setToRecipients(recipients)
            mailComposeVC.setSubject(subject)
            mailComposeVC.setMessageBody(body, isHTML: false)
            
            // Present the mail compose view controller
            viewController.present(mailComposeVC, animated: true, completion: nil)
        } else {
            // Handle error if mail services are not available
            print("Mail services are not available")
            Toaster.shared.showErrorToast("Mail services are not available", view: self.view)
        }
    }
    
    
    func showAlertWithTitle(_ title:String?, message:String?,shouldShowImage:Bool = true) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func showNumberSelectionPopup(with numbers: [String]) {
        let alert = UIAlertController(title: "Select a Number", message: "Choose the number to call", preferredStyle: .actionSheet)
        
        for number in numbers {
            let action = UIAlertAction(title: number, style: .default) { _ in
                self.makePhoneCall(number: number)
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func makePhoneCall(number: String) { //this function is use to validate that if a call can be made or not
        if let phoneURL = URL(string: "tel://\(number)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                showAlertWithSingleButton(title: "Error", buttonTitle: "OK", message: "No phone number available or unable to make a call") {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func openWebURL(urlString: String) {
        UIApplication.shared.open(URL(string: urlString) ?? URL(fileURLWithPath: "") , options: [:], completionHandler: nil)
    }
    
    func createSpinner(showLoader: Bool, tableView: UITableView) -> UIView {
        if showLoader {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height / 5))
            let spinner = UIActivityIndicatorView()
            spinner.center = view.center
            view.addSubview(spinner)
            spinner.startAnimating()
            return view
        }
        return UIView()
    }
}

// MARK: - Navigation
extension BaseViewController {
    
    //MARK: Present_Single_Selection
    func presentSingleSelection(btnTag: Int, optionHeading: String?, option: [SelectionPopupData], selected: SelectionPopupData?,
                                completion: ((SelectionPopupData) -> (Void))?){
        let dvc = StoryBoard.Universal.instantiateViewController(withIdentifier: SelectionPopupVC.getIdentifier()) as! SelectionPopupVC
        dvc.btnTag = btnTag
        dvc.modalPresentationStyle = .custom
        dvc.modalTransitionStyle = .crossDissolve
        dvc.configureSingleSelection(option: option, selected: selected, completion: completion)
        dvc.heading = optionHeading
        self.present(dvc, animated: true)
    }
    
    //MARK: Present_Multi_Selection
    func presentMultiSelection(btnTag: Int, optionHeading: String?, option: [SelectionPopupData], selected: [SelectionPopupData]?,
                               completion: (([SelectionPopupData]) -> (Void))?){
        let dvc = StoryBoard.Universal.instantiateViewController(withIdentifier: SelectionPopupVC.getIdentifier()) as!  SelectionPopupVC
        dvc.btnTag = btnTag
        dvc.modalPresentationStyle = .custom
        dvc.modalTransitionStyle = .crossDissolve
        dvc.heading = optionHeading
        dvc.configureMultiSelection(option: option, selected: selected, completion: completion)
        self.present(dvc, animated: true)
    }
    
    //MARK: Show_Date_Picker
    func showDatePicker(showSelectionSegment: Bool,
                        datePickerMode: UIDatePicker.Mode = .date,
                        onlyShowDate: Bool = false,
                        isMinimumDate:Bool = true,
                        selectedFormat: DateFormates = .yyyy_MM_dd,
                        selectedDate: String? = "",
                        style:UIDatePickerStyle = .inline,
                        cancelCompletion: (() -> Void)? = nil,
                        completion: @escaping ((_ selectedDate: Date) -> Void) ){
        
        let vc = StoryBoard.Universal.instantiateViewController(withIdentifier: DatePickerCalendar.name) as! DatePickerCalendar
        vc.isDatePickerSegmentEnabled = showSelectionSegment
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.isMinimumDate = isMinimumDate
        vc.selectedDate = selectedDate ?? "" // Safely unwrap selectedDate
        vc.datePickerMode = datePickerMode
        vc.style = style
        vc.selectedFormat = selectedFormat
        vc.configureView(completion: completion, cancelCompletion: cancelCompletion)
        self.present(vc, animated: true)
    }
    
    //MARK: Show_Image_Viewer
    func showImageViewer(imageMedia: String) {
        let vc = StoryBoard.Universal.instantiateViewController(withIdentifier: ImageViewerVC.name) as! ImageViewerVC
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.imageMedia = imageMedia
        self.present(vc, animated: true)
    }
    
    //MARK: Present_Share_Sheet
    func presentShareSheet(for url: String) {
        guard let shareUrl = URL(string: url) else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .print]
        
        // For iPads, provide a source for the popover
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
   //MARK: Show_General_Popup
    func showGeneralPopup(id: Int, parentId: Int?, dueDate: String?, delegate: GeneralPopupDeleteProtcol?, popupType: GeneralPopupType){
        let vc = StoryBoard.Universal.instantiateViewController(withIdentifier: GeneralPopup.name) as! GeneralPopup
        
        let calendarRepo: CalendarRepoDeleteEventProtocol = CalendarRepository()
        let useCaseDeleteEvent: CalendarDeleteEventUseCaseProtocol = CalendarDeleteEventUseCase(calendarRepo: calendarRepo)
        let useCaseLogout: LogoutUseCaseProtocol = LogoutUseCase(authRepo: AuthRepository())
        
        let leadRepoDeleteNote: LeadRepoDeleteNoteProtocol = LeadRepository()
        let useCaseDeleteNote: DeleteNoteUseCaseProtocol = DeleteNoteUseCase(LeadRepo: leadRepoDeleteNote)
        
        vc.setupViewModel(
            viewModel: GeneralPopupViewModel(
                delegate: vc,
                useCaseDeleteEvent: useCaseDeleteEvent,
                useCaseLogout: useCaseLogout,
                deleteNoteUseCase: useCaseDeleteNote,
                isMainHeadingHidden: false,
                isSubHeadingHidden: false,
                resetPasswordPopup: nil,
                btnPrimaryHidden: false,
                btnSecondaryHidden: false,
                popupType: popupType,
                taskId: id,
                parentTaskId: parentId,
                dueDate: dueDate ?? "")
        )
        vc.delegate = delegate
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    //MARK: Show_Delegate_Recurring_Popup
    func showDeletePopupRecurringPopup(id: Int, parentId: Int, dueDate: String?, availableSlots: Int? ,delegate: DeletePopupRecurringProtocol? ,deleteRecurringType: DeleteRecurringType){
        let vc = StoryBoard.Universal.instantiateViewController(withIdentifier: DeletePopupRecurringTask.name) as! DeletePopupRecurringTask
        
        let calendarRepo: CalendarRepoDeleteEventProtocol = CalendarRepository()
        let useCaseDeleteEvent: CalendarDeleteEventUseCaseProtocol = CalendarDeleteEventUseCase(calendarRepo: calendarRepo)
        
        vc.setupVM(viewModel: DeletePopupRecurringTaskViewModel(delegate: vc,
                                                                deleteRecurringType: deleteRecurringType,
                                                                useCaseDeleteEvent: useCaseDeleteEvent,
                                                                id: id, parentId: parentId, dueDate: dueDate, availableSlots: availableSlots))
        vc.delegate = delegate
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    //MARK: Show_Delegate_Popup_For_Available_Slots
    func showDeletePopUpForAvailableSlots(id: Int, parentId: Int?, dueDate: String?, delegate: DeleteEventsProtcol?){
        let vc = StoryBoard.Universal.instantiateViewController(withIdentifier: DeleteEventsVC.name) as! DeleteEventsVC
        
        let calendarRepo: CalendarRepoDeleteEventProtocol = CalendarRepository()
        let useCaseDeleteEvent: CalendarDeleteEventUseCaseProtocol = CalendarDeleteEventUseCase(calendarRepo: calendarRepo)
        
        vc.setupVM(viewModel: DeleteEventViewModel(delegate: vc,
                                                   useCaseDeleteEvent: useCaseDeleteEvent,
                                                   id: id,
                                                   parentId: parentId ?? 0,
                                                   dueDate: dueDate))
        vc.delegate = delegate
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    //MARK: Show_Contact_Details
    func showContactDetails(contactID: Int){
        let vc = StoryBoard.Leads.instantiateViewController(withIdentifier: ContactDetailsVC.name) as! ContactDetailsVC
        
        let leadRepo: LeadRepoFetchContactDetailProtocol = LeadRepository()
        let useCase = GetContactDetailUseCase(LeadRepo: leadRepo)
        let updatePictureUSeCase = UpdateContactPictureUseCase(LeadRepo: leadRepo as! LeadRepoUpdateContactPictureProtocol)
        
        let viewModel = ContactDetailsViewModel(
            delegate: vc,
            getContactDetailUseCase: useCase,
            updateContactPictureUseCase: updatePictureUSeCase,
            contactID: contactID
        )
        
        vc.setupViewModel(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Present_Contacts_Popup
    func presentContactsPopup(delegate: StudentDataProtocol?){
        let vc = StoryBoard.Universal.instantiateViewController(withIdentifier: ContactsPopup.name) as! ContactsPopup
        let useCaseContact: GetContactListUseCaseProtocol = GetContactListUseCase()
        vc.setupViewModel(viewModel: ContactsPopupViewModel(getContactListUseCase: useCaseContact))
        vc.delegateContactData = delegate
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    //MARK: Show_Caution_Popup
    func showCautionPopup(
        delegate: CautionPopupVCProtocol?,
        cautionType: CautionPopupType,
        mainImage: UIImage? = UIImage.icWarningPopup,
        title: String,
        subTitle: String,
        hideCancelBtn: Bool,
        hideViewBtn: Bool,
        viewBtnTitle: String,
        userName: String?,
        paymentAmount: String?,
        declinedReason: String?,
        membershipID: Int?,
        createInvoiceLink: String?,
        contactID: Int?,
        selectedIndex: Int?
    ) {
        let vc = StoryBoard.Universal.instantiateViewController(withIdentifier: CautionPopupVC.getIdentifier()) as! CautionPopupVC
        
        let data = CautionData(
            cautionPopupType: cautionType,
            mainImage: mainImage,
            title: title,
            subtitle: subTitle,
            hideCancelBtn: hideCancelBtn,
            hideViewBtn: hideViewBtn,
            viewBtnTitle: viewBtnTitle,
            userName: userName,
            paymentAmount: paymentAmount,
            declinedReason: declinedReason,
            membershipID: membershipID,
            createInvoiceLink: createInvoiceLink,
            contactID: contactID
        )
        
        vc.delegate = delegate
        
        let repo: MembershipRepoPorcessMembershipProtocol = MembershipRepository()
        let useCaseProcessMembership: ProcessMembershipProtocol = ProcessMembershipUseCase(repo: repo)
        
        let chatRepo = ChatRepository()
        let markAsReadUseCase = MarkAsReadUseCase(chatRepo: chatRepo)
        
        vc.setupViewModel(viewModel: CautionPopupViewModel(delegate: vc,
                                                           useCaseProcessMembership: useCaseProcessMembership,
                                                           useCaseMarkAsRead: markAsReadUseCase,
                                                           cautionData: data))
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    
}

// MARK: - Setup pull to refresh
extension BaseViewController {
    
    func setupPullToRefresh(scrollableView: UIScrollView) { // pass UITableView, UICollectionView, UIScrollView
        
        scrollableView.refreshControl = UIRefreshControl()
        
        //            scrollableView.refreshControl?.tintColor = .systemYellow
        
        //            scrollableView.refreshControl?.backgroundColor = .systemBlue
        
        //        let attributes: [NSAttributedString.Key: Any] = [
        //            .foregroundColor: UIColor.blue,
        //            .font: UIFont.systemFont(ofSize: 14.0),
        //            .kern: 1.5, // Set character spacing
        //            .underlineStyle: NSUnderlineStyle.single.rawValue, // Underline the text
        //            .paragraphStyle: NSMutableParagraphStyle(), // Apply paragraph styles
        //            .strokeColor: UIColor.red, // Stroke color of the text
        //            .strokeWidth: -3.0 // Width of the text stroke, negative for filled text
        //        ]
        
        //        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh", attributes: attributes)
        scrollableView.refreshControl?.addTarget(self, action: #selector(pullToRefreshActionPerformed), for: .valueChanged)
    }
    
    // Pull to refresh method (to be called in view controllers)
    @objc func pullToRefreshActionPerformed(_ sender: UIRefreshControl) {
        
        if let scrollableView = sender.superview as? UIScrollView {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                scrollableView.panGestureRecognizer.isEnabled = false
                sender.endRefreshing()
                scrollableView.panGestureRecognizer.isEnabled = true
            }
        }
    }
}

// MARK: - BaseViewModelProtocols
extension BaseViewController: BaseViewModelProtocols {
    func isLoading(status: Bool){
        status ?  Loader.shared.show(self.view) : Loader.shared.hide(self.view)
    }
    
    func showMessage(message: String,type: ToastType){
        switch type {
        case .error:
            Toaster.shared.showErrorToast(message, view: self.view)
        case .success :
            Toaster.shared.showSuccesToast(message, view: self.view)
        }
    }
}

//MARK: - Delegate method to handle the result of the mail composer
extension BaseViewController:
    MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result {
        case .sent:
            print("Email sent successfully")
        case .saved:
            print("Email saved as draft")
        case .cancelled:
            print("Email composition cancelled")
        case .failed:
            print("Email sending failed")
        @unknown default:
            break
        }
    }
}
