import UIKit
import MixinServices

class GroupCallConfirmationViewController: CallViewController {
    
    private let conversation: ConversationItem
    
    private var members = [UserItem]()
    
    init(conversation: ConversationItem, service: CallService) {
        self.conversation = conversation
        super.init(service: service)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFunctionSwitchesHidden(true)
        setConnectionButtonsEnabled(true)
        minimizeButton.setImage(R.image.ic_title_close(), for: .normal)
        minimizeButton.tintColor = .white
        inviteButton.isHidden = true
        nameLabel.text = conversation.getConversationName()
        peerToPeerCallRemoteUserStackView.isHidden = true
        groupCallMembersCollectionView.isHidden = false
        
        // A CallViewController is shown when user picks the accept button, nearly identical
        // to this ViewController but with text in status label. If we don't put a placeholder
        // here, the avatar group jitters on interface switching
        statusLabel.text = " "
        
        hangUpStackView.alpha = 0
        acceptStackView.alpha = 1
        acceptButtonTrailingConstraint.priority = .defaultLow
        acceptButtonCenterXConstraint.priority = .defaultHigh
        groupCallMembersCollectionView.dataSource = self
    }
    
    override func minimizeAction(_ sender: Any) {
        CallService.shared.dismissCallingInterface()
    }
    
    override func acceptAction(_ sender: Any) {
        CallService.shared.requestStartGroupCall(conversation: conversation, invitingMembers: [])
    }
    
    func loadMembers(with userIds: [String]) {
        DispatchQueue.global().async {
            let members = UserDAO.shared.getUsers(with: userIds)
            DispatchQueue.main.async {
                self.members = members
                if self.isViewLoaded {
                    self.groupCallMembersCollectionView.reloadData()
                }
            }
        }
    }
    
}

extension GroupCallConfirmationViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.group_call_member, for: indexPath)!
        let member = members[indexPath.row]
        cell.avatarImageView.setImage(with: member)
        cell.connectingView.isHidden = true
        return cell
    }
    
}
