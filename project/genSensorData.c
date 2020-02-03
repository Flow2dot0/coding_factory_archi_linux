#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <signal.h>
#include <ctype.h>


int main(int argc, char* argv[]) {
    // welcome msg
    printf("Bonjour\n");
    fflush(stdout);

    // Initialize char
    char a;
    char b;
    // buffers
    char buffE[256];
    char buffK[256];
    // names placeholder
    char* sensorNames[] = {"thermometer1", "thermometer2", "thermometer3"};
    // Loop for read
    while(read(0, &a, 1) == 1) {
        // restrict to only alphabets
        if (isalpha(a) == 0){
            continue;
        }
        // rand id
        int sensorId = rand();
        // case OK
        if(a == 'K') {
            // get rand name
            // placeholders
            char* sensorName = sensorNames[rand()%(2-0 + 1)];
            int value = rand()%(50-0 + 1);
            int minValue = rand()%(50-0 + 1);
            int meanValue = rand()%(50-0 + 1);
            int maxValue = rand()%(50-0 + 1);
            // using the buffer to dispatch values
            sprintf(buffK, "%d:%s:%d:%d:%d:%d\n", sensorId, sensorName, value, minValue, meanValue, maxValue);
            // write on stdout
            write(1, buffK, strlen(buffK));
        // case ERROR
        }else if (a == 'E'){
            // placeholders
            int errorCode = rand()%(1000-0 + 1);
            // using the buffer to dispatch values
            sprintf(buffE, "%d:%d:error occurred\n", sensorId, errorCode);
            // write on stderr
            write(2, buffE, strlen(buffE));
        } 
        fflush(stdout);
    }

    return 0;
}

