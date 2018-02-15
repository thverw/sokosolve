import sys
import os
from PyQt4 import QtGui
from PyQt4 import QtCore


class SokoShow(QtGui.QApplication):
    def main(self):
        indT = 0

        def readMap(mapping):
            linelist = mapping.splitlines(True)
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
            else:
                return playerPosition

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

        def getMax(mapping):
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

        def showMap(mapping, boxes, targets, player):
            # map is a collection of info on schematics
            # app = QtGui.QApplication(sys.argv)
            w = QtGui.QWidget()
            grid = QtGui.QGridLayout()
            w.setLayout(grid)
            box = QtGui.QPixmap(os.getcwd() + '/Img/Box.png')
            empty = QtGui.QPixmap(os.getcwd() + '/Img/Empty.png')
            guy = QtGui.QPixmap(os.getcwd() + '/Img/Guy.png')
            wall = QtGui.QPixmap(os.getcwd() + '/Img/Wall.png')
            target = QtGui.QPixmap(os.getcwd() + '/Img/Target.png')
            labellist = []
            for x in range(len(mapping)):
                for y in range(len(mapping[x])):
                    if mapping[x][y]:
                        helplabel = QtGui.QLabel(w)
                        helplabel.setPixmap(empty)
                        labellist += [helplabel]
                        grid.addWidget(helplabel, x, y)
                    else:
                        helplabel = QtGui.QLabel(w)
                        helplabel.setPixmap(wall)
                        labellist += [helplabel]
                        grid.addWidget(helplabel, x, y)
            for x in boxes:
                helplabel = QtGui.QLabel(w)
                helplabel.setPixmap(box)
                labellist += [helplabel]
                grid.addWidget(helplabel, x[1] - 1, x[0] - 1)
            for x in targets:
                helplabel = QtGui.QLabel(w)
                helplabel.setPixmap(target)
                labellist += [helplabel]
                grid.addWidget(helplabel, x[1] - 1, x[0] - 1)
            helplabel = QtGui.QLabel(w)
            helplabel.setPixmap(guy)
            labellist += [helplabel]
            grid.addWidget(helplabel, player[1] - 1, player[0] - 1)
            # w.resize(boxpic.width(),boxpic.height())
            button0 = QtGui.QPushButton("Previous Step", w)
            button1 = QtGui.QPushButton("Next Step", w)
            button2 = QtGui.QPushButton("From Beginning", w)
            QtCore.QObject.connect(button0, QtCore.SIGNAL("clicked()"), handleB0)
            QtCore.QObject.connect(button1, QtCore.SIGNAL("clicked()"), handleB1)
            QtCore.QObject.connect(button2, QtCore.SIGNAL("clicked()"), handleB2)
            grid.addWidget(button0, n[1] - 3, n[0])
            grid.addWidget(button1, n[1] - 2, n[0])
            grid.addWidget(button2, n[1] - 1, n[0])
            w.show()
            sys.exit(self.exec_())

        def handleB0():
            print("B0")

        def handleB1():
            print("B1")

        def handleB2():
            print("B2")

        f = open('newinstance03.lp', 'r')
        s = f.read()
        # f = open('atlist','r')

        mapRepresentation = []
        playerPosition = [0, 0]
        boxPos = []

        # find out what the dimensions of the map are ...
        n = getMax(s)
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
        playerPosition = readMap(s)
        showMap(mapRepresentation, boxPos, targetPos, playerPosition)

    def __init__(self):
        QtGui.QApplication.__init__(self, sys.argv)
        self.main()


if __name__ == "__main__":
    a = SokoShow()
