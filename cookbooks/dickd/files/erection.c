#include <sys/socket.h>
#include <sys/wait.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <err.h>
#include <errno.h>
#include <signal.h>

#include "frames.h"

#define DEFAULT_FPS 24

void errdie(const char *msg)
{
    err(1, "%s", msg);
}

static void usage(void)
{
    const char* usage = "Usage: erection [-d] [-f fps]\n"
        "try putting this in inetd.conf:\n\n"
        "telnet stream  tcp  nowait nobody  /usr/local/bin/erection  erection\n"
        "telnet stream  tcp6 nowait nobody  /usr/local/bin/erection  erection\n\n"
        "or run with -d to see it on stdin\n";
    if (write(1, usage, strlen(usage)) == -1);
    exit(2);
}

int main(int argc, char **argv)
{
    int ch;
    int fps = DEFAULT_FPS;
    int nosock = 1;
    while ((ch = getopt(argc, argv, "df:")) != -1) {
        switch (ch) {
        case 'd':
            nosock = 0;
            break;
        case 'f':
            fps = atoi(optarg);
            if (fps < 1 || fps > 500)
                usage();
            break;
        default:
            usage();
            break;
        }
    }

    if (nosock != 0) {
        struct sockaddr_storage addr;
        socklen_t socklen;

        if (getsockname(0, (struct sockaddr*) &addr, &socklen) == -1) {
            errdie("not a socket");
        }
    }

    for (int i = 0; i < sizeof(penis_frames)/sizeof(char*); i++) {
        if (write(0, penis_frames[i], strlen(penis_frames[i])) == -1)
            errdie("send");

        usleep((int)1000000/fps);
    }

    return 0;
}
