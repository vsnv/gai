import XCTest

@testable import CommandsTreeParser

final class OptionsParserTests: XCTestCase {

    func test___parse___simple_help() {
        let sut = makeSUT()
        let optionsHelp = """
            --module <module>       Открыть проект для указанного модуля
          """

        let parsedOptions = sut.parse(optionsHelp: optionsHelp)

        XCTAssertEqual(parsedOptions.count, 1)
        XCTAssertEqual(parsedOptions[0].name, "--module")
    }

    func test___doesnt_parse___flags() {
        let sut = makeSUT()
        let optionsHelp = """
            --module <module>       Открыть проект для указанного модуля
            --application/--reveal  Определяет, чем открыть проект.
          """

        let parsedOptions = sut.parse(optionsHelp: optionsHelp)

        XCTAssertEqual(parsedOptions.count, 1)
        XCTAssertEqual(parsedOptions[0].name, "--module")
    }

//    func test___parse___with_shitty_help() {
//        let sut = makeSUT()
//        let help = """
//          --application/--reveal  Определяет, чем открыть проект.
//                                  application - Открывает в приложении по умолчанию; reveal - Открывает в Finder (default: --application)
//          --module <module>       Открыть проект для указанного модуля
//          -u, --unit-tests/-c, --component-tests/-f, --functional-tests
//                                  Для проекта Test определяет, для каких тестов открыть модуль.
//                                  -u, --unit-tests: Открывает юнит-тесты
//                                  -c, --component-tests: Открывает компонентные тесты
//                                  -f, --functional-tests: Открывает функциональные тесты
//          -h, --help              Show help information.
//          """
//
//        let parsedOptions = sut.parse(optionsHelp: optionsHelp)
//
//        XCTAssertEqual(parsedOptions.count, 3)
//        XCTAssertEqual(parsedOptions[0], "init")
//        XCTAssertEqual(parsedOptions[1], "diagnose-api-breaking-changes")
//        XCTAssertEqual(parsedOptions[2], "dump-symbol-graph")
//    }

    private func makeSUT() -> OptionsParser {
        OptionsParser()
    }
}

