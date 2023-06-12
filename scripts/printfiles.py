'''Given git ls-files output, print a tree-like structure of the files and folders'''
import fileinput

prev_parts = []
for line in fileinput.input():
    parts = line.strip().split('/')
    for i, curr_part in enumerate(parts):
        if len(prev_parts) > i and prev_parts[i] == curr_part:
            parts[i] = ' ' * len(curr_part)
        else:
            break
    prev_parts = line.strip().split('/')
    print(' | '.join(parts))  # noqa: T201 This code is MEANT to print output :-)
