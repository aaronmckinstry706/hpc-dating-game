import socket
import sys
import numpy as np
import math
import random
import unittest
from architecture.dating.utils import floats_to_msg4

PORT = int(sys.argv[1])

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(('localhost', PORT))

num_string = sock.recv(4)
assert num_string.endswith('\n')

num_attr = int(num_string[:-1])

binary_vectors = []
dot_products = []

# ----------------- UTILITY FUNCTIONS ---------------------

def processLine(data):
    score = float(data.split(":")[0])
    vector = [float(el) for el in data.split(":")[1].split(",")]
    return (vector,score)

# -------------------- MATCHMAKER LOGIC ------------------------

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

shuffledIndexes = [i for i in range(0,num_attr)]
random.shuffle(shuffledIndexes)
numSubsets = 18
subsetSize = num_attr/numSubsets
subsetSizes = [subsetSize+1]*(num_attr%numSubsets) + [subsetSize]*(numSubsets - (num_attr%numSubsets))

subsetScores = [0 for i in range(0,numSubsets)]

def getSubsetVector(k):
    global shuffledIndexes
    v = [0 for L in range(0,num_attr)]
    offset = sum(subsetSizes[:k])
    print(k)
    for j in range(offset, offset+subsetSizes[k]):
        v[shuffledIndexes[j]] = 1
    return v

for i in range(20):
    if i < numSubsets:
        candidate = getSubsetVector(i)
    elif i > numSubsets:
        candidateIndex = max([i for i in range(0,20)], lambda i: dot_products[i])
        candidate = binary_vectors[i]
    else:
        subsetOn = [subsetScores[j] > 0 for j in range(0,numSubsets)]
        v = []
        for i in range(0,numSubsets):
            if subsetOn[i]:
                v.append(getSubsetVector(i))
        v = [sum([v[k][j] for k in range(0,len(v))]) for j in range(0,num_attr)]
        print(v)
        candidate = v
    
    binary_vectors.append(candidate)
    
    a = np.array(candidate)
    sock.sendall(floats_to_msg4(a))
    data = sock.recv(8)
    score = float(data[:-1])
    print('i = %d score = %f' % (i, score))
    
    dot_products.append(score)
    if i < numSubsets:
        subsetScores[i] = score

sock.close()
