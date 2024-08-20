import copy
import math
import sys
import json
from xmlrpc.client import MAXINT, MININT
from typing import overload
from collections import namedtuple


sys.path.insert(0, "../ChironCore/")

import cfg.ChironCFG as cfgK
import cfg.cfgBuilder as cfgB
from lattice import  *
import ChironAST.ChironAST as ChironAST
import abstractInterpretation as AI

'''
    Class for interval domain
'''
INPUT_VAR_RANGE = [-1000,1000]
# ALG_POINT_1 = [-800,20]
# ALG_POINT_2 = [-400,50]
INI_X = [-300,300]
INI_Y = [-300,300]
# INI_X = [0,0]
# INI_Y = [0,0]
DIRECTION = ['+x', '-x' , '+y' , '-y']

# range = [-500,500]
# dir = ['right','left','top','bottom']

class IntervalDomain(Lattice):

    '''Initialize abstract value'''
    def __init__(self, data):
        pass

    '''To display abstract values'''
    def __str__(self):
        pass

    '''To check whether abstract value is bot or not'''
    def isBot(self):
        pass

    '''To check whether abstract value is Top or not'''
    def isTop(self):
        pass

    '''Implement the meet operator'''
    def meet(self, other):
        pass

    '''Implement the join operator'''
    def join(self, other):
        pass

    '''partial order with the other abstract value'''
    def __le__(self, other):
        pass

    '''equality check with other abstract value'''
    def __eq__(self, other):
        pass

    '''
        Add here required abstract transformers
    '''
    pass

assgn_dict = {}
def operator_range(var , op, val):
        if(var in list(assgn_dict.keys())):
            value1 = assgn_dict[var]
        value2 = int(val)
        if(op == '<'):
            true_range = {'left' : MININT , 'right' :value2-1}
            false_range = {'left' : value2 , 'right' : MAXINT}
        if(op == '>'):
            true_range = {'left' : value2+1 , 'right' :MAXINT}
            false_range = {'left' : MININT , 'right' : value2}
        if(op == '<='):
            true_range = {'left' : MININT , 'right' :value2}
            false_range = {'left' : value2+1 , 'right' : MAXINT}
        if(op == '>='):
            true_range = {'left' : value2 , 'right' : MAXINT}
            false_range = {'left' : MININT , 'right' : value2-1}
        if(op == '=='):
            true_range = {'left' : value2 , 'right' :value2}
            false_range = {'left' : MININT , 'right' : MAXINT , 'except' : value2}
        final_true_range = {'left' : max(true_range['left'],value1['left']) , 'right' : min(true_range['right'] , value1['right'])}    
        final_false_range = {'left' : max(false_range['left'],value1['left']) , 'right' : min(false_range['right'] , value1['right'])}    
        return [final_true_range,final_false_range]   

def area(a, b):  
    dx = min(a.xmax, b.xmax) - max(a.xmin, b.xmin)
    dy = min(a.ymax, b.ymax) - max(a.ymin, b.ymin)
    if (dx>=0) and (dy>=0):
        return dx*dy    
    
