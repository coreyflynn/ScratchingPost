import time
#start a timer
start = time.time();

import sys
print("sys import: {0}s".format(time.time() - start))
import cmap
print("cmap import: {0}s".format(time.time() - start))
import cmap.io.gct as gct
print("gct import: {0}s".format(time.time() - start))




#get the index of the column to slice
col_inds = eval(sys.argv[1])

if type(col_inds) == int:
	col_inds = [col_inds]
elif type(col_inds) == list:
	pass
else:
	col_inds = eval("[" + sys.argv[1] + "]")

#get the index of the rows to slice
if sys.argv[2] not in "all":
	row_inds = eval(sys.argv[2])
	if type(row_inds) == int:
		row_inds = [row_inds]
	elif type(row_inds) == list:
		pass
	else:
		row_inds = eval("[" + sys.argv[2] + "]")


#slice the column out of the summly matrix
summly = gct.GCT(sys.argv[3])
if sys.argv[2] not in "all":
	summly.read(col_inds=col_inds,row_inds=row_inds)
else:
	summly.read(col_inds=col_inds)

#how long did the slice take?
print("slice: {0}s".format(time.time() - start))

#write the sliced column to a json file
with open('slice.json','w') as f:
	f.write(summly.frame.to_json())

print("json: {0}s".format(time.time() - start))
