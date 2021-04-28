#include <time.h>
#include <string.h>
#include <stdlib.h>
#include "datetime.h"

/*
 * input: format: YYYYmmddHHMMSS           example: 20210415215844 
 * output format: YYYY-mm-dd HH:MM:SS UTC  example: 2021-04-15 21:58:44 UTC 
 * return PARSER_COMPILED_DATETIME_SUCCESS
 *        PARSER_COMPILED_DATETIME_ERROR
 */
int parse_compiled_datetime(char* input, char output[24]) {
    if (14 != strlen(input)) {
        return PARSER_COMPILED_DATETIME_ERROR;
    }

    char* p = input;
    
    char str_year[5] = {0};
    strncpy(str_year, p, 4);
    p += 4;

    char str_month[3] = {0};
    strncpy(str_month, p, 2);
    p += 2;

    char str_day[3] = {0};
    strncpy(str_day, p, 2);
    p += 2;

    char str_hour[3] = {0};
    strncpy(str_hour, p, 2);
    p += 2;

    char str_minutes[3] = {0};
    strncpy(str_minutes, p, 2);
    p += 2;

    char str_seconds[3] = {0};
    strncpy(str_seconds, p, 2);

    struct tm input_tm = {
        .tm_year = atoi(str_year) - 1900,
        .tm_mon  = atoi(str_month) - 1,
        .tm_mday = atoi(str_day),
        .tm_hour = atoi(str_hour),
        .tm_min  = atoi(str_minutes),
        .tm_sec  = atoi(str_seconds)
    };

    strftime(output, 24, "%Y-%m-%d %H:%M:%S UTC", &input_tm);

    return PARSER_COMPILED_DATETIME_SUCCESS;
}
