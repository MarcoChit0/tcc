import os

# receive the path of the board, whose format is the following:
# R, C
# grid
# where R and C are the number of rows and columns of the grid, respectively, and grid is a RxC matrix with the following elements:
# 'W' -> wall
# 'P' -> player
# 'B' -> stone
# 'G' -> goal
# 'S' -> slippery floor
# ' ' -> empty
# '1' -> player on goal
# '!' -> stone on goal
# '~' -> player on slippery floor
# '' -> stone on slippery floor
# '^' -> goal on slippery floor
# The output is a PDDL instance file.
# A bord example is the following:
# 5,7
# #######
# #    ##
# # @$. #
# #    ##
# #######

board_path = "res/benchmarks/sokoban/boards/"
instance_path = board_path.replace("boards/", "")

for instance_file in os.listdir(board_path):
    
    instance = instance_file.split(".")[0]

    with open(os.path.join(board_path, instance_file)) as file:
        row, column = map(int, file.readline().split(","))
        grid = [list(file.readline().strip()) for _ in range(row)]

    grid_elements = {
        'wall': '#',
        'player': '@',
        'stone': '$',
        'goal': '.',
        'empty': ' ',
        'player_on_goal': '+',
        'stone_on_goal': '*'
    }

    elements_map = {}
    for key, value in grid_elements.items():
        elements_map[value] = key

    # (dr, dc)
    directions = {
        'up': (-1, 0),
        'down': (1, 0),
        'left': (0, -1),
        'right': (0, 1),
    }

    object_predicates = ["r{}c{} - location".format(i, j) for i in range(row) for j in range(column)] + ["{} - direction".format(dir) for dir in directions.keys()]
    initial_predicates = []
    goal_predicates = []

    def is_good_move(i, j, dir, grid):
        if grid[i][j] == grid_elements['wall']:
            return False
        
        r, c = directions[dir][0] + i, directions[dir][1] + j

        if 0 <= r < row and 0 <= c < column:
            return True if not grid[r][c] == grid_elements['wall'] else False
        else:
            return False

    def apply_movements(i, j, grid):
        predicates = []
        for dir, (di, dj) in directions.items():
            if is_good_move(i, j, dir, grid):
                nr, nc = i + di, j + dj
                predicates.append(f"(move-dir r{i}c{j} r{nr}c{nc} {dir})")
        return predicates

    for i in range(row):
        for j in range(column):
            # initial_predicates.append(f"\n;; position r{i}c{j} is \'{elements_map[grid[i][j]]}\'")
            if grid[i][j] == grid_elements['goal']:
                initial_predicates.append(f"(is-goal r{i}c{j})")
                initial_predicates.append(f"(is-clear r{i}c{j})")
                initial_predicates.extend(apply_movements(i, j, grid))
                goal_predicates.append(f"(at-goal r{i}c{j})")
            elif grid[i][j] == grid_elements['empty']:
                initial_predicates.append(f"(is-clear r{i}c{j})")
                initial_predicates.extend(apply_movements(i, j, grid))
            elif grid[i][j] == grid_elements['player']:
                initial_predicates.append(f"(player-at r{i}c{j})")
                initial_predicates.extend(apply_movements(i, j, grid))
            elif grid[i][j] == grid_elements['stone']:
                initial_predicates.append(f"(stone-at r{i}c{j})")
                initial_predicates.extend(apply_movements(i, j, grid))
            elif grid[i][j] == grid_elements['player_on_goal']:
                initial_predicates.append(f"(is-goal r{i}c{j})")
                initial_predicates.append(f"(player-at r{i}c{j})")
                initial_predicates.extend(apply_movements(i, j, grid))
            elif grid[i][j] == grid_elements['stone_on_goal']:
                initial_predicates.append(f"(is-goal r{i}c{j})")
                initial_predicates.append(f"(stone-at r{i}c{j})")
                initial_predicates.append(f"(at-goal r{i}c{j})")
                initial_predicates.extend(apply_movements(i, j, grid))

    with open(os.path.join(instance_path, f"{instance}.pddl"), "w") as file:
        file.write(f'(define (problem {instance}-sokoban-non-deterministic)\n')
        file.write(f'\t(:domain sokoban-non-deterministic)\n')
        file.write(f'\t(:objects\n')
        for predicate in object_predicates:
            file.write(f'\t\t{predicate}\n')
        file.write('\n\t)')
        file.write('\n\t(:init\n')
        for predicate in initial_predicates:
            file.write(f'\t\t{predicate}\n')
        file.write('\n\t)')
        file.write('\n\t(:goal\n')
        file.write('\t\t(and\n')
        for predicate in goal_predicates:
            file.write(f'\t\t\t{predicate}\n')
        file.write('\t\t)\n')
        file.write('\t)\n')
        file.write(')\n')