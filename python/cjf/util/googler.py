'''
quick function to set up Cal_1 QC reports for use in google's motion charts 
'''

if __name__ == "main":
	f = open('raw_report.csv','r')
	
	#f.readline()
	lines = f.xreadlines()
	rowNum = 0
	for line in lines:
		lineElements = line.split(",")
		scanner = lineElements[5]
		#parse date
		scan_date_and_time = lineElements[6]
		scan_date = scan_date_and_time.split()[0]
		scan_time = scan_date_and_time.split()[1]
		scan_date_fields = scan_date.split('/')
		scan_time_fields = scan_time.split(':')
		cal_1 = lineElements[10]
		print("data.setValue("+str(rowNum)+", 0, '"+scanner+"');")
		print("data.setValue("+str(rowNum)+", 1, new Date ("+scan_date_fields[2]+", "+scan_date_fields[0]+", "+scan_date_fields[1]+", "+scan_time_fields[0]+", "+scan_time_fields[1]+", 0));")
		print("data.setValue("+str(rowNum)+", 2, "+cal_1+");")
		rowNum += 1
	