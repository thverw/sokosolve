from math import floor, sqrt
from itertools import chain
from copy import deepcopy


# coding=utf-8
def main(dim_x, dim_y, box_number):
    level_index = 0
    fields = []
    for i in range(0, dim_x):
        x = []
        for j in range(0, dim_y):
            x += [False]
        fields += [x]
    list_of_basic_levels = [fields]
    # try to make ALL the levels
    # the way it's done here is by creating the base of only walls ([[False,False,..],[False,..],..]) and
    # changing it in all possible ways (given by the get_options 1-4)
    while len(list_of_basic_levels) > 0:
        this_level = list_of_basic_levels[0]
        list_of_basic_levels = list_of_basic_levels[1:]
        # place fields
        if count_fields(this_level) < (dim_x * dim_y * 3 / 4):
            if count_fields(this_level) < (floor(dim_x * dim_y * 4 / 10)):
                the_blocks = get2x2options(dim_x, dim_y, this_level)
                for block in the_blocks:
                    list_of_basic_levels += [make2x2block(block[0], block[1], this_level)]
            else:
                # get all options into one big list
                for option in chain(get_options1(dim_x, dim_y, this_level), get_options2(dim_x, dim_y, this_level),
                                    get_options3(dim_x, dim_y, this_level), get_options4(dim_x, dim_y, this_level)):
                    list_of_basic_levels += [change_fields_by(this_level, option)]
        # place boxes and targets
        else:
            boxes_placed = 0
            targets_placed = 0
            list_of_levels_w_boxes = [this_level]
            # index 0 is player, 1 is box, 2 is target, 3 is player-target, 4 is box-target
            # TODO the program places only one box regardless of the given box_number -- FIX THAT
            while boxes_placed < box_number:
                my_iterator_list = deepcopy(list_of_levels_w_boxes)
                list_of_levels_w_boxes = []
                for my_list_ele in my_iterator_list:
                    box_options = get_box_options(dim_x, dim_y, my_list_ele)
                    for opts in box_options:
                        list_of_levels_w_boxes += [change_fields_to_index(my_list_ele, opts, 1)]
                boxes_placed += 1
            list_of_levels_w_player = []
            for levels in list_of_levels_w_boxes:
                for player_options in get_player_options(dim_x, dim_y, levels):
                    list_of_levels_w_player += [change_fields_to_index(levels, player_options, 0)]
            list_of_levels_w_targets = list_of_levels_w_player
            while targets_placed < box_number:
                my_other_iterator_list = deepcopy(list_of_levels_w_targets)
                list_of_levels_w_targets = []
                for my_list_ele in my_other_iterator_list:
                    target_options = get_target_options(dim_x, dim_y, my_list_ele)
                    for opts in target_options:
                        if type(my_list_ele[opts[0]][opts[1]]) == int and my_list_ele[opts[0]][opts[1]] == 0:
                            list_of_levels_w_targets += [change_fields_to_index(my_list_ele, opts, 3)]
                        elif type(my_list_ele[opts[0]][opts[1]]) == int and my_list_ele[opts[0]][opts[1]] == 1:
                            list_of_levels_w_targets += [change_fields_to_index(my_list_ele, opts, 4)]
                        else:
                            list_of_levels_w_targets += [change_fields_to_index(my_list_ele, opts, 2)]
                targets_placed += 1
            f = open("levels/level_list.txt", "w")
            for lvl in list_of_levels_w_targets:
                print(level_index.__str__())
                if level_index < 1000000:
                    fields_to_text(f, dim_x, dim_y, lvl, level_index)
                else:
                    print "quitting here"
                    quit()
                level_index += 1


def change_fields_to_index(fields, position, index):
    my_fields = deepcopy(fields)
    my_fields[position[0]][position[1]] = index
    return my_fields


def make2x2block(init_x, init_y, fields):
    my_fields = deepcopy(fields)
    my_fields[init_x][init_y] = True
    my_fields[init_x + 1][init_y] = True
    my_fields[init_x][init_y + 1] = True
    my_fields[init_x + 1][init_y + 1] = True
    return my_fields


def change_fields_by(fields, changelist):
    my_fields = deepcopy(fields)
    for field_change in changelist:
        my_fields[field_change[0]][field_change[1]] = True
    return my_fields