class IntervalTransferFunction(TransferFunction):
    def __init__(self):
        pass

    def transferFunction(self, currBBIN, currBB):
        #implement your transfer function here
        current_out = copy.deepcopy(currBBIN)
        if(currBB.__str__() != 'END'):
            if(type(currBB.instrlist[0][0]) == ChironAST.MoveCommand):
                flag = 0
                list = str.split(str(currBB.instrlist[0][0]))
                if(type(currBB.instrlist[0][0].expr) == ChironAST.Num):
                    mov = {'left' : int(currBB.instrlist[0][0].expr.__str__()),'right' : int(currBB.instrlist[0][0].expr.__str__())}

                elif(str(currBB.instrlist[0][0].expr) in assgn_dict.keys()):
                    mov = assgn_dict[list[1]]
                else:
                    assgn_dict[str(currBB.instrlist[0][0].expr)] = {'left' : INPUT_VAR_RANGE[0], 'right' : INPUT_VAR_RANGE[1]}
                    mov = (assgn_dict[list[1]])

                if(list[0] == "left"):
                    if(currBBIN['IN']['D'] == '+x'):
                        current_out['IN']['D'] = '+y'
                    elif(currBBIN['IN']['D'] == '-x'):
                        current_out['IN']['D'] = '-y'
                    elif(currBBIN['IN']['D'] == '+y'):
                        current_out['IN']['D'] = '-x'
                    elif(currBBIN['IN']['D'] == '-y'):
                        current_out['IN']['D'] = '+x'
                if(list[0] == "right"):
                    if(currBBIN['IN']['D'] == '+x'):
                        current_out['IN']['D'] = '-y'
                    elif(currBBIN['IN']['D'] == '-x'):
                        current_out['IN']['D'] = '+y'
                    elif(currBBIN['IN']['D'] == '+y'):
                        current_out['IN']['D'] = '+x'
                    elif(currBBIN['IN']['D'] == '-y'):
                        current_out['IN']['D'] = '-x'
                if(flag == 0):
                    if(list[0] == "forward"):
                        if(currBBIN['IN']['D'] == '+x'):
                            if(int(mov['left']) + currBBIN['IN']['X']['left'] < currBBIN['IN']['X']['left']):
                                current_out['IN']['X']['left'] = int(mov['left']) + currBBIN['IN']['X']['left']
                            if(int(mov['right']) + currBBIN['IN']['X']['right'] > currBBIN['IN']['X']['right']):
                                current_out['IN']['X']['right'] = int(mov['right']) + currBBIN['IN']['X']['right'] 
                        if(currBBIN['IN']['D'] == '-x'):
                            if(-1*int(mov['left']) + currBBIN['IN']['X']['left'] < currBBIN['IN']['X']['left']):
                                current_out['IN']['X']['left'] = -1*int(mov['left']) + currBBIN['IN']['X']['left']
                            if(-1*int(mov['right']) + currBBIN['IN']['X']['right'] > currBBIN['IN']['X']['right']):
                                current_out['IN']['X']['right'] = -1*int(mov['right']) + currBBIN['IN']['X']['right']
                        if(currBBIN['IN']['D'] == '+y'):
                            if(int(mov['left']) + currBBIN['IN']['Y']['left'] < currBBIN['IN']['Y']['left']):
                                current_out['IN']['Y']['left'] = int(mov['left']) + currBBIN['IN']['Y']['left']
                            if(int(mov['right']) + currBBIN['IN']['Y']['right'] > currBBIN['IN']['Y']['right']):
                                current_out['IN']['Y']['right'] = int(mov['right']) + currBBIN['IN']['Y']['right'] 
                        if(currBBIN['IN']['D'] == '-y'):
                            if(-1*int(mov['left']) + currBBIN['IN']['Y']['left'] < currBBIN['IN']['Y']['left']):
                                current_out['IN']['Y']['left'] = -1*int(mov['left']) + currBBIN['IN']['Y']['left']
                            if(-1*int(mov['right']) + currBBIN['IN']['Y']['right'] > currBBIN['IN']['Y']['right']):
                                current_out['IN']['Y']['right'] = -1*int(mov['right']) + currBBIN['IN']['Y']['right'] 

                         

                    if(list[0] == "backward"):
                        if(currBBIN['IN']['D'] == '-x'):
                            if(int(mov['left']) + currBBIN['IN']['X']['left'] < currBBIN['IN']['X']['left']):
                                current_out['IN']['X']['left'] = int(mov['left']) + currBBIN['IN']['X']['left']
                            if(int(mov['right']) + currBBIN['IN']['X']['right'] > currBBIN['IN']['X']['right']):
                                current_out['IN']['X']['right'] = int(mov['right']) + currBBIN['IN']['X']['right'] 
                        if(currBBIN['IN']['D'] == '+x'):
                            if(-1*int(mov['left']) + currBBIN['IN']['X']['left'] < currBBIN['IN']['X']['left']):
                                current_out['IN']['X']['left'] = -1*int(mov['left']) + currBBIN['IN']['X']['left']
                            if(-1*int(mov['right']) + currBBIN['IN']['X']['right'] > currBBIN['IN']['X']['right']):
                                current_out['IN']['X']['right'] = -1*int(mov['right']) + currBBIN['IN']['X']['right']
                        if(currBBIN['IN']['D'] == '-y'):
                            if(int(mov['left']) + currBBIN['IN']['Y']['left'] < currBBIN['IN']['Y']['left']):
                                current_out['IN']['Y']['left'] = int(mov['left']) + currBBIN['IN']['Y']['left']
                            if(int(mov['right']) + currBBIN['IN']['Y']['right'] > currBBIN['IN']['Y']['right']):
                                current_out['IN']['Y']['right'] = int(mov['right']) + currBBIN['IN']['Y']['right'] 
                        if(currBBIN['IN']['D'] == '+y'):
                            if(-1*int(mov['left']) + currBBIN['IN']['Y']['left'] < currBBIN['IN']['Y']['left']):
                                current_out['IN']['Y']['left'] = -1*int(mov['left']) + currBBIN['IN']['Y']['left']
                            if(-1*int(mov['right']) + currBBIN['IN']['Y']['right'] > currBBIN['IN']['Y']['right']):
                                current_out['IN']['Y']['right'] = -1*int(mov['right']) + currBBIN['IN']['Y']['right'] 

            
            elif(type(currBB.instrlist[0][0]) == ChironAST.ConditionCommand):
                if(str(currBB.instrlist[0][0]) != 'False'):
                    l = len(currBB.instrlist[0][0].__str__())
                    var,op,val = str.split(currBB.instrlist[0][0].__str__()[1:l-1])
                    [true_range,false_range] = operator_range(var,op,val)
                    current_out1 = copy.deepcopy(current_out)
                    current_out2 = copy.deepcopy(current_out)
                    current_out1['IN'][var] = {'left' : true_range['left'] , 'right' : true_range['right']} 
                    current_out2['IN'][var] = {'left' : false_range['left'] , 'right' : false_range['right']} 
                    outVal = [{'OUT' : current_out1['IN']},{'OUT' : current_out2['IN']}]
                    return outVal
                else:
                    outVal = [{'OUT' : current_out['IN']},{'OUT' : current_out['IN']}]
                    return outVal
        outVal = [{'OUT' : current_out['IN']}]
        return outVal

