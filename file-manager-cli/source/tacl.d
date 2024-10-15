module tacl;
import std.stdio;

enum Colors {
    Reset = "\x1b[0;0m",
    Black = "\x1b[0;30m",
    Red = "\x1b[0;31m",
    Green = "\x1b[0;32m",
    Yellow = "\x1b[0;33m",
    Blue = "\x1b[0;34m",
    Magenta = "\x1b[0;35m",
    Cyan = "\x1b[0;36m",
    White = "\x1b[0;37m"
}

enum Dim {
    Black = "\x1b[2;30m",
    Red = "\x1b[2;31m",
    Green = "\x1b[2;32m",
    Yellow = "\x1b[2;33m",
    Blue = "\x1b[2;34m",
    Magenta = "\x1b[2;35m",
    Cyan = "\x1b[2;36m",
    White = "\x1b[2;37m"
}


enum Bold {
    Black = "\x1b[1;30m",
    Red = "\x1b[1;31m",
    Green = "\x1b[1;32m",
    Yellow = "\x1b[1;33m",
    Blue = "\x1b[1;34m",
    Magenta = "\x1b[1;35m",
    Cyan = "\x1b[1;36m",
    White = "\x1b[1;37m"
}

void clearAll() {
    write("\033c");
}