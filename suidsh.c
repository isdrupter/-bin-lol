// Defined so we get asprintf
#define _GNU_SOURCE

#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <pwd.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/stat.h>
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <inttypes.h>

#ifndef SCRIPT_NAME
#error SCRIPT_NAME is undefined. You must specify a script name.
#endif

#define PASTE(a, b, c) a ## b ## c
#define START_SYM(name) PASTE(_binary_, name, _start)
#define SIZE_SYM(name) PASTE(_binary_, name, _size)

extern char START_SYM(SCRIPT_NAME);
extern size_t SIZE_SYM(SCRIPT_NAME);

const char *script = &START_SYM(SCRIPT_NAME);
const size_t size = (size_t) &SIZE_SYM(SCRIPT_NAME);

char template[] = "/tmp/scriptexec.XXXXXXX";

void cleanup() {
	if( unlink(template) == -1 )
		perror("unlink");
}

void setenv_if_exists( const char *name, const char *value ) {
	if( getenv(name) != NULL ) {
		if( setenv(name, value, 1) != 0 ) {
			perror("setenv");
			exit(EXIT_FAILURE);
		}
	}
}

int main( int argc, char *const argv[] ) {
	(void) argc;

	uid_t euid = geteuid();
	if( setreuid(euid, -1) != 0 ) {
		perror("setuid");
		exit(EXIT_FAILURE);
	}
	struct passwd *passwd = getpwuid(euid);
	if( passwd == NULL ) {
		perror("getpwuid");
		exit(EXIT_FAILURE);
	}
	setenv_if_exists("USER", passwd->pw_name);
	setenv_if_exists("HOME", passwd->pw_dir);
	setenv_if_exists("SHELL", passwd->pw_shell);
	char *str;
	asprintf(&str, "%ju", (uintmax_t) passwd->pw_uid);
	setenv_if_exists("UID", str);
	free(str);
	asprintf(&str, "%ju", (uintmax_t) passwd->pw_gid);
	setenv_if_exists("GID", str);
	free(str);

	/*
	 * VERY IMPORTANT
	 *
	 * There is a potential security vulnerability here. If an attacker is able
	 * to replace the file returned by mkstemp before the call to exec or the
	 * interpreter specified in the shebang is able to read the file, that would
	 * be bad.
	 */
	int tmpfd = mkstemp(template);
	if( tmpfd == -1 ) {
		perror("mkstemp");
		exit(EXIT_FAILURE);
	}
	if( atexit(cleanup) != 0 ) {
		perror("atexit");
		exit(EXIT_FAILURE);
	}

	const char *buf = script;
	size_t bufsiz = size;
	do {
		errno = 0;
		ssize_t written = write(tmpfd, buf, bufsiz);
		if( written == -1 && errno != EAGAIN && errno != EINTR ) {
			perror("write");
			exit(EXIT_FAILURE);
		}
		buf += written;
		bufsiz -= written;
	} while( bufsiz != 0 );
	if( fchmod(tmpfd, S_IRUSR | S_IWUSR | S_IXUSR) == -1 ) {
		perror("fchmod");
		exit(EXIT_FAILURE);
	}
	close(tmpfd);

	pid_t cpid = fork();
	if( cpid == -1 ) {
		perror("fork");
		exit(EXIT_FAILURE);
	} else if( cpid == 0 ) {
		if( execv(template, argv) == -1 ) {
			perror("execve");
			exit(EXIT_FAILURE);
		}
		assert(false);
	} else {
		int status;
		waitpid(cpid, &status, 0);
		return WEXITSTATUS(status);
	}
	assert(false);
}
