# Assignment 1

### Alexander Rinsche 12120519

Contents
---
- [[report.md]] - This report
- [[Makefile]] - Some shortcuts for submitting jobs to the Virtual PunchcardReader and FTP
- [[dataset.jcl]] - A job to create a dataset for this assignment
- [[job.jcl]] - A helper job for quick incremental development. 
- [[codeoutput.txt]] - The contents of printer of MSGCLASS A after flushing it and running job.jcl afterwards
- [[joboutput.txt]] - The contents of printer of MSGCLASS X after flushing it and running job.jcl afterwards
- [[fibonacci.pl1]] - The pl1 source code
- [[fibonacci.jcl]] - A jcl job to run the pl1 code using the dataset `HERC03.FIBONACI` (created by dataset.jcl)


Datasets
---
`HERC03.FIBONACI` is created by the job `dataset.jcl` and contains the following members:
- (PL1): The pl1 code from [[fibonacci.pl1]]
- (JCL): The jcl code from [[fibonacci.jcl]]


Code Explanation
---
My program uses PL1 to print the fibonacci sequence as defined in the assignment to SYSPRINT, which is then redirected to MSGCLASS A.
### job.jcl
This was a minimal setup that contains the source code from fibonacci.pl1 and the same logic for submission as A1, so I won't go into detail here.
It runs the program with params:
`PARM.GO='I0=0 I1=0 MIN=-1 MAX=12;'`

### dataset.jcl
dataset.jcl creates a partitioned dataset for this exercise. Important note: VOL=SER=TSO003 is particularly important, because otherwise the dataset won't be accessible via ftp.

### fibonacci.jcl
This file submits a job that compiles the (hopefully already existing) dataset `HERC03.FIBONACI(PL1)` using the program "PL1LFCLG" and runs it with the parameters
`PARM.GO='I0=-2 I1=-1 MIN=-42 MAX=-76;'`

### fibonacci.pl1
The program just calculates fibonacci numbers until I0 exceeds MAX. There are several conditions to cover all cases
- if I0 is larger than MIN, the output gets printed
- if the sequence is negative, MIN and MAX are swapped and SIGNED = -1, which mimics a kinda scuffed abs() function
- if I0 and I1 are 0, Max is instantly set to 0, but before that, if MIN < 0 < MAX, 0 is printed and counted as a number.



STEPS
---

### Development
For quick iterations, I used `job.jcl` to quickly get a running program.
After that, I created a new dataset using `dataset.jcl`, followed by pushing the pl1 code and a jcl job to the dataset using FTP.


### Run the code
There are two ways to run the code, the first is identical to A1:
run `make job` in this folder. This uses the virtual punchcard reader to submit [[./job.jcl]] to hercules.

The more elaborate method is to first create a datset by running `make ds` or submitting the job from [[dataset.jcl]] to the emulator.
Next you have to start the FTP client by running `/s ftpd` in the main hercules console. After doing so you can connect to the mainframe via FTP using `make ftp`, if you have `lftp` installed, or by your method of choice using the endpoint exposed on `localhost:2121`, with `HERC01/CUL8TR` as your user and password.

After doing so you can navigate to the dataset `HERC03.FIBONACI` (this is not a typo, I had the choice between "FIBONACC" or "FIBONACI" and chose the one that seemed closer, due to the limitations to 8 char for a ds-name) and then add the files fibonacci.pl1 and fibonacci.jcl (in lftp this would be `put -a fibonacci.pl1 PL1` and jcl/JCL respectively). **Important**: Set the transmission to ASCII, because the mainframe uses EBCDIC encoding as a default, which might make your files look _weird_ to say the least.


Finally, within the mainframe, you can submit the job by navigating to 3.4 RFE DSLIST and typing "HERC03.FIBONACI", pressing enter, entering "E" (for edit) in the "S" column,then again but pay attention that you do that for the dataset member "JCL". Now you can type submit in the command line to submit the job.




After either way you can view the results in the Outlist (3.8), as usual.

### Printing
To print the job, write `o` int the first column next to the job to print it.
Before doing so, it's a good idea to flush the two printers. To do so, navigate to the main hercules console (located in the terminal where you ran `setup.sh`), press `ESC` followed by `N` and the letter in the column of the printer you want to clear.
We want to clear the printers pointing to the files `prt002.txt` and `prt00e.txt`. After selecting them just press enter to reset them using the same name.
Now press `ESC` again and write `/$s prt3` to flush the printers (after writing `o` as said previously)

The results are then located in `mvs-tk5/prt` - The output from the code (containing `HELLO WORLD`) is in `prt002.txt` and the general job output is in `prt00e.txt`.



Known issues
---
For some reason the job step responsible for compilation returns with RC=0008, which, according to a pl1 compiler [handbook](https://bitsavers.org/pdf/ibm/370/pli/SC26-3113-01_PLI_for_MVS_and_VM_Release_1.1_Programming_Guide_199506.pdf), p.45, means 
> Error detected; compilation completed; successful execution probable.
~ le Handbook

So apparently its a slightly more severe warning, which I chose to ignore since the program seemed to work otherwise.
