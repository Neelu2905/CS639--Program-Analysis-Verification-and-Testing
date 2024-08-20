from kast import kachuaAST
import sys
from z3 import *
sys.path.insert(0, "KachuaCore/interfaces/")
from interfaces.fuzzerInterface import *
sys.path.insert(0, '../KachuaCore/')
import random

# Each input is of this type.
#class InputObject():
#    def __init__(self, data):
#        self.id = str(uuid.uuid4())
#        self.data = data
#        # Flag to check if ever picked
#        # for mutation or not.
#        self.pickedOnce = False
        
class CustomCoverageMetric(CoverageMetricBase):
    # Statements covered is used for
    # coverage information.
    def __init__(self):
        super().__init__()

    # TODO : Implement this
    def compareCoverage(self, curr_metric, total_metric):
        # must compare curr_metric and total_metric
        # True if Improved Coverage else False
        if len(curr_metric) > len(total_metric):
            return True  # Improved coverage
        else:
            return False

    # TODO : Implement this
    def updateTotalCoverage(self, curr_metric, total_metric):
        # Compute the total_metric coverage and return it (list)
        # this changes if new coverage is seen for a
        # given input.
        total_metric.extend(curr_metric)  # Merge coverage information
        return sorted(list(set(total_metric)))

class CustomMutator(MutatorBase):
    def __init__(self):
        pass

    # TODO : Implement this
    def mutate(self, input_data, coverageInfo, irList):
        # Mutate the input data and return it
        # coverageInfo is of type CoverageMetricBase
        # Don't mutate coverageInfo
        # irList : List of IR Statments (Don't Modify)
        # input_data.data -> type dict() with {key : variable(str), value : int}
        # must return input_data after mutation.
        keys = list(input_data.data.keys())
        for i in keys:
            x = random.choice([10, 20, 30])
            random_addition = random.randint(-x, x)
            random_xor = random.randint(-x, x)
            input_data.data[i] += random_addition
            input_data.data[i] ^= random_xor

            mutation_type = random.choice(['0', '1', '2', '3', '4','5'])

            if mutation_type in ['0','1']: 
                input_data.data[i] = flip_random_bits(input_data.data[i],random.randint(2, 5))
            
            elif mutation_type in ['2']:
                input_data.data[i] = inject_bits(input_data.data[i], 0b01, random.randint(0, 8))
            
            elif mutation_type in ['3','4','5']:
                input_data.data[i] = apply_random_bitmask(input_data.data[i])      
        return input_data

def apply_random_bitmask(input_value):    
        bitmask = random.randint(0, 0x111)  
        result = input_value & bitmask
    
        return result

def flip_random_bits(value, num_bits):
    for _ in range(num_bits):
        bit_position = random.randint(0, num_bits - 1)
        value = value ^ (1 << bit_position)
    return value

def inject_bits(input_value, bit_pattern, injection_point):
    if injection_point < 0 or injection_point >= 32:
        return input_value 
    clear_mask = ~(1 << injection_point)
    cleared_value = input_value & clear_mask
    injected_value = cleared_value | (bit_pattern << injection_point)
    
    return injected_value

# Reuse code and imports from
# earlier submissions (if any).
