#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

extern "C" const char* read_message(const char* message){
   string msg;
   ifstream myfile(message);
   if(myfile.is_open()){
      getline(myfile, msg);
      return msg.c_str();
   }
   else
     cout << "unable to open file";
}