def get_options1(dim_x, dim_y, fields):
    go1_list = get2x2blocks(dim_x, dim_y, fields)
    for i in range(0, len(go1_list)):
        go1_list[i] = [go1_list[i][0], go1_list[i][1], True, True]
        # check left border
        if go1_list[i][0] == 0:
            go1_list[i][2] = False
        # check right border
        if go1_list[i][0] == dim_x - 2:
            go1_list[i][3] = False
        if [go1_list[i][0] - 1, go1_list[i][1]] in get2x2blocks(dim_x, dim_y, fields):
            go1_list[i][2] = False
        if [go1_list[i][0] + 1, go1_list[i][1]] in get2x2blocks(dim_x, dim_y, fields):
            go1_list[i][3] = False
    for ele in go1_list:
        if ele[2]:
            yield [[ele[0] - 1, ele[1]], [ele[0] - 1, ele[1] + 1]]
        if ele[3]:
            yield [[ele[0] + 2, ele[1]], [ele[0] + 2, ele[1] + 1]]


def get_options2(dim_x, dim_y, fields):
    go2_list = get2x2blocks(dim_x, dim_y, fields)
    for i in range(0, len(go2_list)):
        go2_list[i] = [go2_list[i][0], go2_list[i][1], True, True]
        # check upper border
        if go2_list[i][1] == 0:
            go2_list[i][2] = False
        # check lower border
        if go2_list[i][1] == dim_y - 2:
            go2_list[i][3] = False
        if [go2_list[i][0], go2_list[i][1] - 1] in get2x2blocks(dim_x, dim_y, fields):
            go2_list[i][2] = False
        if [go2_list[i][0], go2_list[i][1] + 1] in get2x2blocks(dim_x, dim_y, fields):
            go2_list[i][3] = False
    for ele in go2_list:
        if ele[2]:
            yield [[ele[0], ele[1] - 1], [ele[0] + 1, ele[1] - 1]]
        if ele[3]:
            yield [[ele[0], ele[1] + 2], [ele[0] + 1, ele[1] + 2]]


def get_options3(dim_x, dim_y, fields):
    go3_list = get2x2blocks(dim_x, dim_y, fields)
    for i in range(0, len(go3_list)):
        go3_list[i] += [(not [go3_list[i][0] - 1, go3_list[i][1] - 1] in go3_list)
                        and (not go3_list[i][0] == 0 and not go3_list[i][1] == 0)]  # top left
        go3_list[i] += [(not [go3_list[i][0] + 1, go3_list[i][1] - 1] in go3_list)
                        and (not go3_list[i][0] == dim_x - 2 and not go3_list[i][1] == 0)]  # top right
        go3_list[i] += [(not [go3_list[i][0] - 1, go3_list[i][1] + 1] in go3_list)
                        and (not go3_list[i][0] == 0 and not go3_list[i][1] == dim_y - 2)]  # bottom left
        go3_list[i] += [(not [go3_list[i][0] + 1, go3_list[i][1] + 1] in go3_list)
                        and (not go3_list[i][0] == dim_x - 2 and not go3_list[i][1] == dim_y - 2)]  # bottom right
    for ele in go3_list:
        if ele[2]:
            yield [[ele[0] - 1, ele[1] - 1], [ele[0] - 1, ele[1]], [ele[0], ele[1] - 1]]
        if ele[3]:
            yield [[ele[0] + 2, ele[1]], [ele[0] + 1, ele[1] - 1], [ele[0] + 2, ele[1] - 1]]
        if ele[4]:
            yield [[ele[0] - 1, ele[1] + 2], [ele[0] - 1, ele[1] + 1], [ele[0], ele[1] + 2]]
        if ele[5]:
            yield [[ele[0] + 1, ele[1] + 2], [ele[0] + 2, ele[1] + 1], [ele[0] + 2, ele[1] + 2]]


def get_options4(dim_x, dim_y, fields):
    edgeblocks = find_edgeblocks(dim_x, dim_y, fields)
    fields_to_use = []
    for i in range(0, dim_x):
        for j in range(0, dim_y):
            if not fields[i][j] and not [i, j] in edgeblocks:
                fields_to_use += [[i, j]]
    for start_index in range(0, len(edgeblocks)):
        for end_index in range(start_index + 1, len(edgeblocks)):
            start = edgeblocks[start_index]
            end = edgeblocks[end_index]
            # option_list is a list of ways with the corresponding options to advance
            option_list = []
            for k in fields_to_use:
                if is_adjacent(k, start):
                    option_list += [[start, k]]
            while len(option_list) > 0:
                this_way = option_list[0]
                ways_end = this_way[len(this_way) - 1]
                option_list = option_list[1:]
                if is_adjacent(ways_end, end):
                    this_way += [end]
                    yield this_way
                else:
                    new_options = []
                    for l in fields_to_use:
                        if is_adjacent(l, ways_end) and l not in this_way:
                            marker = True
                            for m in range(0, len(this_way) - 2):
                                if is_adjacent(this_way[m], l):
                                    marker = False
                            if marker:
                                new_options += [l]
                    for n in new_options:
                        option_list += [this_way + [n]]


