The test cases and their outputs are present in 'tests' folder of KachuaCore.
To run any test case, go in the directory KachuaCore and simply write this in command prompt:
python kachua.py -t 100 --fuzz tests/test1.tl -d{':x':42,':y':-100,':z':68,':w':-77,':a':88}