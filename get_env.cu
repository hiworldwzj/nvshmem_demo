#include <stdio.h>

int main(int argc, char *argv[]) {
    extern char **environ; // 声明外部变量 environ
    // 遍历并打印所有环境变量
    for (char **env = environ; *env != 0; env++) {
        printf("export %s\n", *env);
    };

    while(true) {
    };

    return 0;
}