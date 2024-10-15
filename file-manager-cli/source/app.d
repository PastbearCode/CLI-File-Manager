import std.stdio;
import std.file;
import std.array;
import std.algorithm;
import std.conv;
import std.path;
import std.string;
import tacl;
import std.process;

auto getContentsAsFiles(string path) {
    auto entries = dirEntries(path, "*", SpanMode.shallow);
    return entries;
}

// Function to get top-level directory contents
string[] getContents(string path) {
    auto entries = dirEntries(path, "*", SpanMode.shallow);
    string[] entryNames;

    foreach (entry; entries) {
        entryNames ~= entry.name.to!(string);
    }

    return entryNames;
}

// Function to format entries to return only their names
string[] formatEntryNames(string[] entries) {
    string[] formated;
    string separator = dirSeparator;
    foreach (entry; entries) {
        formated ~= entry.split(separator)[entry.split(separator).length - 1];
    }
    return formated;
}

void main(string[] args) {
    if (args.length < 2) {
        return;
    }

    string path = args[1];
    string separator = dirSeparator;
    bool shouldShowMovePath;
    bool shouldShowPath;
    bool canGoBack = true;

    string[] colorStrings = [Bold.Black,Bold.Red,Bold.Green,Bold.Yellow,Bold.Blue,Bold.Magenta,Bold.Cyan,Bold.White];
    string[] colorStrings2 = [Colors.Black,Colors.Red,Colors.Green,Colors.Yellow,Colors.Blue,Colors.Magenta,Colors.Cyan,Colors.White];

    string[] icons = ["[]","()","[~]"];
    string fileColor = Bold.Blue;
    string dirColor = Bold.Yellow;
    string openDirColor = Colors.Green;

    while (true) {
        write("\033c"); // Clear the console
        string[] topLevelEntries = getContents(path);
        auto entriesAsFiles = getContentsAsFiles(path);

        // Check for empty directory
        if (topLevelEntries.length == 0) {
            writeln("No entries found in the directory.");
            continue; // Skip the rest of the loop
        }

        string[] entryNames = formatEntryNames(topLevelEntries);

        // Display current directory
        if (path == separator || (path.length == 3 && path[1] == ':')) {
            writeln(icons[2] ~ openDirColor ~ "Root Directory: " ~ path ~ Colors.Reset);
        } else {
            writeln(icons[2] ~ openDirColor ~ (path.split(separator)[path.split(separator).length - 2]) ~ Colors.Reset);
        }

        // Display entries
        int i;
        foreach (name; entryNames) {
            string start;
            string end;
            string color;
            if (i != entryNames.length - 1) {
                start = " |-";
            } else {
                start = " +-";
            }
            try {
                if (isDir(path ~ name)) {
                    end = icons[0];
                    color = dirColor;
                } else {
                    end = icons[1];
                    color = fileColor;
                }
            } catch(FileException e) {
                end = icons[1];
                color = fileColor;
            }
            writeln(start ~ color ~ name ~ Colors.Reset ~ end);
            i++;
        }

        i = 0;
        if (shouldShowMovePath) {
            writeln("Moved to parent directory: " ~ path);
        }
        if (shouldShowPath) {
            writeln(path);
        }
        string input = readln().replace("\n", "");
        if (input == "exit") {
            break;
        }
        if (input == "config") {
            string input2 = readln().replace("\n", "");
            if (input2 == "colors") {
                string input3 = readln().replace("\n", "");
                if (input3 == "dir") {
                    string input4 = readln().replace("\n", "");
                    dirColor = colorStrings[input4.to!int];
                } else if (input3 == "file") {
                    string input4 = readln().replace("\n", "");
                    fileColor = colorStrings[input4.to!int];
                } else if (input3 == "opendir") {
                    string input4 = readln().replace("\n", "");
                    openDirColor = colorStrings2[input4.to!int];
                }
            }
            if (input2 == "exit") {
                return;
            }
            
        }

        int j;
        foreach (name; entryNames) {
            if (input == name) {
                if (isDir(path ~ name)) {
                    path = path ~ name ~ separator;
                    canGoBack = true;
                } else if (isFile(path ~ name)) {
                    try {
                        executeShell(path ~ name);
                    } catch (Exception e) {
                        writeln(e);
                    }
                }
            }
            j++;
        }

        j = 0;
        shouldShowPath = false;
        if (input == "path") {
            shouldShowPath = true;
        }

        shouldShowMovePath = false;
        if (input == "back") {
            // Safeguard to check if we're already in the root directory
            if (path == separator || (path.length == 3 && path[1] == ':')) {
                writeln("You are already at the root directory.");
            } else {
                // Get the parent directory
                string parentPath = dirName(path);

                // Ensure the parent path is valid, else default to root
                if (parentPath == "" || parentPath == "." || parentPath == separator) {
                    path = separator;  // Set to root directory
                } else {
                    path = parentPath ~ separator;  // Move to the parent directory
                }
            }
            shouldShowMovePath = true;
        }


    }
}
