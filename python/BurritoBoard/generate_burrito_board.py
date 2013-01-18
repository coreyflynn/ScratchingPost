#! /usr/bin/env python
import jinja2
import cmap.util.text as text
import cmap.util.ftp as ftp

# read in data table
burrito_path = '/xchip/cogs/cflynn/git_repos/ScratchingPost/python/BurritoBoard/BurritoBoard.txt'
text.demacify(burrito_path)
data = []
with open(burrito_path,'r') as f:
	headers = f.readline()
	ideal = f.readline()
	num_meetings = ideal.split('\t')[3].rstrip()
	lines = f.readlines()
	for line in lines:
		fields = line.split('\t')
		name = fields[0]
		program_meeting = fields[1]
		lab_meeting = fields[2]
		total = fields[3].rstrip()
		percent = float(total)/float(num_meetings)*100
		data.append({'name':name,
					 'program_meeting':program_meeting,
					 'lab_meeting':lab_meeting,
					 'total':total,
					 'percent':percent})

# find the leader order
data.sort(key=lambda x: x['total'])
data.reverse()

# add label and progress bar html
first_total = data[0]['total']
last_total = data[-1]['total']
for d in data:
	if d['total'] == first_total:
		d['badge'] = '<span class="label label-success">Burrito</span>'
		d['progress'] = '"progress progress-success"'
	elif d['total'] == last_total:
		d['badge'] = '<span class="label label-important">Heckle Me</span>'
		d['progress'] = '"progress progress-danger"'
	else:
		d['badge'] = ''
		d['progress'] = '"progress"'

# buld an environment for jinja2
env_path = '/xchip/cogs/cflynn/git_repos/ScratchingPost/python/BurritoBoard/'
env = jinja2.Environment(loader=jinja2.FileSystemLoader(env_path))

# build index.html from the KD_Summary_Template.html template
index_page_template = env.get_template('BurritoBoardTemplate.html')
with open('index.html','w') as f:
	f.write(index_page_template.render(data=data,num_meetings=num_meetings))

# move index file to www.broadinstitute.org/~cflynn/burrito
SFTP = ftp.SFTP()
SFTP.connect()
SFTP.put('index.html','/home/unix/cflynn/public_html/burrito/index.html')
SFTP.close()