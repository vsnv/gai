import XCTest

@testable import CommandsTreeParser

final class SubcommandsParserTests: XCTestCase {

    func test___parse___simple_help() {
        let sut = makeSUT()
        let subcommandsHelp = """
          clean                   Очистка различных кешей
          install                 Установка зависимостей и генерация проекта
          """

        let parsedSubcommands = sut.parse(subcommandsHelp: subcommandsHelp)

        XCTAssertEqual(parsedSubcommands.count, 2)
        XCTAssertEqual(parsedSubcommands[0], "clean")
        XCTAssertEqual(parsedSubcommands[1], "install")
    }

    func test___parse___with_shitty_help() {
        let sut = makeSUT()
        let subcommandsHelp = """
          init                    Initialize a new package
          diagnose-api-breaking-changes
                                    Diagnose API-breaking changes to Swift modules in a package
          dump-symbol-graph       Dump Symbol Graph
          """

        let parsedSubcommands = sut.parse(subcommandsHelp: subcommandsHelp)

        XCTAssertEqual(parsedSubcommands.count, 3)
        XCTAssertEqual(parsedSubcommands[0], "init")
        XCTAssertEqual(parsedSubcommands[1], "diagnose-api-breaking-changes")
        XCTAssertEqual(parsedSubcommands[2], "dump-symbol-graph")
    }

    private func makeSUT() -> SubcommandsParser {
        SubcommandsParser()
    }
}

