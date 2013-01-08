#! /usr/bin/env python
import matplotlib.pyplot as plt

ids = []
scores = []

with open('/xchip/cogs/cflynn/Collab/MUC1/affogato_r1/affogato_r1_MUC1_scores.txt','r') as f:
	f.readline()
	lines = f.readlines()
	for line in lines:
		line.rstrip()
		fields = line.split('\t')
		ids.append(fields[0])
		scores.append(float(fields[1]))

fig = plt.figure()
ax = fig.add_subplot(111)
plt.hist(scores,500,histtype='stepfilled')
plt.show()
