#include <stdio.h>
#include <assert.h>
#include <dlfcn.h>
#include <unistd.h>
#include <sys/stat.h>
#include <stdint.h>


int main()
{
    char buf[255];
    int c = 0;
    int rc;
    struct stat st;
    int (*getX)();
    int64_t lastChanged;
    sprintf(buf, "lib%d.dylib", c);
    void *handle = dlopen(buf, RTLD_LAZY);
    assert(handle);
    rc = stat(buf, &st);
    assert(!rc);
    lastChanged = st.st_mtime;
    sprintf(buf, "lib%d.dylib", ++c);

    getX = dlsym(handle, "getX");
    while (1) {
        printf("x is %d\n", getX());
        sleep(1);
        rc = stat(buf, &st);
        if (rc == 0 && st.st_mtime > lastChanged) {
            printf("load %s\n", buf);
            lastChanged = st.st_mtime;
            rc = dlclose(handle);
            assert(!rc);
            handle = dlopen(buf, RTLD_LAZY);
            assert(handle);
            getX = dlsym(handle, "getX");
            sprintf(buf, "lib%d.dylib", ++c);
        }
    }

    return 0;
}

