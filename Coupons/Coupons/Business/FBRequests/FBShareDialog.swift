//
//  FBShareDialog.swift
//  Coupons
//
//  Created by hend elsisi on 5/31/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation
import UIKit

class FBShareDialog{
    static let instance = FBShareDialog()
    
    var currentViewController: UIViewController{
        get{
            return (UIApplication.shared.delegate?.window??.rootViewController)!
        }
    }
    
    func performFbShare(offer:Offer?,success:@escaping(Bool,String)->Void){
        let url = URL(string: (offer?.coup_link_Url)!)
        let content = LinkShareContent(url: url!)
        
        if Utility.instance.handleNetwork(){
            self.showShareDialog(content, mode:.automatic) { (postSucceed,pID) in
                if postSucceed{
                    //  self.delegate?.sharingFacebookdidSucceeded(pid: pID,offer:offer )
                    success(true,pID)
                }
                else{
                    UIUtils.instance.showAlertWithMsg(NSLocalizedString("errorShareMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("errorShareTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
                }
            }
        }
    }
    
    //Mark: - share facebook dialog
    private  func showShareDialog<C: ContentProtocol>(_ content:C, mode: ShareDialogMode = .automatic,handler:@escaping (Bool,String)->Void) {
        let dialog = ShareDialog(content: content)
        dialog.presentingViewController = self.currentViewController
        dialog.mode = mode
        
        dialog.completion = { result in
            // Handle share results
            switch result {
            case .success(let shareResult):
                
                let post = shareResult as? PostSharingResult
              self.handleSuccessfulFBDialogReturn(post: post, handler: handler)
                
            case .failed(let error):
                
                self.showFailureFbShareAlert()
                handler(false,"")
                
                print("\(error.localizedDescription)")
            case .cancelled:
                self.showCanceledFbShareAlert()
                handler(false,"")
            }
            print("got \(result)")
        }
        do {
            try dialog.show()
        } catch (let error) {
            print("Failed to present share dialog with error \(error)")
        }
    }
    
    func handleSuccessfulFBDialogReturn(post:PostSharingResult?,handler:@escaping (Bool,String)->Void){
        if post.debugDescription.contains("postId"){
            let postId:String = (post?.postId)!
            let pid = self.getValidationKey(pid: postId)
            handler(true,pid)
        }
        else{
            UIUtils.instance.showAlertWithMsg(NSLocalizedString("shareCanceledMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("shareCanceledTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
            handler(false,"")
        }
    }
    
    //extenssion on string
    func getValidationKey(pid:String)->String{
        var key:String = (AccessToken.current?.userId)!
        print("key \(key)")
        key.append("_")
        key.append(pid)
        print("search for \(key)")
        return key
    }
    
    func showFailureFbShareAlert(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("shareFailedMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("shareFailedTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
    
    func showCanceledFbShareAlert(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("shareCanceledMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("shareCanceledTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
    
}
