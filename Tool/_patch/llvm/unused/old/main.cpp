#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
	// Create a pipe.
	// This command can be executed by bash.exe and cmd.exe
	FILE * pipe = popen("echo | g++ -E -Wp,-v -xc++ - 2>&1", "r");

	bool see_start = false;
	char line[4096];
	const char * start = "#include <...> search starts here:\n";
	const char * end = "End of search list.\n";
	// https://cplusplus.com/reference/cstdio/fgets
	while (fgets(line, sizeof(line), pipe)) {
		if (!see_start) {
			if (strcmp(line, start) == 0) {
				see_start = true;
			} else {
				// ignore
			}
		} else {
			if (strcmp(line, end) == 0) {
				break;
			} else {
				char * p = strchr(line, '\n');
				if (p) {
					*p = 0;
				} else {
					// without end of line ?
					break;
				}
				printf("%s\n", line + 1);
				// AddPath(line + 1, CXXSystem, false);
			}
		}
	}

	// Close the pipe.
	pclose(pipe);

	return 0;
}