class ForwardAnalysis():
    def __init__(self):
        self.transferFunctionInstance = IntervalTransferFunction()
        self.type = "IntervalTF"

    '''
        This function is to initialize in of the basic block currBB
        Returns a dictinary {varName -> abstractValues}
        isStartNode is a flag for stating whether currBB is start basic block or not
    '''
    def initialize(self, currBB, isStartNode):
        val = {}
        #Your additional initialisation code if any
        if(isStartNode):
            val = { 'IN' : {'X' : {'left' : INI_X[0] , 'right' : INI_X[1]} , 'Y' : {'left' : INI_Y[0] , 'right' : INI_Y[1]} , 'D' : DIRECTION[0] , 'is_bot' : False}}
        #Your 
        return val

    #just a dummy equallity check function for dictionary
    def isEqual(self, dA, dB):
        for i in dA.keys():
            if i not in dB.keys():
                return False
            if dA[i] != dB[i]:
                return False
        return True

    '''
        Define the meet operation
        Returns a dictinary {varName -> abstractValues}
    '''
    def meet(self, predList):
        assert isinstance(predList, list)
        final_x_left = []
        final_x_right = []
        final_y_left = []
        final_y_right = []
        dir = []
        is_bot = False
        for i in predList:
            final_x_left.append(i['OUT']['X']['left'] )
            final_x_right.append(i['OUT']['X']['right'] )
            final_y_left.append(i['OUT']['Y']['left'] )
            final_y_right.append(i['OUT']['Y']['right'] )
            for v in i['OUT'].keys():
                if(v not in ['D', 'is_bot','X','Y']):
                    if(int(i['OUT'][v]['left']) > int(i['OUT'][v]['right'])):
                        is_bot = True
            if(i['OUT']['is_bot'] == True and len(predList) == 1):
                is_bot = True
        count = 0
        list_is_bot = []
        for i in predList:
            list_is_bot.append(i['OUT']['is_bot'])
            if(i['OUT']['is_bot'] == False):
                not_bot_pred = count
                dir.append(i['OUT']['D'])
            count +=1
        if(len(list_is_bot) == 1):
            meetVal = {'IN' : predList[0]['OUT']}
            meetVal['IN']['is_bot'] = is_bot
        else:
            if(len(set(list_is_bot)) == 2):
                meetVal = {'IN' : predList[not_bot_pred]['OUT']}
                meetVal['IN']['is_bot'] = False
            elif(len(set(list_is_bot)) == 1 and list_is_bot[0] == False):
                if(len(set(dir)) == 1):
                    fin_dir = dir[0]
                else:
                    print("\n\"KACHUA IS UNSAFE\" :: SINCE AT MEET DIRECTIONS OF BOTH THE PATHS ARE DIFFERENT")
                    sys.exit()
                meetVal = { 'IN' : {'X' : {'left' : min(final_x_left) , 'right' : max(final_x_right)} , 'Y' : {'left' : min(final_y_left) , 'right' : max(final_y_right)} , 'D' : fin_dir, 'is_bot': is_bot}}
        return meetVal

