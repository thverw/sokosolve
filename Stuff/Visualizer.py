import sys
import os
from Parser import read_map, get_max
from PyQt5 import QtGui, QtWidgets

step_index = 0
max_step = 1


class Visualizer(QtWidgets.QApplication):

    def __init__(self):
        QtWidgets.QApplication.__init__(self, sys.argv)
        w = QtWidgets.QWidget()
        w.setWindowTitle('')
        my_grid = QtWidgets.QGridLayout()
        w.setLayout(my_grid)

        f = open('InstancesClean/Inst-A-Z32-10Winkel.lp', 'r')
        sr = f.read()
        n = get_max(sr)
        self.redraw(my_grid, w)
        # w.resize(boxpic.width(),boxpic.height())
        button0 = QtWidgets.QPushButton("Previous Step", w)
        button1 = QtWidgets.QPushButton("Next Step", w)
        button2 = QtWidgets.QPushButton("From Beginning", w)

        def button_back():
            global step_index
            if step_index > 0:
                step_index -= 1
                print(step_index)
                self.redraw(my_grid, w)

        def button_forward():
            global step_index
            if step_index < max_step:
                step_index += 1
                print(step_index)
                self.redraw(my_grid, w)

        def button_beginning():
            global step_index
            step_index = 0
            print(step_index)
            self.redraw(my_grid, w)

        button0.clicked.connect(button_back)
        button1.clicked.connect(button_forward)
        button2.clicked.connect(button_beginning)
        my_grid.addWidget(button0, n[1] - 3, n[0])
        my_grid.addWidget(button1, n[1] - 2, n[0])
        my_grid.addWidget(button2, n[1] - 1, n[0])
        w.setGeometry(50,50,500,400)
        w.show()
        sys.exit(self.exec_())

    def redraw(self, grid, widget):
        mapping, boxes, targets, player, at_list, max_t = read_map()
        global max_step
        if max_t > max_step:
            max_step = max_t
        box = QtGui.QPixmap(os.getcwd() + '/Img/Box.png')
        empty = QtGui.QPixmap(os.getcwd() + '/Img/Empty.png')
        guy = QtGui.QPixmap(os.getcwd() + '/Img/Guy.png')
        wall = QtGui.QPixmap(os.getcwd() + '/Img/Wall.png')
        target = QtGui.QPixmap(os.getcwd() + '/Img/Target.png')
        if step_index == 0:
            label_list = []
            for x in range(len(mapping)):
                for y in range(len(mapping[x])):
                    if mapping[x][y]:
                        help_label = QtWidgets.QLabel(widget)
                        help_label.setPixmap(empty)
                        label_list += [help_label]
                        grid.addWidget(help_label, x, y)
                    else:
                        help_label = QtWidgets.QLabel(widget)
                        help_label.setPixmap(wall)
                        label_list += [help_label]
                        grid.addWidget(help_label, x, y)
            for x in boxes:
                help_label = QtWidgets.QLabel(widget)
                help_label.setPixmap(box)
                label_list += [help_label]
                grid.addWidget(help_label, x[1] - 1, x[0] - 1)
            for x in targets:
                help_label = QtWidgets.QLabel(widget)
                help_label.setPixmap(target)
                label_list += [help_label]
                grid.addWidget(help_label, x[1] - 1, x[0] - 1)
            help_label = QtWidgets.QLabel(widget)
            help_label.setPixmap(guy)
            label_list += [help_label]
            grid.addWidget(help_label, player[1] - 1, player[0] - 1)
        else:
            label_list = []
            for x in range(len(mapping)):
                for y in range(len(mapping[x])):
                    if mapping[x][y]:
                        help_label = QtWidgets.QLabel(widget)
                        help_label.setPixmap(empty)
                        label_list += [help_label]
                        grid.addWidget(help_label, x, y)
                    else:
                        help_label = QtWidgets.QLabel(widget)
                        help_label.setPixmap(wall)
                        label_list += [help_label]
                        grid.addWidget(help_label, x, y)
            help_label = QtWidgets.QLabel(widget)
            help_label.setPixmap(guy)
            label_list += [help_label]
            grid.addWidget(help_label, at_list[0][step_index][1] - 1, at_list[0][step_index][0] - 1)
            for at in at_list[1:]:
                help_label = QtWidgets.QLabel(widget)
                help_label.setPixmap(box)
                label_list += [help_label]
                grid.addWidget(help_label, at[step_index][1] - 1, at[step_index][0] - 1)
            for x in targets:
                help_label = QtWidgets.QLabel(widget)
                help_label.setPixmap(target)
                label_list += [help_label]
                grid.addWidget(help_label, x[1] - 1, x[0] - 1)
        print("redrawing")


a = Visualizer()
