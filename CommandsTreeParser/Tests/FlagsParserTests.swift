import XCTest

@testable import CommandsTreeParser

final class FlagsParserTests: XCTestCase {

    func test___parse___simple_help() {
        let sut = makeSUT()
        let help = """
            -h, --help              Show help information.
          """

        let parsedFlags = sut.parse(optionsHelp: help)

        XCTAssertEqual(parsedFlags.count, 1)
        XCTAssertEqual(parsedFlags[0].id, "--help")
    }

    func test___parse___with_shitty_help() {
        let sut = makeSUT()
        let help = """
          --application/--reveal  Определяет, чем открыть проект.
                                  application - Открывает в приложении по умолчанию; reveal - Открывает в Finder (default: --application)
          --module <module>       Открыть проект для указанного модуля
          -u, --unit-tests/-c, --component-tests/-f, --functional-tests
                                  Для проекта Test определяет, для каких тестов открыть модуль.
                                  -u, --unit-tests: Открывает юнит-тесты
                                  -c, --component-tests: Открывает компонентные тесты
                                  -f, --functional-tests: Открывает функциональные тесты
          """

        let parsedFlags = sut.parse(optionsHelp: help)

        XCTAssertEqual(parsedFlags.count, 2)
    }

    private func makeSUT() -> FlagsParser {
        FlagsParser()
    }
}

