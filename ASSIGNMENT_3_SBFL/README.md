Here are some instruction for running sbfl.Submission.py file

1. sbflSubmission.py file is inside Submission folder.

2. Open command promt or terminal inside ChironCore folder and write following command ,

 command - python chiron.py --SBFL ./tests/<example>.tl --buggy ./tests/<example>_buggy.tl -vars [':x',':y',':z'] --timeout 10 --ntests 20 --popsize 100 --cxpb 1.0 --mutpb 1.0 --ngen 100 --verbose True

3. 5 test cases are given inside tests folder inside ChironCore folder , with outputs

4. Output for each test case is ranklist of <example>_buggy.tl file which is generating inside <example>_buggy_componentranks.csv file 

5. 5 testcases ( examples ) are given 
    1. sbfl1.tl 
      sbfl1_buggy.tl
    this test case takes :x,:y and :z as input.

    2. sbfl2.tl 
      sbfl2_buggy.tl
    this test case takes :x,:y and :z as input.

    3. sbfl3.tl 
     sbfl3_buggy.tl
    this test case takes :x,:y, and :z as input.

    4. sbfl4.tl 
     sbfl4_buggy.tl
    this test case takes :x,:y, and :z as input.

    5. sbfl5.tl 
     sbfl5_buggy.tl    
    this test case takes :x,:y, and :z as input.