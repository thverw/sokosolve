def read_map():
    f = open('InstancesClean/Inst-A-Z32-10Winkel.lp', 'r')
    sr = f.read()
    # f = open('atlist','r')

    mapRepresentation = []
    playerPosition = [0, 0]
    boxPos = []

    # find out what the dimensions of the map are ...
    n = get_max(sr)
    # ... and creating the boolean representation of it
    for i in range(n[1]):
        helplist = []
        for j in range(n[0]):
            helplist += [False]
        mapRepresentation += [helplist]
    boxPos = []
    for k in range(n[2]):
        boxPos += [[0, 0]]
    targetPos = []
    for l in range(n[2]):
        targetPos += [[0, 0]]

    # calling readMap and showMap
    linelist = sr.splitlines(True)
    indexTargets = 0
    for line in linelist:
        # read out fields, by checking for the init(field((a;b..c),d)) syntax
        if line[5:10] == "field":
            s = line[11:]
            a = ""
            b = ""
            lr = True
            la = []
            lb = []
            while len(s) > 0:
                if (ord(s[0]) in range(48, 58)) or (s[0] == ';'):
                    if lr:
                        a = a + s[0]
                    else:
                        b = b + s[0]
                    s = s[1:]
                elif s[0:2] == "..":
                    if lr:
                        a = a + s[0:2]
                    else:
                        b = b + s[0:2]
                    s = s[2:]
                elif s[0] == ',':
                    lr = False
                    l = lb
                    la += finish(a)
                    a = ""
                    lb += finish(b)
                    b = ""
                    s = s[1:]
                elif s[0] == '.':
                    l = lb
                    la += finish(a)
                    a = ""
                    lb += finish(b)
                    b = ""
                    s = s[1:]
                else:
                    l = lb
                    la += finish(a)
                    a = ""
                    lb += finish(b)
                    b = ""
                    s = s[1:]
            for i in lb:
                for j in la:
                    mapRepresentation[i - 1][j - 1] = True
        elif line[5:7] == "at":
            s = line[8:]
            a = ""
            lr = True
            u = 0
            stringlist = s.split(",")
            stringlist[2] = stringlist[2].translate(None, ',).\n')
            if int(stringlist[0]) == 0:
                playerPosition = [int(stringlist[1]), int(stringlist[2])]
            else:
                boxPos[int(stringlist[0]) - 1] = [int(stringlist[1]), int(stringlist[2])]

        elif line[5:11] == "target":
            s = line[12:]
            s2 = ""
            while ord(s[0]) in range(48, 58):
                s2 = s2 + s[0]
                s = s[1:]
            s = s.translate(None, ',).\n')
            targetPos[indexTargets] = [int(s2), int(s)]
            indexTargets += 1
    if playerPosition == None:
        exit('no player position')
    f = open('Stuff/action_plan.txt','r')
    sr = f.read()
    at_string_arr = sr.split(" ")
    # cut line end
    at_string_arr[len(at_string_arr)-1] = at_string_arr[len(at_string_arr)-1][:len(at_string_arr[len(at_string_arr)-1])-1]

    # find biggest T and N
    max_t = 0
    max_n = 0
    for at_string in at_string_arr:
        at_help_arr = at_string[3:len(at_string)-1].split(",")
        if int(at_help_arr[3]) > max_t:
            max_t = int(at_help_arr[3])
        if int(at_help_arr[0]) > max_n:
            max_n = int(at_help_arr[0])

    at_list = []
    for i in range(0,max_n + 1):
        help_arr = []
        for j in range(0,max_t + 1):
            help_arr += [[-1,-1]]
        at_list += [help_arr]
    for at_string in at_string_arr:
        at_string = at_string[3:len(at_string)-1]
        at_help_arr = at_string.split(",")
        # at_list is a three-dimensional list
        # here we change the [N][T][0] to X and the [N][T][1] to Y
        at_list[int(at_help_arr[0])][int(at_help_arr[3])][0] = int(at_help_arr[1])
        at_list[int(at_help_arr[0])][int(at_help_arr[3])][1] = int(at_help_arr[2])
    return mapRepresentation, boxPos, targetPos, playerPosition, at_list, max_t


def get_max(mapping):
    r = 0
    l = 0
    lr = True
    s = ""
    x = -1
    y = 0
    linelist = mapping.splitlines(True)
    for line in linelist:
        if "field" in line:
            for c in line:
                if ord(c) in range(48, 58):
                    s = s + c
                elif c == ',':
                    if s != "":
                        i = int(s)
                        s = ""
                    else:
                        i = 0
                    if lr:
                        l = max(i, l)
                    else:
                        r = max(i, r)
                    lr = False
                elif c == '\n':
                    lr = True
                else:
                    if s != "":
                        i = int(s)
                        s = ""
                    else:
                        i = 0
                    if lr:
                        l = max(i, l)
                    else:
                        r = max(i, r)
        elif "target" in line:
            y += 1
    return [l, r, y]


def finish(x):
    beforeDoubleDot = True
    w = ''
    v = ''
    l = []
    k = x
    while len(k) > 0:
        if ord(k[0]) in range(48, 58):
            if beforeDoubleDot:
                w = w + k[0]
            else:
                v = v + k[0]
        elif (k[0] == '.') and (k[1] == '.'):
            beforeDoubleDot = False
            k = k[1:]
        elif v != '':
            if w != '':
                l += range(int(w), int(v) + 1)
            else:
                l += range(l[len(l) - 1] + 1, int(v) + 1)
            w = ''
            v = ''
            beforeDoubleDot = True
        elif w != '':
            l += [int(w)]
            w = ''
        k = k[1:]
    if v != '':
        if w != '':
            l += range(int(w), int(v) + 1)
        else:
            l += range(l[len(l) - 1] + 1, int(v) + 1)
        w = ''
        v = ''
        beforeDoubleDot = True
    elif w != '':
        l += [int(w)]
        w = ''
    return l
