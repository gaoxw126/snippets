#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
An utility to replace include guard in c++ header with pragma once
"""

import re
import os

cpp_header_pattern = re.compile("^[\w]+\.h$")
hidden_dir_pattern = re.compile("^\.[\w]+$")


def is_hidden_dir(path):
    return hidden_dir_pattern.match(path) is not None


def replace_include_guard_with_pragma_once(curDir):
    for path in os.listdir(curDir):
        if os.path.isdir(path):
            if not is_hidden_dir(path):  # ignore hiden directory
                # print path
                path = curDir + "/" + path
                replace_include_guard_with_pragma_once(path)
        else:  # is a file
            if cpp_header_pattern.match(path) is not None:  # is a cpp header
                path = curDir + "/" + path
                print path
                cpp = open(path, "r")
                newcpp = use_pragma_once_internal(cpp)
                cpp.close()
                cpp = open(path, "w")
                cpp.write(newcpp)
                cpp.close()


include_guard_pattern = "\w+"
endif_pattern = re.compile("^#endif\s*\/\/\s*(" + include_guard_pattern + ")\s*$")
define_pattern = re.compile("^#define\s+(" + include_guard_pattern + ")\s*$")
ifndef_pattern = re.compile("^#ifndef\s+(" + include_guard_pattern + ")\s*$")

empty_pattern = re.compile("^\s*$")

# Comments in '//', before which there're no other statements.
comment1_pattern = re.compile("^\s*\/\/.*$")

# Comments in '/**/', before which there're no other statements.
comment2_start_pattern = re.compile("^\s*\/\*.*$")
comment2_end_pattern = re.compile("^.*\*\/$")


# The function will ignore multiple lines of comments, until it finds
# an include guard statement, which is in the form of
# #ifndef INCLUDE_GUARD
# #define INCLUDE_GUARD
#
# To avoid deleting irrelevant macros incorrectly, the function will
# find the last #endif statement, and checks if it is followed by a comment
# in the form of
# #endif // INCLUDE_GUARD
# If not, it will do nothing on this file.
#
# By default, use_pragma_once_internal allows any formats of a macro to
# represents an include guard. To customize the format of include guard,
# make changes to include_guard_pattern.
#
def use_pragma_once_internal(cpp):
    newcpp = ""
    lines = cpp.readlines()

    # ignore continuous lines of comments and empty lines
    i = -1
    while i < len(lines):
        i += 1
        line = lines[i]
        if empty_pattern.match(line):
            newcpp += line
            continue
        if comment1_pattern.match(line):
            newcpp += line
            continue
        if comment2_start_pattern.match(line):
            while i < len(lines):
                comment = lines[i]
                newcpp += comment
                if comment2_end_pattern.match(comment):
                    break
                i += 1
            continue
        break

    include_guard = ""
    m1 = ifndef_pattern.match(lines[i])
    if m1:
        include_guard = m1.group(1)
        m2 = define_pattern.match(lines[i + 1])
        if m2 and m2.group(1) == include_guard:
            newcpp += "#pragma once\n"
            i += 2

    # find the last endif
    for i in range(i, len(lines)):
        line = lines[i]
        m3 = endif_pattern.match(line)
        if m3 and m3.group(1) == include_guard:
            break
        newcpp += line

    # copy the remainder to newcpp
    for i, line in range(i + 1, len(lines)):
        newcpp += line

    return newcpp


if __name__ == '__main__':
    replace_include_guard_with_pragma_once(os.getcwd())
