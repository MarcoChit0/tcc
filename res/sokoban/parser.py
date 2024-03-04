import os

from matplotlib.pyplot import box


num_players = 0
num_walls = 0
num_boxes = 0
num_goals = 0

board_path = "res/sokoban/board_p1.txt"
with open(board_path) as file:
    row, column = map(int, file.readline().split(","))
    grid = [list(file.readline().strip()) for _ in range(row)]

grid_elements = {
    'wall': '#',
    'player': '@',
    'box': '$',
    'goal': '.',
    'empty': ' ',
}

directions = {
    'up': (-1, 0),
    'down': (1, 0),
    'left': (0, -1),
    'right': (0, 1),
}

class Key:
    def __init__(self, row, column):
        self.row = row
        self.column = column
        self.id = f'r{row}c{column}'
        self.count = None
        self.type = self.__class__.__name__.lower()
        self.adj_walls = set()
        self.possible_movements = set()

    def found_wall_on(self, dir):
        if dir == 'up':
            self.adj_walls.add('down')
        elif dir == 'down':
            self.adj_walls.add('up')
        elif dir == 'left':
            self.adj_walls.add('right')
        elif dir == 'right':
            self.adj_walls.add('left')
        else:
            raise ValueError("Invalid direction")
        
    def movement(self, next_obj, dir):
        if not next_obj.type == 'wall':
            self.possible_movements.add((next_obj, dir))


    def object_predicates(self, spacing=''):
        return [
            f"{spacing}({self.id} - location)",
        ]

    def initial_predicates(self, spacing=''):
        return \
        [
            f"{spacing}(is-wall-on {self.id} {dir})" for dir in self.adj_walls
        ] + \
        [
            f"{spacing}(move-dir {self.id} {next_obj.id} {dir})" for next_obj, dir in self.possible_movements
        ] + \
        [
            f"{spacing}(is-nongoal {self.id})",
            f"{spacing}(clear {self.id})",
        ]


class Player(Key):
    def __init__(self, row, column):
        super().__init__(row, column)
        global num_players
        self.count = num_players
        num_players += 1
    
    def object_predicates(self, spacing=''):
        return super().object_predicates(spacing) + [f"{spacing}player-{self.count} - player"]

    def initial_predicates(self, spacing=''):
        return super().initial_predicates(spacing)[0:-1] + [f"{spacing}(at {self.type}-{self.count} {self.id})"]

class Wall(Key):
    def __init__(self, row, column):
        super().__init__(row, column)
        global num_walls
        self.count = num_walls
        num_walls += 1

    def initial_predicates(self, spacing=''):
        return super().initial_predicates(spacing)[0:-1]

class Box(Key):
    def __init__(self, row, column):
        super().__init__(row, column)
        global num_boxes
        self.count = num_boxes
        num_boxes += 1
    
    def initial_predicates(self, spacing=''):
        return super().initial_predicates(spacing)[0:-1] + [f"{spacing}(at {self.type}-{self.count} {self.id})"]

    def object_predicates(self, spacing=''):
        return super().object_predicates(spacing) + [f"{spacing}stone-{self.count} - stone"]

class Goal(Key):
    def __init__(self, row, column):
        super().__init__(row, column)
        global num_goals
        self.count = num_goals
        num_goals += 1

    def initial_predicates(self, spacing=''):
        return [
            f"{spacing}(is-goal {self.id})",
            f"{spacing}(clear {self.id})",
        ]


instance = board_path.split("/")[-1].replace("board_", "").replace(".txt", "")
instance_path = board_path.replace("board_", "").replace(".txt", ".pddl")

walls = set()

def create_correct_class(grid, i, j):
    if grid[i][j] == grid_elements['wall']:
        e = Wall(i, j)
        walls.add(e)
    elif grid[i][j] == grid_elements['player']:
        e = Player(i, j)
    elif grid[i][j] == grid_elements['box']:
        e = Box(i, j)
    elif grid[i][j] == grid_elements['goal']:
        e = Goal(i, j)
    elif grid[i][j] == grid_elements['empty']:
        e = Key(i, j)
    else:
        raise ValueError(f"Invalid element {grid[i][j]}")
    return e

obj_grid = [[create_correct_class(grid, i, j) for j in range(column)] for i in range(row)]

for i in range(row):
    for j in range(column):
        for dir in directions.keys():
            r, c = i + directions[dir][0], j + directions[dir][1]
            if 0 <= r < row and 0 <= c < column:
                if type(obj_grid[i][j]) is not Wall:
                    obj_grid[i][j].movement(obj_grid[r][c], dir)
                else:
                    if type(obj_grid[r][c]) is not Wall:
                        obj_grid[r][c].found_wall_on(dir)

for i in range(row):
    for j in range(column):
        if type(obj_grid[i][j]) is not Wall:
            for dir in directions.keys():
                r, c = i + directions[dir][0], j + directions[dir][1]
                if 0 <= r < row and 0 <= c < column and type(obj_grid[r][c]) is Wall:
                    obj_grid[i][j].found_wall_on(dir)
                
with open(instance_path, "w") as file:
    file.write(f'(define (problem {instance}-sokoban-non-deterministic)\n')
    file.write(f'\t(:domain sokoban-non-deterministic)\n')
    file.write(f'\t(:objects\n')
    for i in range(row):
        for j in range(column):
            for predicate in obj_grid[i][j].object_predicates('\t\t'):
                file.write(f'{predicate}\n')
                
    for dir in directions.keys():
        file.write(f'\t\t{dir} - direction\n')

    file.write('\n\t)')
    file.write('\n\t(:init\n')
    # print all init predicates
    for i in range(row):
        for j in range(column):
            for predicate in obj_grid[i][j].initial_predicates('\t\t'):
                file.write(f'{predicate}\n')
    file.write('\n\t)')
    file.write('\n)')
