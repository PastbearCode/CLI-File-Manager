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
            writeln("[~] Root Directory: " ~ path);
        } else {
            writeln("[~]" ~ Colors.Green ~ (path.split(separator)[path.split(separator).length - 2]) ~ Colors.Reset);
        }

        // Display entries
        int i;
        foreach (name; entryNames) {
            string start;
            string end;
            if (i != entryNames.length - 1) {
                start = " |-";
            } else {
                start = " +-";
            }
            if (isDir(path ~ name)) {
                end = " []";
            } else {
                end = " ()";
            }
            writeln(start ~ Bold.Blue ~ name ~ Colors.Reset ~ end);
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
                path = separator;  // Ensure path is set to the root
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
