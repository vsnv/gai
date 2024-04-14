import CommandsModels

struct ParsedCommandHelp {
    // Required поле, если не можем его распарсить, то фейлим всю команду, значит там что-то пошло не так.
    let usage: String
    let overview: String?
    let options: [CommandOption]
    let flags: [CommandFlag]
    let subcommandsNames: [String]
    let arguments: [CommandArgument]
}
