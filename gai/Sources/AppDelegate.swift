/*

 Костыли чтоб подружить SPM, macOS app и не создавать руками проект в Xcode:
 https://theswiftdev.com/how-to-build-macos-apps-using-only-the-swift-package-manager/

 Комментарий от ChatGPT:

 Этот метод позволяет разрабатывать GUI-приложения полностью в обход Xcode, используя только SPM и ваш любимый текстовый редактор.
 Однако, как подчеркивается в статье, такой подход имеет ограничения:

 - Подача в Mac App Store: Созданные таким образом приложения не могут быть отправлены в Mac App Store без дополнительной упаковки и подписи кода через Xcode или другие средства.
 - Отсутствие кодовой подписи: Бинарные файлы не подписываются автоматически, что может быть требованием для некоторых API или для распространения приложения.
 - Ресурсы: Хотя SPM поддерживает ресурсы с версии Swift 5.3, их управление может быть менее удобным, чем в Xcode.

 */

import AppKit
import SwiftUI
import ComposableArchitecture
import CommandsTree

final class WindowDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.terminate(0)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let window = NSWindow()
    private let windowDelegate = WindowDelegate()

    private lazy var store = Store(
        initialState: GaiFeature.State(),
        reducer: {
            GaiFeature()
        }
    )

    private lazy var gaiView = GaiView(store: store)
    private let rootCommandParameter: String

    init(rootCommandParameter: String) {
        self.rootCommandParameter = rootCommandParameter
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        let appMenu = NSMenuItem()
        appMenu.submenu = NSMenu()
        appMenu.submenu?.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        let mainMenu = NSMenu(title: "gai")
        mainMenu.addItem(appMenu)
        NSApplication.shared.mainMenu = mainMenu

        let size = CGSize(
            width: 800,
            height: 800
        )
        window.setContentSize(size)
        window.styleMask = [.closable, .miniaturizable, .resizable, .titled]
        window.delegate = windowDelegate
        window.title = "gai 🚓"

        let view = NSHostingView(rootView: gaiView)
        view.frame = CGRect(origin: .zero, size: size)
        view.autoresizingMask = [.height, .width]
        window.contentView!.addSubview(view)
        window.makeKeyAndOrderFront(view)
        window.center()

        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)

        store.send(.appLaunched(rootCommandParameter: rootCommandParameter))
    }

    func applicationWillTerminate(_ notification: Notification) {
        store.send(.appWillTerminate)
    }
}
