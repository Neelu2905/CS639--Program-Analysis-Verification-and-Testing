Neelu Lalchandani 231110031
Here are some instructions for running file

Submission.py file is inside submission folder 

Take two program p1 and p2 , p1 with holes and p2 with no holes.
Create json file of both programs by running command in KachuaCore Folder. 

command for creating json file of program with no holes : 
     python kachua.py -t 100 -se example/eqtest1.tl -d{'X':10,':y':20}

Command for creating json files of program with no holes :
    python kachua.py -t 100 -se example/eqtest1.tl -d{'X':10,':y':20} -c{':c1':1,':c2':1}

Command for creating kw file.
     python kachua.py -O example/eqtest1.tl

provide constant parameters in the form of c1,c2,c3,c4... format.

After creating json files of programs run given command
    python ../submission/symbSubmission.py -b eqtest1.kw -e{':x',':y'}

This command will run submision.py file and provide values of constant parameter at which programs will give same output.