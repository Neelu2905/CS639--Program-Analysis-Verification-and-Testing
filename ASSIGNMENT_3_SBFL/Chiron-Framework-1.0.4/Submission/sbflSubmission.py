#!/usr/bin/env python3

import argparse
import sys
import numpy as np
import math

sys.path.insert(0, "../ChironCore/")
from irhandler import *
from ChironAST.builder import astGenPass
import csv


def fitnessScore(IndividualObject):
    """
    Parameters
    ----------
    IndividualObject : Individual (definition of this class is in ChironCore/sbfl.py)
        This is a object of class Individual. The Object has 3 elements
        1. IndividualObject.individual : activity matrix.
                                    type : list, row implies a test
                                    and element of rows are components.
        2. IndividualObject.fitness : fitness of activity matix.
                                    type : float
        3. Indivisual.fitness_valid : a flag used by Genetic Algorithm.
                                    type : boolean
    Returns
    -------
    fitness_score : flaot
        returns the fitness-score of the activity matrix.
        Note : No need to set/change fitness and fitness_valid attributes.
    """
    # Design the fitness function
    # Use 'activity_mat' to compute fitness of it.
    # ToDo : Write your code here to compute fitness of test-suite
    
    fitness_score = 0
    matrix = np.array(IndividualObject.individual, dtype="int")
    matrix = matrix[:, : matrix.shape[1] - 1]
    
     ##  UNIQUENESS
    uc = np.unique(matrix, axis=1)
    num_uc = uc.shape[1]
    total_cols = matrix.shape[1]
    uniqueness = num_uc/total_cols

    ##  DIVERSITY
    # Get the unique rows and their counts
    ur, counts = np.unique(matrix, axis=0, return_counts=True)
    num_ur = ur.shape[0]
    count_array = counts
    total_sum = 0
    for i in range(num_ur):
        k = count_array[i]
        total_sum += k * (k - 1)
    N = matrix.shape[0]
    result = total_sum / (N * (N - 1))
    diversity=1-result

    ##  DENSITY 
    num_ones = np.count_nonzero(matrix == 1)
    M, N = matrix.shape
    density = num_ones / (M * N)
    newDensity=1-abs(1-(2*density))

    fitness_score = (newDensity * diversity * uniqueness)    
    return (-1)*fitness_score


# This class takes a spectrum and generates ranks of each components.
# finish implementation of this class.
class SpectrumBugs:
    def __init__(self, spectrum):
        self.spectrum = np.array(spectrum, dtype="int")
        self.comps = self.spectrum.shape[1] - 1
        self.tests = self.spectrum.shape[0]
        self.activity_mat = self.spectrum[:, : self.comps]
        self.errorVec = self.spectrum[:, -1]

    def getActivity(self, comp_index):
        """
        get activity of component 'comp_index'
        Parameters
        ----------
        comp_index : int
        """
        return self.activity_mat[:, comp_index]

    def suspiciousness(self, comp_index):
        Cf = 0
        Cp = 0
        Nf = 0
        Np = 0

        errorVector = np.array(self.errorVec)
        
        matrix = np.array(self.activity_mat)
        comp_col = matrix[:,comp_index]
        
        for i in range(len(comp_col)):
            element1 = comp_col[i]
            element2 = errorVector[i]
            # calculating cf
            if element1==1 and element2==1:
                Cf = Cf + 1
        
            if element1==0 and element2==1:
                Nf = Nf + 1
      
            if element1==0 and element2==0:
                Np = Np + 1
            
            if element1==1 and element2==0:
                Cp = Cp + 1

        # Calculating Ochiai
        denominator = math.sqrt((Cf+Nf)*(Cf+Cp))
        if denominator!=0:
            final_answer = Cf/denominator
            print("ochiai: ", final_answer)
        else:
            final_answer = 0
        sus_score=final_answer

        return sus_score

    def getRankList(self):
        """
        find ranks of each components according to their suspeciousness score.

        Returns
        -------
        rankList : list
            ranList will contain data in this format:
                suppose c1,c2,c3,c4 are components and their ranks are
                1,2,3,4 then rankList will be :
                    [[c1,1],
                     [c2,2],
                     [c3,3],
                     [c4,4]]
        """
        # ToDo : implement rankList
        sus_score = []

        for i in range(self.comps):
            sus_score.append((self.suspiciousness(i), i + 1))
            
        print("Sus_score are as follows: ", sus_score)

        # Sort the list of tuples based on the first element of each tuple (which was the dictionary key).
        sorted_data = sorted(sus_score, key=lambda tup: (tup[0], 0 if tup[0] is not None else 1), reverse=True)




        print("Sus_score are as follows after sorting: ", sorted_data)
        print(self.activity_mat)

        rankList = []

        count = -1
        temp_key_old = -1
        rankList = []

        for tup in sorted_data:
            temp_key_new = tup[0]
            component_number = tup[1]

            if temp_key_old != temp_key_new:
                count += 1

            temp = (f'c{component_number}', count + 1)
            rankList.append(temp)
            temp_key_old = temp_key_new
        print(rankList)
        return rankList
        


# do not modify this function.
def computeRanks(spectrum, outfilename):
    """
    Parameters
    ----------
    spectrum : list
        spectrum
    outfilename : str
        components and their ranks.
    """
    S = SpectrumBugs(spectrum)
    rankList = S.getRankList()
    with open(outfilename, "w") as file:
        writer = csv.writer(file)
        writer.writerows(rankList)
