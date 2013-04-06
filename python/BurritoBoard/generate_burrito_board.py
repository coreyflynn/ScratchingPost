#! /usr/bin/env python
import jinja2
import cmap.util.text as text
import cmap.util.ftp as ftp

# read in data table
burrito_path = '/xchip/cogs/cflynn/git_repos/ScratchingPost/python/BurritoBoard/BurritoBoard.txt'
text.demacify(burrito_path)
month_data = []
all_data = []

with open(burrito_path,'r') as f:
	headers = f.readline()
	month_ideal = f.readline()
	all_ideal = f.readline()
	month_num_meetings = month_ideal.split('\t')[3].rstrip()
	all_num_meetings = all_ideal.split('\t')[3].rstrip()
	lines = f.readlines()
	for line in lines:
		fields = line.split('\t')
		name = fields[0]
		if name == '#month':
			month = True
			continue
		elif name == '#all':
			month = False
			continue
		program_meeting = fields[1]
		lab_meeting = fields[2]
		total = fields[3].rstrip()
		if month:
			percent = float(total)/float(month_num_meetings)*100
			month_data.append({'name':name,
						 'program_meeting':program_meeting,
						 'lab_meeting':lab_meeting,
						 'total':total,
						 'percent':percent})
		else:
			percent = float(total)/float(all_num_meetings)*100
			all_data.append({'name':name,
						 'program_meeting':program_meeting,
						 'lab_meeting':lab_meeting,
						 'total':total,
						 'percent':percent})

# find the leader order
month_data.sort(key=lambda x: float(x['total']))
month_data.reverse()
all_data.sort(key=lambda x: float(x['total']))
all_data.reverse()

# add label and progress bar html
first_total = month_data[0]['total']
last_total = month_data[-1]['total']
for d in month_data:
	if d['total'] == first_total:
		d['badge'] = '<span class="label label-success">Burrito</span>'
		d['progress'] = '"progress progress-success"'
	elif d['total'] == last_total:
		d['badge'] = '<span class="label label-important">Heckle Me</span>'
		d['progress'] = '"progress progress-danger"'
	else:
		d['badge'] = ''
		d['progress'] = '"progress"'

first_total = all_data[0]['total']
last_total = all_data[-1]['total']
for d in all_data:
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
	f.write(index_page_template.render(month_data=month_data,
									   month_num_meetings=month_num_meetings,
									   all_data=all_data,
									   all_num_meetings=all_num_meetings))

# move index file to www.broadinstitute.org/~cflynn/burrito
SFTP = ftp.SFTP()
SFTP.connect()
SFTP.put('index.html','/home/unix/cflynn/public_html/burrito/index.html')
SFTP.close()