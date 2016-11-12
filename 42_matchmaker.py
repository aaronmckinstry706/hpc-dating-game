import socket
import sys
import numpy as np
import math
import random
import unittest
from architecture.dating.utils import floats_to_msg4

# ----------------- GLOBAL VARIABLES ---------------------

num_attr = 0
binary_vectors = []
dot_products = []

# ----------------- MATCHMAKER LOGIC ---------------------

def randomBinaryVector(distribution):
    return [int(random.random() < distribution[i]) for i in range(0,len(distribution))]

def calculateDistribution(binaryVectors, dotProducts):
    # invert any with negative dot products
    # calculate sum of dot products
    total = 0
    for i in range(0,len(dotProducts)):
        if dotProducts[i] < 0:
            binaryVectors[i] = [1-binaryVectors[i][j] for j in range(0,num_attr)]
            dotProducts[i] = -dotProducts[i]
        total = total + dotProducts[i]
    
    # calculate normalized probability of each element being a 1
    distribution = [0 for j in range(0,num_attr)]
    for i in range(0,len(binaryVectors)):
        distribution = [distribution[j]+binaryVectors[i][j]*dotProducts[i]/total for j in range(0,num_attr)]
    return distribution

# ------------------ UNIT TESTS ---------------------------

doUnitTests = False

class TestMatchmakerFunctions(unittest.TestCase):
    def setUp(self):
        global num_attr
        num_attr = 4
    
    def tearDown(self):
        global num_attr
        num_attr = 0
    
    def test_calculateDistribution(self):
        global num_attr
        binaryVectors = [[0,0,1,1],
                         [0,1,0,1],
                         [1,0,1,1]]
        dotProducts = [0.4,-.2,.3];
        result = tuple(calculateDistribution(binaryVectors,dotProducts))
        expectedResult = (0.5/0.9, 0.0, 1.0, 0.7/0.9)
        for i in range(0,num_attr):
            self.assertAlmostEqual(expectedResult[i],result[i])

if doUnitTests:
    testSuite = unittest.TestLoader().loadTestsFromTestCase(TestMatchmakerFunctions)
    unittest.TextTestRunner(verbosity=2).run(testSuite)

# ----------------- UTILITY FUNCTIONS ---------------------

def processLine(data):
    score = float(data.split(":")[0])
    vector = [float(el) for el in data.split(":")[1].split(",")]
    return (vector,score)

# ----------------- MAIN LOOP ---------------------

PORT = int(sys.argv[1])

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(('localhost', PORT))

num_string = sock.recv(4)
assert num_string.endswith('\n')

num_attr = int(num_string[:-1])

for i in range(20):
    # score digits + binary labels + commas + exclamation
    data = sock.recv(8 + 2*num_attr)
    vector_score = processLine(data)
    vector = vector_score[0]
    score = vector_score[1]
    
    binary_vectors.append(vector)
    dot_products.append(score)
    
    print('Score = %s' % data[:8])
    assert data[-1] == '\n'

for i in range(20):
    distribution = calculateDistribution(binary_vectors,dot_products)
    candidate = randomBinaryVector(distribution)
    
    a = np.array(candidate)
    sock.sendall(floats_to_msg4(a))
    data = sock.recv(8)
    assert data[-1] == '\n'
    score = float(data[:-1])
    print('i = %d score = %f' % (i, score))

sock.close()
