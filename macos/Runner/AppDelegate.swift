import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    var popover: MainFlutterWindow!
    var statusBarItem: NSStatusItem!
    var positioningView: NSView?
      
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
      
    override func applicationDidFinishLaunching(_ aNotification: Notification) {
        // TODO: complain to Felix about this
        if let window = mainFlutterWindow.contentView?.window {
            window.setContentSize(NSSize(width: 0, height: 0))
        }

        // Create a new popover and set the size and content controller
        let popover = MainFlutterWindow()
        popover.contentSize = NSSize(width: 500, height: 400)
        popover.behavior = .transient
        let flutterViewController = FlutterViewController.init()
        RegisterGeneratedPlugins(registry: flutterViewController)
        popover.contentViewController = flutterViewController
        self.popover = popover
        
        // Create a new status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        // Assign the action and title
        if let button = self.statusBarItem.button {
            button.title = "Flutter Demo"
            button.action = #selector(togglePopover(_:))
        }
    }
      
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                // Get the positioning view and add it to the button
                let positioningView = NSView(frame: button.bounds)
                positioningView.identifier = NSUserInterfaceItemIdentifier(rawValue: "positioningView")
                button.addSubview(positioningView)

                // Show the popover relative to the positioning view
                popover.show(relativeTo: positioningView.bounds, of: positioningView, preferredEdge: .maxY)

                // Move the bounds so that the arrow of the popover is hidden (this is optional)
                button.bounds = button.bounds.offsetBy(dx: 0, dy: button.bounds.height)
                if let popoverWindow = popover.contentViewController?.view.window {
                    popoverWindow.setFrame(popoverWindow.frame.offsetBy(dx: 0, dy: 10), display: false)
                }
            }
        }
    }
}
