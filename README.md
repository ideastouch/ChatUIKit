# ChatUIKit [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ChatUIKit.svg)](https://img.shields.io/cocoapods/v/ChatUIKit.svg)

An exquisite UIKit library for chatting interface.

`ChatUIKit` is a Swift lightweight framework to build chat applications. It's been designed to be extensible and performant. See it in action!

<img src="https://github.com/ideastouch/ChatUIKit/blob/master/images/chat05.png" height="360dp"> <img src="https://github.com/ideastouch/ChatUIKit/blob/master/images/chat10.png" height="360dp"> <img src="https://github.com/ideastouch/ChatUIKit/blob/master/images/chat15.png" height="360dp"> <img src="https://github.com/ideastouch/ChatUIKit/blob/master/images/chat20.png" height="360dp">


## Features
- Three colors of bubbles: "Me", friends, and others.
- Three types of heads and feet of the bubbles base on if they are in a group of bubbles of the same sender, or in a group of two or isolates.
- Bubble position reset automatically so always the last one is above the text input.
- Text input field height adaptable to the number of rows up to four rows and then become scrollable.
- Text bubbles
- Photo bubbles
- Extensible input bar

## How to install
### CocoaPods

1. Make sure `use_frameworks!` is added to your `Podfile`.

2. Include the following in your `Podfile`:
  ```
  pod 'ChatUIKit'
  ```
3. Run `pod install`

## How to use
### Inherit from ChatViewController
In the inheritance's case need to be called the super.init() and then initializer the ChatDataSource and his members.
```Swift

/* 
 The struct User must implement getter for objejectId and name and 
 function == because SenderProtocol must conform Equatable.
 */
struct User: SenderProtocol {
    var objectId: String?
    var name: String?
    public static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.objectId == rhs.objectId
    }
}

/* 
 The class MyMessage must implement getter for message, sender, timeStr, and dayStr.
 ChatUIKit provides a Date extension that export Date to time and day, see
 below the implementation.
 */
struct MyMessage: Message {
    var date: Date?
    var message: String?
    var sender: User?
    var timeStr: String? { get { return self.date?.chatUIKitTimeStr  } }
    var dayStr: String? { get { return self.date?.chatUIKitDayStr } }    
    public static func == (lhs: MyMessage, rhs: MyMessage) -> Bool {
        return lhs.objectId == rhs.objectId
    }

}

class MyChatViewController: ChatViewController {
	MyChatViewController(user: User) {
		super.init()
		let user = User.current()
        let chatDataSource = ChatDataSource<MyMessage, User>(owner: user, otherName:"Admin")
		self.dataSource = chatDataSource
        self.delegate = chatDataSource
        self.appointment = appointment
        self.chatPartner = chatPartner
        self.sendMessageBlock = { (_ message:String, _ succed:@escaping ()->Void) in
        	//  Your code probably should send the message to your server and only when gets
        	// the confirmation it will update the chat view controller or notifying about what
        	// was the problem.
        	guard let chatDataSource = self.dataSource as?
        		ChatDataSource<PersonMessage, Person> else { return }
            var message = MyMessage()
            message.message = message
            let user = User.current()
            message.sender = user
            if chatDataSource.chatList.contains( where: { $0 == message } ) { return }
            chatDataSource.chatList.append(message)
            chatViewController.tableView.reloadData()
            chatViewController.resetTablePosition()
            succed()
		}
    }
}

```

### Storyboard & Implementing Container View

	Be sure that the class  ChatViewController in your storyboard is pointing to module ChatUIKit.

```Swift
class MyContainerChatViewController: UIViewController {
    var chatViewController : ChatViewController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            identifier  == "MyContainerToChatViewControllerSegue",
            let chatViewController = segue.destination as? ChatViewController {
            self.chatViewController = chatViewController
            let user = User.current()
            let chatDataSource = ChatDataSource<MyMessage, User>(owner: user, otherName:"Admin")
            chatViewController.dataSource = chatDataSource
            chatViewController.delegate = chatDataSource
            chatViewController.sendMessageBlock = {
            	(_ message:String, _ succed:@escaping ()->Void) in
        			// Same implementation as before.
            }
        }
    }

```

### Update Chat View Controller with new message

```Swift
class MyContainerChatViewController: UIViewController {
    var chatViewController : ChatViewController?
	func messageArrive( message: MyMessage ){
        guard let chatDataSource = self.dataSource as? ChatDataSource<MyMessage, User> else {
        	return
        }
        if chatDataSource.chatList.contains( where: { $0 == message } ) { return }
        chatDataSource.chatList.append(message)
        chatViewController.tableView.reloadData()
        chatViewController.resetTablePosition()
	}
}