def find_edgeblocks(dim_x, dim_y, fields):
    edgeblocks = []
    for i in range(0, dim_x):
        for j in range(0, dim_y):
            if not fields[i][j] and ((i < dim_x - 1 and fields[i + 1][j]) or (i > 1 and fields[i - 1][j])
                                     or (j > 1 and fields[i][j - 1]) or j < dim_y - 1 and fields[i][j + 1]):
                edgeblocks += [[i, j]]
    return edgeblocks


def is_adjacent(field_one, field_two):
    if (field_one[0] == field_two[0] and (field_one[1] == field_two[1] + 1 or field_one[1] == field_two[1] - 1)) \
            or (field_one[1] == field_two[1] and (
                    field_one[0] == field_two[0] + 1 or field_one[0] == field_two[0] - 1)):
        return True
    return False


def get2x2blocks(dim_x, dim_y, fields):
    result = []
    for i in range(0, dim_x - 1):
        for j in range(0, dim_y - 1):
            if fields[i][j] and fields[i][j + 1] and fields[i + 1][j] and fields[i + 1][j + 1]:
                result += [[i, j]]
    return result


def get2x2options(dim_x, dim_y, fields):
    result = []
    for i in range(0, dim_x - 1):
        for j in range(0, dim_y - 1):
            if not (fields[i][j] or fields[i][j + 1] or fields[i + 1][j] or fields[i + 1][j + 1]):
                result += [[i, j]]
    return result


def get_box_options(dim_x, dim_y, fields):
    box_options = []
    for i in range(0, dim_x):
        for j in range(0, dim_y):
            if type(fields[i][j]) == bool and fields[i][j]:
                # one pair of opposite directions must be free
                if ((i < dim_x - 1 and type(fields[i + 1][j]) == bool and fields[i + 1][j])
                        and (i > 0 and type(fields[i - 1][j]) == bool and fields[i - 1][j])) \
                        or ((j < dim_y - 1 and type(fields[i][j + 1]) == bool and fields[i][j + 1])
                        and (j > 0 and type(fields[i][j - 1]) == bool and fields[i][j - 1])):
                    box_options += [[i, j]]
    return box_options


def get_target_options(dim_x, dim_y, fields):
    target_options = []
    for i in range(0, dim_x):
        for j in range(0, dim_y):
            if type(fields[i][j]) == int or fields[i][j]:
                if ((i < dim_x - 1 and (type(fields[i + 1][j]) == int or fields[i + 1][j])) \
                        or (i > 0 and (type(fields[i - 1][j]) == int or fields[i - 1][j]))) \
                        and ((j < dim_y - 1 and (type(fields[i][j + 1]) == int or fields[i][j + 1])) \
                        or (j > 0 and (type(fields[i][j - 1]) == int or fields[i][j - 1]))):
                    target_options += [[i, j]]
    return target_options


def get_player_options(dim_x, dim_y, fields):
    player_options = []
    for i in range(0, dim_x):
        for j in range(0, dim_y):
            if type(fields[i][j]) == bool and fields[i][j]:
                player_options += [[i, j]]
    return player_options


def count_fields(fields):
    result = 0
    for i in fields:
        for j in i:
            if type(j) != bool or j:
                result += 1
    return result


def count_boxes(fields):
    result = 0
    for i in fields:
        for j in i:
            if type(j) != bool and (j == 1 or j == 4):
                result += 1
    return result


