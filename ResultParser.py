import os, xlwt, string

book = xlwt.Workbook(encoding="utf-8")

sheet1 = book.add_sheet("Sheet 1", cell_overwrite_ok=True)

index = 0
sheet1.write(index, 0, "ENCODING")
sheet1.write(index, 1, "OPTIMIZATIONS")
sheet1.write(index, 2, "SIZE")
sheet1.write(index, 3, "BOXRATIO")
sheet1.write(index, 4, "STRUCTURE")
sheet1.write(index, 5, "ASSIGNMENTS")
sheet1.write(index, 6, "ZONES")
sheet1.write(index, 7, "RESULT")
sheet1.write(index, 8, "CHOICES")
sheet1.write(index, 9, "CONFLICTS")
sheet1.write(index, 10, "RESTARTS")
sheet1.write(index, 11, "ATOMS")
sheet1.write(index, 12, "RULES")
sheet1.write(index, 13, "VARIABLES")
sheet1.write(index, 14, "CONSTRAINTS")
sheet1.write(index, 15, "TIME")
index += 1

for file in os.listdir("Results"):
	
	myfile = open(os.path.join("Results",file),"r")
	linelist = myfile.readlines()
	myname = os.path.basename(myfile.name)
	thename = myname
	myname = myname[7:]
	if "Split" in myname:
		sheet1.write(index, 0, "Split")
		myname = myname[4:]
	else:
		sheet1.write(index, 0, "Plain")
	if myname[:1] == "C":
		sheet1.write(index, 1, "Clutter")
		myname = myname[1:]
	elif myname[:2] == "FF":
		sheet1.write(index, 1, "ForbiddenFields")
		myname = myname[2:]
	elif myname[:4] == "MOOB":
		sheet1.write(index, 1, "MovesOutOfBounds")
		myname = myname[4:]
	elif myname[:3] == "NTB":
		sheet1.write(index, 1, "NoTakebacks")
		myname = myname[3:]
	elif myname[:4] == "WBTC":
		sheet1.write(index, 1, "WallBoxTargetCheck")
		myname = myname[4:]
	elif myname[:5] == "Type1":
		sheet1.write(index, 1, "Clutter, MOOB, NTB")
		myname = myname[5:]
	elif myname[:5] == "Type2":
		sheet1.write(index, 1, "Clutter, MOOB, NTB, WBTC")
		myname = myname[5:]
	while myname[:1] != "-" and myname[:1] != "+":
		myname = myname[1:]
	if myname[:1] == "-":
		sheet1.write(index, 5, False)
	else:
		sheet1.write(index, 5, True)
	myname = myname[2:]
	if myname[:1] == "-":
		sheet1.write(index, 6, False)
	else:
		sheet1.write(index, 6, True)
	myname = myname[2:]
	if myname[3:4] == "1":
		sheet1.write(index, 3, "1/3")
	elif myname[3:4] == "4":
		sheet1.write(index, 3, "1/5")
	elif myname[3:4] == "5":
		sheet1.write(index, 3, "1/4")
	elif myname[3:4] == "8":
		sheet1.write(index, 3, "1/4")
	elif myname[3:4] == "9":
		sheet1.write(index, 3, "1/3")
	elif myname[3:4] == "6":
		if myname[:2] == "20":
			sheet1.write(index, 3, "1/3")
		else:
			sheet1.write(index, 3, "1/5")
	if myname[:2] == "20":
		sheet1.write(index, 2, "Small")
	else:
		sheet1.write(index, 2, "Large")
	myname = myname[5:]
	if "alle" in myname:
		sheet1.write(index, 4, "Halle")
	else:
		sheet1.write(index, 4, "Winkel")
	all = string.maketrans('','')
	nodigs = all.translate(all, string.digits)
	if len(linelist) > 28:
		if "UNKNOWN" not in myfile.read():
			print thename
			j = 0
			while "Calls" not in linelist[j]:
				j += 1
			j+=1
			i = j+3
			sheet1.write(index, 15, linelist[j].split(' : ')[1].split(' ')[0])
			sheet1.write(index, 8, linelist[i].split(' : ')[1].split(' ')[0].translate(all,nodigs))
			sheet1.write(index, 9, linelist[i+1].split(' : ')[1].split(' ')[0].translate(all,nodigs))
			sheet1.write(index, 10, linelist[i+2].split(' : ')[1].split(' ')[0].translate(all,nodigs))
			sheet1.write(index, 11, linelist[i+12].split(' : ')[1].split(' ')[0].translate(all,nodigs))
			sheet1.write(index, 12, linelist[i+13].split(' : ')[1].split(' ')[0].translate(all,nodigs))
			sheet1.write(index, 13, linelist[i+14].split(' : ')[1].split(' ')[0].translate(all,nodigs))
			sheet1.write(index, 14, linelist[i+15].split(' : ')[1].split(' ')[0].translate(all,nodigs))
		if "TIME LIMIT" in myfile.read():
			sheet1.write(index, 7, "TIMEOUT")
			sheet1.write(index, 15, "900s")
		else:
			sheet1.write(index, 7, linelist[3][: -1])
	else:
		sheet1.write(index, 7, "FAILURE")
		sheet1.write(index, 15, "900s")
	index += 1

book.save("excelfile.xls")
