/**
 * @file config.c
 * @brief Provides the configuration of the iapws library.
 * 
 * 
 */
#include <stdio.h>
#include "config.h"

/**
 * @brief Prints the configuration for the iapws library.
 */
int main(int argc, char **argv){

    // avoid compiler complaining
    if (argc>1){
        printf("%d %s", argc, argv[1]);
    }
        
     printf("%s v.%s.\n%s\n", PROJECT_NAME, PROJECT_VERSION, PROJECT_DESCRIPTION);

     printf("prefix = %s\n", INSTALL_PREFIX);

     printf("libs = %s\n", LIBS);
     
     printf("cflags = %s\n", CFLAGS);

    return 0;
}
