package const
import "core:time"
//=========================================================//
// Author: Marshall A Burns aka @SchoolyB
//
// Copyright 2024 Marshall A Burns and Solitude Software Solutions LLC
// Licensed under Apache License 2.0 (see LICENSE file for details)
//=========================================================//

//PATH CONSTANTS
OST_FFVF :: "ost_file_format_version.tmp"
OST_TMP_PATH :: "../bin/tmp/"
OST_COLLECTION_PATH :: "../bin/collections/"
OST_SECURE_COLLECTION_PATH :: "../bin/secure/"
OST_CLUSTER_CACHE_PATH :: "../bin/cluster_id_cache"
OST_BACKUP_PATH :: "../bin/backups/"
OST_CONFIG_PATH :: "../bin/ostrich.config"
OST_BIN_PATH :: "../bin/"
OST_FILE_EXTENSION :: ".ost"
VERBOSE_HELP_FILE :: "./core/help/docs/verbose/verbose.md"
SIMPLE_HELP_FILE :: "./core/help/docs/simple/simple.md"
GENERAL_HELP_FILE :: "./core/help/docs/general/general.md"
ATOMS_HELP_FILE :: "./core/help/docs/atoms/atoms.txt"
OST_QUARANTINE_PATH :: "../bin/quarantine/"
//CONFIG FILE CONSTANTS
configOne :: "OST_ENGINE_INIT"
configTwo :: "OST_ENGINE_LOGGING"
configThree :: "OST_USER_LOGGED_IN"
configFour :: "OST_HELP"

//ATOM TOKEN CONSTANTS
VERSION :: "VERSION"
HELP :: "HELP" //help can also be a multi token command.
EXIT :: "EXIT"
LOGOUT :: "LOGOUT"
CLEAR :: "CLEAR"
TREE :: "TREE"
HISTORY :: "HISTORY"
//Action Tokens
NEW :: "NEW"
BACKUP :: "BACKUP"
ERASE :: "ERASE"
RENAME :: "RENAME"
FETCH :: "FETCH"
SET :: "SET"
FOCUS :: "FOCUS"
UNFOCUS :: "UNFOCUS"
//Target Tokens
COLLECTION :: "COLLECTION"
CLUSTER :: "CLUSTER"
RECORD :: "RECORD"
USER :: "USER"
ALL :: "ALL"
CONFIG :: "CONFIG" //special target exclusive to SET command
//Modifier Tokens
AND :: "AND"
OF_TYPE :: "OF_TYPE"
TYPE :: "TYPE"
ALL_OF :: "ALL_OF"
TO :: "TO"
//Scope Tokens
WITHIN :: "WITHIN"
IN :: "IN"
//Type Tokens
STRING :: "STRING"
STR :: "STR"
//------------
INTEGER :: "INTEGER"
INT :: "INT"
//------------
FLOAT :: "FLOAT"
FLT :: "FLT"
//------------
BOOLEAN :: "BOOLEAN"
BOOL :: "BOOL"
//SPECIAL HELP TOKENS
ATOMS :: "ATOMS"
ATOM :: "ATOM"
//INPUT CONFIRMATION CONSTANTS
YES :: "YES"
NO :: "NO"

//FOR DOT NOTATION
DOT :: "."

//MISC CONSTANTS
ost_carrot :: "OST>>>"
VALID_RECORD_TYPES: []string : {STRING, INTEGER, FLOAT, BOOLEAN, STR, INT, FLT, BOOL}
MAX_SESSION_TIME: time.Duration : 259200000000000000 //3 days in nanoseconds
MAX_COLLECTION_TO_DISPLAY :: 20 // for TREE command, max number of constants before prompting user to print
// MAX_SESSION_TIME: time.Duration : 60000000000 //1 minute in nano seconds only used for testing
MAX_FILE_SIZE: i64 : 10000000 //10MB max database file size
// MAX_FILE_SIZE_TEST: i64 : 10 //10 bytes max file size for testing

//NON CONSTANTS BUT GLOBAL
ConfigHeader := "#This file was generated by OstrichDB\n#Do NOT modify this file unless you know what you are doing\n#For more information on OstrichDB visit: https://github.com/Solitude-Software-Solutions/OstrichDB\n\n\n\n"
QuarantineStr: string = "\n# [QUARANTINED] [QUARANTINED] [QUARANTINED] [QUARANTINED]\n"

//if a user created an account with these names it would break the auth system. Might come back and look at this again.. - SchoolyB
BannedUserNames := []string {
	"admin",
	"user",
	"guest",
	"root",
	"system",
	"sys",
	"administrator",
	"superuser",
}
