//
//  GameViewController.swift
//  Serendipity
//
//  Created by Tony Xiao on 2/10/15.
//  Copyright (c) 2015 Serendipity. All rights reserved.
//

import Foundation

@objc(GameViewController)
class GameViewController : BaseViewController {
    
    @IBOutlet weak var dockBadge: UIImageView!
    var gameView: GameView! { return view as GameView }
    
    var currentCandidates : [Candidate]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKetchBoat = false

        // Setup tap to view profile
        for bubble in gameView.bubbles {
            bubble.didTap = { [weak self, weak bubble] _ in
                self?.showCandidateProfiles(bubble!.candidate!)
                return
            }
        }
        gameView.didConfirmChoices = { [weak self] in
            if let this = self { this.submitChoices(this) }
        }
        assert(currentCandidates.count == 3, "There must be exactly 3 candidates before starting game")
        gameView.startNewGame(currentCandidates)
    }
    
    override func handleScreenEdgePan(edge: UIRectEdge) -> Bool {
        if edge == .Right {
            performSegue(.GameToDock)
            return true
        }
        return super.handleScreenEdgePan(edge)
    }
    
    // MARK: -
    
    func showCandidateProfiles(candidate: Candidate) {
        let users = currentCandidates.map { $0.user! }
        let index = find(currentCandidates, candidate)!
        let pageVC = ProfileViewController.pagedController(users, initialPage: index)
        presentViewController(pageVC, animated: true)
    }
    
    @IBAction func submitChoices(sender: AnyObject) {
        if !gameView.isReady {
            UIAlertView.show("Error", message: "Need to uniquely assign keep match marry")
        } else {
            let marry = gameView.chosenCandidate(.Yes)!
            let keep = gameView.chosenCandidate(.Maybe)!
            let skip = gameView.chosenCandidate(.No)!
            Core.candidateService.submitChoices(marry, no: skip, maybe: keep).deliverOnMainThread().subscribeNextAs { (res : [String:String]) -> () in
                if res.count > 0 {
                    let connection = Connection.findByDocumentID(res["yes"]!)!
                    self.rootVC.showNewMatch(connection)
                }
            }
        }
    }
    
}