def analyzeUsingAI(irHandler):
    '''
        get the cfg outof IR
        each basic block consists of single statement
    '''
    ir = (irHandler.ir)
    cfg = cfgB.buildCFG(ir, "cfg", True)

    print("crfg :",cfg)

    cfgB.dumpCFG(cfg, "x")

    file = open("../ChironCore/tests/test_4.json","r+")
    d = json.loads(file.read())
    # print("cfg ",cfg)
    # print("filename : ",d)

    ALG_POINT_1 = d['reg'][0]
    ALG_POINT_2 = d['reg'][1]
    
    for i in ir:
        if('__rep_counter_1' in str(i[0])):
            print("\n\"KACHUA IS UNSAFE\" :: KACHUA CAN BE INSIDE MAGARMACH'S REGION GIVEN")
            sys.exit()
        if(type(i[0]) == ChironAST.AssignmentCommand):
            if(':' in (i[0].rexpr.__str__())):
                print("\n\"KACHUA IS UNSAFE\" :: KACHUA CAN BE INSIDE MAGARMACH'S REGION GIVEN")
                sys.exit()
            assgn_dict[i[0].lvar.__str__()] = {'left' : int(i[0].rexpr.__str__()), 'right' : int(i[0].rexpr.__str__())}

    #print("nothing ")
    # call worklist and get the in/out values of each basic block
    print("ir-cfg :",irHandler.cfg)
    print("cfg : ",cfg)
    abstractInterpreter = AI.AbstractInterpreter(irHandler)
    bbIn, bbOut = abstractInterpreter.worklistAlgorithm(irHandler.cfg)

   

    
    print('\nIN OF ALL BASIC BLOCKS :--------------\n\n ',bbIn)
    print('\nOUT OF ALL BASIC BLOCKS :--------------\n\n ',bbOut)
  
    #implement your analysis according to the questions on each basic blocks
    
    final_turtle_X_pos = bbOut['END'][0]['OUT']['X']  
    final_turtle_Y_pos = bbOut['END'][0]['OUT']['Y']  
    Kachua_point_1 = [final_turtle_X_pos['left'],final_turtle_Y_pos['left']]
    Kachua_point_2 = [final_turtle_X_pos['right'],final_turtle_Y_pos['right']]
    Rectangle = namedtuple('Rectangle', 'xmin ymin xmax ymax')
    xmin1 = min(ALG_POINT_1[0],ALG_POINT_2[0])
    ymin1 = min(ALG_POINT_1[1],ALG_POINT_2[1])
    xmax2 = max(ALG_POINT_1[0],ALG_POINT_2[0])
    ymax2= max(ALG_POINT_1[1],ALG_POINT_2[1])

    Xmin1 = min(Kachua_point_1[0],Kachua_point_2[0])
    Ymin1 = min(Kachua_point_1[1],Kachua_point_2[1])
    Xmax2 = max(Kachua_point_1[0],Kachua_point_2[0])
    Ymax2= max(Kachua_point_1[1],Kachua_point_2[1])
    
    ra = Rectangle(xmin1,ymin1 ,xmax2 , ymax2)
    rb = Rectangle(Xmin1,Ymin1 ,Xmax2 ,Ymax2 )
    print("\nMAGARMACH REGION : " , ALG_POINT_1 ," TO " , ALG_POINT_2)
    print("\nKACHUA EVENTUAL POSSIBLE REGION : " , Kachua_point_1 ," TO " , Kachua_point_2)
    print ("\nOverlapping area of kachua'a region and magarmach's region = ",area(ra, rb))
    if(area(ra,rb) == None):
        print("\n\"{VERIFIED} KACHUA IS SAFE\"  :: IT CANNOT LIE IN MAGARMACH'S RANGE IF STARTED AT COORDINATE LYING BETWEEN RANGE FOR X & Y AS : ",INI_X,"&",INI_Y , "RESPECTIVELY.")
    else:
        print("\n\"KACHUA IS UNSAFE\" :: IT CAN LIE IN MAGARMACH'S RANGE IF STARTED AT COORDINATE LYING BETWEEN RANGE FOR X & Y AS : ",INI_X,"&",INI_Y,"RESPECTIVELY.")
