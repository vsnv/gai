# gai

gai позволяет автоматически создавать графический UI для приложений командной строки на [swift-argument-parser](https://github.com/apple/swift-argument-parser).

## Disclaimer

Этот пет-проект, он создан по фану и на коленке. Качество кода, актуальность, безопасность, перфоманс, своевременные обновления - ничего не гарантируется.

По всем вопросам - к `@amvasnev`.

## How to Install

### Homebrew

``` Bash
brew install vsnv/repo/gai
```

## How to Use

``` Bash
gai <root-command>
```

Можно работать с любым CLI на [swift-argument-parser](https://github.com/apple/swift-argument-parser), например, с [SPM](https://github.com/apple/swift-package-manager/):

``` Bash
gai "swift package"
```

или

``` Bash
gai spm
```

[swift-format](https://github.com/apple/swift-format/):

``` Bash
gai swift-format
```

## How to Develop

``` Bash
git clone git@github.com:vsnv/gai.git
cd gai
xed .
```

``` Bash
swift run -- gai <root-command>
```

### Flow

1. Парсер вызывает рутовую команду с флагом `-h` и парсит ее аутпут в стуктуры данных.
2. Для каждой подкоманды распарсенной команды повторяется шаг 1, пока не завершится обход всего дерева команд.
3. На полученной модели строится вью дерева команд.
4. После выбора юзером нужной команды и аргументов команда запускается в терминале.
