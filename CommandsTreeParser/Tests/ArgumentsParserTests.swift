import XCTest

@testable import CommandsTreeParser

final class ArgumentsParserTests: XCTestCase {

    func test___parse___simple_help() {
        let sut = makeSUT()
        let help = """
          <project-name>          Имя проекта, мы знакомы с одним из: Avito, Debug, Demo, Test, Release, Profile, Autoteka, Autohub, indep, ai, dsl, clt, package-gen, mua, codegen, macro (default: Debug)
        """

        let parsedOptions = sut.parse(argumentsHelp: help)

        XCTAssertEqual(parsedOptions.count, 1)
    }

    func test___parse___shitty_help() {
        let sut = makeSUT()
        let help = """
        <project-name>          Имя проекта, мы знакомы с одним из: Avito, Debug,
                                Demo, Test, Release, Profile, Autoteka, Autohub,
                                indep, ai, dsl, clt, package-gen, mua, codegen, macro
                                (default: Debug)
        """

        let parsedOptions = sut.parse(argumentsHelp: help)

        XCTAssertEqual(parsedOptions.count, 1)
    }

    private func makeSUT() -> ArgumentsParser {
        ArgumentsParser()
    }
}

