#ifndef PARSE_COMPILED_DATETIME_H
#define PARSE_COMPILED_DATETIME_H

#define PARSER_COMPILED_DATETIME_SUCCESS 0
#define PARSER_COMPILED_DATETIME_ERROR   1

/*
 * input: format: YYYYmmddHHMMSS           example: 20210415215844
 * output format: YYYY-mm-dd HH:MM:SS UTC  example: 2021-04-15 21:58:44 UTC
 * return PARSER_COMPILED_DATETIME_SUCCESS 
 *        PARSER_COMPILED_DATETIME_ERROR
 */
int parse_compiled_datetime(char* input, char output[24]);

#endif
