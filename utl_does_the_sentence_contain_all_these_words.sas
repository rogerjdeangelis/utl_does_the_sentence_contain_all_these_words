Does the sentence contain all these words

StackOverlow
https://tinyurl.com/y8vrc9h3
https://stackoverflow.com/questions/21718345/python-how-to-determine-if-a-list-of-words-exist-in-a-string

Peter Gibson Profile
https://stackoverflow.com/users/66349/peter-gibson

Perhaps this type of problem is best solved by Perl or Python.
I suspect this solution would be very fast and can handle
very larg strings (only constrained by memory).

utl_sumit_py64 on the end


INPUT
=====

  %let words='E10', 'E11', 'E12';

  %let sentence=I own apparments E10 E11 and E12;


EXAMPLE OUTPUT
--------------

    Returns which required words are in the sentence

    %put &=fromPy;

    fromPy= E10E11E12


PROCESS
=======

%utl_submit_py64("

import pyperclip;

word_list = [&words];
a_string = '&sentence';

def words_in_string(word_list, a_string):;
.    return set(word_list).intersection(a_string.split());

s='';
for word in words_in_string(word_list, a_string):;
.    s += word;
print s;

pyperclip.copy(s);

",return=frompy);

%put &=fromPy;


OUTPUT
======

 fromPy= E10E11E12


*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

%let words='E10', 'E11', 'E12';
%let sentence=I own apparments E10 E11 and E12;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

see process

*      _   _               _               _ _                     __   _  _
 _   _| |_| |    ___ _   _| |__  _ __ ___ (_) |_      _ __  _   _ / /_ | || |
| | | | __| |   / __| | | | '_ \| '_ ` _ \| | __|    | '_ \| | | | '_ \| || |_
| |_| | |_| |   \__ \ |_| | |_) | | | | | | | |_     | |_) | |_| | (_) |__   _|
 \__,_|\__|_|___|___/\__,_|_.__/|_| |_| |_|_|\__|____| .__/ \__, |\___/   |_|
           |_____|                             |_____|_|    |___/
;


%macro utl_submit_py64(
      pgm
     ,return=  /* name for the macro variable from Python */
     )/des="Semi colon separated set of python commands - drop down to python";

  * write the program to a temporary file;
  filename py_pgm "%sysfunc(pathname(work))/py_pgm.py" lrecl=32766 recfm=v;
  data _null_;
    length pgm  $32755 cmd $1024;
    file py_pgm ;
    pgm=&pgm;
    semi=countc(pgm,';');
      do idx=1 to semi;
        cmd=cats(scan(pgm,idx,';'));
        if cmd=:'. ' then
           cmd=trim(substr(cmd,2));
         put cmd $char384.;
         putlog cmd $char384.;
      end;
  run;quit;
  %let _loc=%sysfunc(pathname(py_pgm));
  %put &_loc;
  filename rut pipe  "C:\Python_27_64bit/python.exe &_loc";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
  run;
  filename rut clear;
  filename py_pgm clear;

  * use the clipboard to create macro variable;
  %if "&return" ^= "" %then %do;
    filename clp clipbrd ;
    data _null_;
     length txt $200;
     infile clp;
     input;
     putlog "*******  " _infile_;
     call symputx("&return",_infile_,"G");
    run;quit;
  %end;

%mend utl_submit_py64;
