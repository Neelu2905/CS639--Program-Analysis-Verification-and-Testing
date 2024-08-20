from z3 import *
import argparse
import json
import sys

sys.path.insert(0, '../KachuaCore/')

from sExecutionInterface import *
import z3solver as zs
from irgen import *
from interpreter import *
import ast

def example(s):
    # To add symbolic variable x to solver
    s.addSymbVar('x')
    s.addSymbVar('y')
    # To add constraint in form of string
    s.addConstraint('Implies(x==5+y,x==5)')
    s.addConstraint('And(x==y,x>5)')
    # s.addConstraint('Implies(x==4,y==x+8')
    # To access solvers directly use s.s.<function of z3>()
    print("constraints added till now",s.s.assertions())
    # To assign z=x+y
    s.addAssignment('z','x+y')
    #print(s.assignSymbolicEncoding('z'))
    # To get any variable assigned
    print("variable assignment of z =",s.getVar('z'))

def checkEq(args,ir):
    
    #Load files
    file1 = open("../Submission/testData.json","r+")
    testData=json.loads(file1.read())
    file1.close()

    file2 = open("../Submission/testData1.json","r+")
    testData1=json.loads(file2.read())
    file2.close()

    #convert variables to z3 variables using Int

    w = Int('w')
    x = Int('x')
    y = Int('y')
    z = Int('z')
    p = Int('p')
    q = Int('q')
    r = Int('r')
    s = Int('s')
    t = Int('t')
    u = Int('u')
    v = Int('v')
    k = Int('k')
    c1 = Int('c1')
    c2 = Int('c2')
    c3 = Int('c3')
    c4 = Int('c4')
    c5 = Int('c5')
    c6 = Int('c6')
    c7 = Int('c7')
    
    #for testData.json (program with holes)
    #get constraints and output equations from this json file

    constraints={}
    symbEnc2={}

    for key, value in testData.items():
        constraints[key] = eval(str(value.get("constraints")))

    for key, value in testData.items():
        symbEnc2[key] = eval(str(value.get("symbEnc")))

    constraint = []
    for i in constraints:
        constraint.append(eval(str(constraints[i])))

    #put all equations in a list
    temp = []

    # Create temp based on symbEnc2
    for i in symbEnc2:
        inner_list = []
        for j in symbEnc2[i]:
            inner_list.append("==" + symbEnc2[i][j])
        temp.append(inner_list)

    #for testData1.json (program with no holes)
    #fetch all the variables in program from params and all the equations from symbEnc, and store them in input and output lists

    params= {}
    symbEnc1={}

    for key, value in testData1.items():
        params[key] = eval(str(value.get("params")))

    for key, value in testData1.items():
        symbEnc1[key] = eval(str(value.get("symbEnc")))

    input=[]
    for var in params:
        input.append(params[var])
    
    output=[]
    for var in symbEnc1:
        output.append(symbEnc1[var])
    
    #converting input and output lists to z3 compatible form
    input_equations=[]
    for i in input:
        list=[]
        for j ,k in i.items():
            list.append(eval(str(j + "=="+str(k) )))
        input_equations.append(list)

    output_equations=[]
    l1 = min(len(output) , len(temp))
    l2 = l1
    for i in output:
        if l1!=0:
            list=[]
            for j ,k in i.items():
                list.append(eval(str(j + "=="+str(k) )))
            output_equations.append(list)
        l1 = l1 - 1
    
    equations = []

    # Create equations based on output and temp
    for n, k in enumerate(output):
        if (l2!=0):
            inner_list = []
            m = 0
            for key in k:
                inner_list.append(eval(str(k[key] + temp[n][m])))
                m += 1
            equations.append(inner_list)
        l2 = l2 - 1


    #Create two solvers, s1 checks if the input equations satisfy the constraints or not. If they do, pass the symbolic encoding equivalence of P1 and P2 into s2
    s1 = Solver()
    s2 = Solver()

    for i in range(0, min(len(output) , len(temp))):
        s1.reset()
        
        # Add input equations to s1 solver
        for j in input_equations[i]:
            s1.add(j)
        
        # Add constraints to s1 solver
        for k in range(len(constraint[i])):
            s1.add(eval(str(constraint[i][k])))

        # Check satisfiability of s1
        if s1.check() == sat:
            for k in equations[i]:
                s2.add(k)

    # Check satisfiability of s2
    if s2.check() == sat:
        print(s2.model())
    else:
        print('Not satisfied')

if __name__ == '__main__':
    cmdparser = argparse.ArgumentParser(
        description='symbSubmission for assignment Program Synthesis using Symbolic Execution')
    cmdparser.add_argument('progfl')
    cmdparser.add_argument(
        '-b', '--bin', action='store_true', help='load binary IR')
    cmdparser.add_argument(
        '-e', '--output', default=list(), type=ast.literal_eval,
                               help="pass variables to kachua program in python dictionary format")
    args = cmdparser.parse_args()
    ir = loadIR(args.progfl)
    checkEq(args,ir)
    exit()
