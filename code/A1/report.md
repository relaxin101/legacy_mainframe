# Assignment 1

### Alexander Rinsche 12120519

Contents
---
- [[report.md]] - This report
- [[Makefile]] - Some useful for the Virtual PunchcardReader and FTP
- [[job.jcl]] - The entire source code. JCL and inlined PL1 code
- [[codeoutput]] - The contents of printer of MSGCLASS A after flushing it and running job.jcl afterwards
- [[joboutput]] - The contents of printer of MSGCLASS X after flushing it and running job.jcl afterwards
- [[dataset.jcl]] - Added in hopes of full marks :P


Datasets (changed!)
---
Although not necessary for this program, an important and highly nontrivial aspect of working on a mainframe is File creation, or as the oldtimers like to call it *Dataset Allocation*.

For this I created the JCL job `dataset.jcl` that creates a standard fixed-block Dataset with 80 character long lines.
A more detailed rundown of the code and the options:
```jcl
//HERC03DD JOB (HERC03),'CREATE DS',
//             CLASS=A,MSGCLASS=X,
//             REGION=8M,TIME=1440,
//             NOTIFY=HERC03,MSGLEVEL=(1,1),
//             USER=HERC03,PASSWORD=PASS4U
```
Contains the standard job header, as for the other code
```
//*              
//CREATEDS  EXEC PGM=IEFBR14
```
Runs the `return 0` program of the mainframe, which, naturally, is called `IEFBR14`.
```

//TESTDS    DD DSN=HERC03.PAIN.PL1,DISP=(NEW,CATLG,DELETE),   
//          DCB=(DSORG=PO,RECFM=FB,LRECL=80,BLKSIZE=1600),       
//          SPACE=(TRK,(1,10,2),RLSE),VOL=SER=TSO003,UNIT=SYSDA  
```
This block tells JCL which datasets to use for the previous job step.
- DSN stands for "Dataset Name"
- The `DISP` block is used to indicate that a new Dataset is created, CATALG means save it to some sort of index and DELETE means delete if the job  should fail.
- The `DCB` block contains information about the structure, DSORG is set to PO, which indicates a partitioned dataset (basically a folder), RECFM is set to fixed-block, Logical Record Length is set to 80 (both necessary for PL1 code), and the blocksize is set to 1600 (honestly I forgot what this does exactly, i just know it has to be a multiple of 80 and that it does not correspond with the number of lines, because I can have more than 20 lines)
- Finally, `SPACE` describes the location where the dataset is saved. We always use Tracks (TRK), as Cylinders are unnecessary large, TSO003 indicates it can be accessed via FTP (this is foreshadowing, I will avoid using the hercules editor as much as humanely possible), and SYSDA is a generic setting for memory that supports direct access. Not to be confused with storage devices that do not support access.

I adjusted my makefile so `make ds` creates the dataset, which I can verify when checking the job output under '3.8' or when looking for the Dataset Name under '3.4'.

Explanation
---
My program uses PL1 to print `HELLO WORLD` to SYSPRINT, which is then redirected to MSGCLASS A.

STEPS
---
### Setup and start mvs-tk5. 
For me this was especially challenging because MacOS seems to hold a certain grudge against this particular technology. To automate setup and tear-down of the simulation I created this script:
```bash
rm -rf mvs-tk5
unzip mvs-tk5.zip
cd mvs-tk5
cp ../mvs_ipl .
chmod +x mvs_* unattended/set* hercules/darwin/bin/* hercules/darwin/lib/* hercules/darwin/lib/hercules/*
xattr -d com.apple.quarantine mvs_* unattended/set* hercules/darwin/bin/* hercules/darwin/lib/* hercules/darwin/lib/hercules/*
cd unattended
./set_console_mode
cd ..
./mvs_osx
```
In the folder with this script I had a fresh download of MVS-tk5 from [Prince Webdesign](https://www.prince-webdesign.nl/index.php/software/mvs-3-8j-turnkey-5) and the updated `mvs_ipl` from TUWEL.

> [!Bug] Makefile
> Running this script as a makefile is not a good idea - I got weird issues with coproc not being found and several "unverified developer" issues 

### Run the job
To do so, run `make job` in this folder. This uses the virtual punchcard reader to submit [[./job.jcl]] to hercules.

### Log in to hercules and checking the job output
After installing `brew install c3270` and starting `c3270`, I logged in to hercules with `connect localhost:3270` and authenticating using `herc03/pass4u` (the login is case insensitive which I find ludicrous).
Next, I navigated to the job log in submenu `3.8`. At the very bottom there should be a Job labeled `HERC03A1`. 

### Printing
To print the job, write `o` int the first column next to the job to print it.
Before doing so, it's a good idea to flush the two printers. To do so, navigate to the main hercules console (located in the terminal where you ran `setup.sh`), press `ESC` followed by `N` and the letter in the column of the printer you want to clear.
We want to clear the printers pointing to the files `prt002.txt` and `prt00e.txt`. After selecting them just press enter to reset them using the same name.
Now press `ESC` again and write `/$s prt3` to flush the printers (after writing `o` as said previously)

The results are then located in `mvs-tk5/prt` - The output from the code (containing `HELLO WORLD`) is in `prt002.txt` and the general job output is in `prt00e.txt`.





