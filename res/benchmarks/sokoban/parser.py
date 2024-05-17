import os

# receive the path of the board, whose format is the following:
# R, C
# grid
# where R and C are the number of rows and columns of the grid, respectively, and grid is a RxC matrix with the following elements:
# '#' -> wall
# ' ' -> empty
# '*' -> goal
# '~' -> slipper floor
# '.' -> goal on slipper floor
# '0' -> player
# '1' -> box
# '2' -> boots
# '3' -> player on slipper floor
# '4' -> box on slipper floor
# '5' -> boots on slipper floor
# '6' -> player on goal
# '7' -> box on goal
# '8' -> boots on goal
# '9' -> player on goal on slipper floor
# 'A' -> box on goal on slipper floor
# 'B' -> boots on goal on slipper floor
# 'C' -> player with boots
# 'D' -> player with boots on slipper floor
# 'E' -> player with boots on goal
# 'F' -> player with boots on goal on slipper floor


def write_instance(domain, instance_path, instance, object_predicates, initial_predicates, goal_predicates, parser_input=None):
    with open(os.path.join(instance_path, f"{instance}.pddl"), "w") as file:
        if parser_input is not None:
            for p_input in parser_input:
                file.write(f";;\t{p_input}\n")
        file.write(f'(define (problem {instance}-{domain})\n')
        file.write(f'\t(:domain {domain})\n')
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

def is_good_move(i, j, dir):
    r, c = directions[dir][0] + i, directions[dir][1] + j
    if 0 <= r < row and 0 <= c < column:
        return True
    else:
        return False
    
def apply_movements(i, j):
    predicates = []
    for dir, (di, dj) in directions.items():
        if is_good_move(i, j, dir):
            nr, nc = i + di, j + dj
            predicates.append(f"(move-dir r{i}c{j} r{nr}c{nc} {dir})")
    return predicates

if __name__ == "__main__":
    board_path = "res/benchmarks/sokoban/boards/"
    instance_path = board_path.replace("boards/", "")
    for instance_file in os.listdir(board_path):
        
        instance = instance_file.split(".")[0]

        with open(os.path.join(board_path, instance_file)) as file:
            row, column = map(int, file.readline().split(","))
            grid = [list(file.readline().strip()) for _ in range(row)]

        grid_elements = {
            'wall': '#',
            'empty': ' ',
            'goal': '*',
            'slipper_floor': '~',
            'goal_on_slipper_floor': '.',
            'player': '0',
            'box': '1',
            'boots': '2',
            'player_on_slipper_floor': '3',
            'box_on_slipper_floor': '4',
            'boots_on_slipper_floor': '5',
            'player_on_goal': '6',
            'box_on_goal': '7',
            'boots_on_goal': '8',
            'player_on_goal_on_slipper_floor': '9',
            'box_on_goal_on_slipper_floor': 'A',
            'boots_on_goal_on_slipper_floor': 'B',
            'player_with_boots': 'C',
            'player_with_boots_on_slipper_floor': 'D',
            'player_with_boots_on_goal': 'E',
            'player_with_boots_on_goal_on_slipper_floor': 'F'
        }

        player_values = [value for key, value in grid_elements.items() if "player" in key]
        box_values = [value for key, value in grid_elements.items() if "box" in key]
        boots_values = [value for key, value in grid_elements.items() if "boots" in key]
        goal_values = [value for key, value in grid_elements.items() if "goal" in key]
        slippery_values = [value for key, value in grid_elements.items() if "slipper" in key]

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
        box_counter = 0

        for i in range(row):
            for j in range(column):
                # debug only
                initial_predicates.append(f"\n")
                initial_predicates.append(f";; r{i}c{j} - {elements_map[grid[i][j]]}")
                
                # clear locations
                if grid[i][j] in [grid_elements['goal'], grid_elements['empty'], grid_elements['slipper_floor'], grid_elements['goal_on_slipper_floor']]:
                    initial_predicates.append(f"(is-clear r{i}c{j})")
                    
                # player with boots
                if grid[i][j] in [grid_elements['player_with_boots'], grid_elements['player_with_boots_on_slipper_floor'], grid_elements['player_with_boots_on_goal'], grid_elements['player_with_boots_on_goal_on_slipper_floor']]:
                    initial_predicates.append(f"(using-non-slippery-boots)")

                if grid[i][j] in player_values:
                    initial_predicates.append(f"(player-at r{i}c{j})")
                    initial_predicates.append(f"(alive)")
                
                if grid[i][j] in box_values:
                    initial_predicates.append(f"(box-at box_{box_counter} r{i}c{j})")
                    goal_predicates.append(f"(at-goal box_{box_counter})")
                    box_counter += 1
                
                if grid[i][j] in boots_values:
                    initial_predicates.append(f"(boots-at r{i}c{j})")

                if grid[i][j] in slippery_values:
                    initial_predicates.append(f"(is-slippery r{i}c{j})")

                if grid[i][j] in goal_values:
                    initial_predicates.append(f"(is-goal r{i}c{j})")

                if grid[i][j] == grid_elements['wall']:
                    initial_predicates.append(f"(not (is-clear r{i}c{j}))")

                initial_predicates.extend(apply_movements(i, j))

        for i in range(box_counter):
            object_predicates.append(f"box_{i} - box")
    
        parser_input = []
        for i in range(row):
            s = ''
            for j in range(column):
                s += grid[i][j]
            parser_input.append(s)
        write_instance("sokoban-non-deterministic", instance_path, instance, object_predicates, initial_predicates, goal_predicates)