def fields_to_text(f, dim_x, dim_y, fields, level_index):
    # f = open("levels/level" + level_index.__str__() + ".txt", "w")
    f.write("\n\n\nLevel #" + level_index.__str__())
    level_string = level_characteristics_to_str(dim_x, dim_y, fields)
    finish_string = ""
    box_ind = 1
    for i in range(0, len(fields)):
        line_string = ""
        for j in range(0, len(fields[i])):
            if type(fields[i][j]) != bool or fields[i][j]:
                if line_string == "":
                    line_string += (j + 1).__str__()
                else:
                    line_string += ";" + (j + 1).__str__()
            if type(fields[i][j]) == int:
                # index 0 is player, 1 is box, 2 is target, 3 is player-target, 4 is box-target
                if fields[i][j] == 0:
                    finish_string += "init(at(0," + (i + 1).__str__() + "," + (j + 1).__str__() + ")).\n"
                elif fields[i][j] == 1:
                    box_str = box_ind.__str__()
                    finish_string += "init(at(" + box_str + "," + (i + 1).__str__() + "," + (j + 1).__str__() + ")).\n"
                    box_ind += 1
                elif fields[i][j] == 2:
                    finish_string += "init(target(" + (i + 1).__str__() + "," + (j + 1).__str__() + ")).\n"
                elif fields[i][j] == 3:
                    finish_string += "init(at(0," + (i + 1).__str__() + "," + (j + 1).__str__() + ")).\n"
                    finish_string += "init(target(" + (i + 1).__str__() + "," + (j + 1).__str__() + ")).\n"
                elif fields[i][j] == 4:
                    box_str = box_ind.__str__()
                    finish_string += "init(at(" + box_str + "," + (i + 1).__str__() + "," + (j + 1).__str__() + ")).\n"
                    box_ind += 1
                    finish_string += "init(target(" + (i + 1).__str__() + "," + (j + 1).__str__() + ")).\n"
        if line_string != "":
            level_string += "init(field(" + line_string + "," + (i + 1).__str__() + ")).\n"
    level_string += finish_string
    level_string += fields.__str__()
    f.write(level_string)


def average_number_of_neighbors(dim_x, dim_y, fields):
    total_neighbors = 0
    for i in range(0, dim_x):
        for j in range(0, dim_y):
            if type(fields[i][j]) != bool or fields[i][j]:
                if i > 0 and (type(fields[i - 1][j]) != bool or fields[i - 1][j]):
                    total_neighbors += 1
                if i < dim_x - 1 and (type(fields[i + 1][j]) != bool or fields[i + 1][j]):
                    total_neighbors += 1
                if j > 0 and (type(fields[i][j - 1]) != bool or fields[i][j - 1]):
                    total_neighbors += 1
                if j < dim_y - 1 and (type(fields[i][j + 1]) != bool or fields[i][j + 1]):
                    total_neighbors += 1
    return float(total_neighbors) / float(dim_x * dim_y)


def asd():
    pass


# def average_distance_box_closest_target(dim_x, dim_y, box_number, fields):
# TODO hard problem with a big workaround -- maybe think of sth else
# result = 0.0
# boxes = []
#     targets = []
#     for i in range(0, dim_x):
#         for j in range(0, dim_y):
#             if type(fields[i][j]) == int:
#                 if fields[i][j] == 1:
#                     boxes += [[i, j]]
#                 elif fields[i][j] == 2 or fields[i][j] == 3:
#                     targets += [[i, j]]
#                elif fields[i][j] == 4:
#                     boxes += [[i, j]]
#                     targets += [[i, j]]
#     while len(boxes) > 0:
#         box = boxes[0]
#         boxes = boxes[1:]
#         distances = []
#         for target in targets:
#             distances += [sqrt((box[0] - target[0]) ** 2 + (box[1] - target[1]) ** 2)]
#         min_value = dim_x * dim_y
#         min_index = -1
#         for i in range(0, len(distances)):
#             if distances[i] < min_value:
#                 min_index = i
#                 min_value = distances[i]
#         result += min_value
#     return result


def level_characteristics_to_str(dim_x, dim_y, fields):
    characteristics_str = "%% Dimensions: " + dim_x.__str__() + ", " + dim_y.__str__() + "\n"
    count = count_fields(fields)
    characteristics_str += "%% Fields/Walls: " + count.__str__() + " : " + (dim_x * dim_y - count).__str__() + "\n"
    characteristics_str += "%% Number of Neighbors/Square: "
    characteristics_str += average_number_of_neighbors(dim_x, dim_y, fields).__str__() + "\n"
    characteristics_str += "%% Number of Boxes and Targets: " + count_boxes(fields).__str__() + "\n"
    # characteristics_str += "%% Avg Distance between Boxes and Targets: "
    # characteristics_str += average_distance_box_closest_target(dim_x, dim_y, i, fields).__str__() + "\n"
    return characteristics_str


main(5, 5, 2)
