/*
general idea:
  handle version and name stuff
*/

final String _PROGRAM_TITLE_ = "Trasker";//what are we calling ourselves?
final String _PROGRAMVERSION_TITLE_ = "PRE_ALPHA V0.0.0";//what version do we display
//_PROGRAMVERSION_FILE_ range is 0-255
//used to figure out what version of our program the task file came from
final byte[] _PROGRAMVERSION_FILE_ = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};//<- = pre-alpha


final int _FILEVERSION_SETTINGS_ = 0;//what version of settings file
final int _FILEVERSION_TASKS_ = 0;//what version of tasks file