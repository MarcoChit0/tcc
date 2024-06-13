from email.mime import base
import sys
import faulthandler
from enum import Enum

from matplotlib.font_manager import json_dump
faulthandler.enable()
import os
from xml.etree.ElementInclude import include
import tap
import argcomplete
import subprocess
import resource
import fcntl
import time
import datetime
import random
import dataclasses
import re
from queue import Queue
from typing import Generator, Callable
from threading import Thread, Lock, Semaphore
import logging
import json

logging.basicConfig(
    filename='logs/backtrace.log', 
    filemode='w',
    format='%(asctime)s %(levelname)s: %(message)s',
    level=logging.INFO)

class TerminalColor:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

class DeadEndProgramFlow(Enum):
    GENERATE_LABELS_AND_END_PROGRAM = '0'
    GENERATE_LABELS_AND_CONTINUE_PROGRAM = '1'
    LOAD_LABELS_AND_CONTINUE_PROGRAM = '2'

class ArgParsingNamespace(tap.Tap):
    number_of_threads: int
    time_limit: float
    memory_limit: float
    run_again_if_done: bool
    white_list_file_path: str
    black_list_file_path: str
    save_folder_name_prefix: str
    state_heuristic: str
    policy_heuristic: str
    number_of_samples: str
    length: str
    percentage_fsm: str
    sample_generator: str
    sample_treatment_class: str
    percentage_timer: str
    percentage_time_limit: str
    percentage_memory_limit: str
    walker: str
    concrete_states_generator: str
    regressor: str
    dead_end_detector: str
    dead_end_labels_program_flow: DeadEndProgramFlow
    solver: str
    dead_end_time_limit_for_state_space_creation: int
    cache_enable: bool

    def configure(self) -> None:
        self.add_argument("-n", "--number-of-threads", type=int, default=3)
        self.add_argument("-t", "--time-limit", help="(in minutes)", type=float, default=5)
        self.add_argument("-m", "--memory-limit", help="(in Gb)", type=float, default=64)
        self.add_argument("-ra", "--run-again-if-done", default=False, action='store_true')
        self.add_argument("-wl", "--white-list-file-path", type=str, default='./white-list.txt')
        self.add_argument("-bl", "--black-list-file-path", type=str, default='./black-list.txt')
        self.add_argument("-p", "--save-folder-name-prefix", type=str, default=f'test,v{datetime.date.today().isoformat()}')
        self.add_argument("-sh", "--state-heuristic", type=str, default='star')
        self.add_argument("-ph", "--policy-heuristic", type=str, default='delta-nearest')
        self.add_argument("-ns", "--number-of-samples", type=str, default="100")
        self.add_argument("-l", "--length", type=str, default="facts-over-effects-mean-over-actions-mean")
        self.add_argument("-pfsm", "--percentage-fsm", type=str, default="0.2")
        self.add_argument("-sg", "--sample-generator", type=str, default='fsm')
        self.add_argument("-stc", "--sample-treatment-class", type=str, default='keep')
        self.add_argument("-pt", "--percentage-timer", type=str, default="0.1")
        self.add_argument("-ptl", "--percentage-time-limit", type=str, default="0.7")
        self.add_argument("-pml", "--percentage-memory-limit", type=str, default="0.9")
        self.add_argument("-w", "--walker", type=str, default="stop")
        self.add_argument("-csg", "--concrete-states-generator", type=str, default="all")
        self.add_argument("-r", "--regressor", type=str, default="action-proportionality")
        self.add_argument("-ded", "--dead-end-detector", type=str, default="none")
        self.add_argument("-delpf", "--dead_end_labels_program_flow",choices=list(DeadEndProgramFlow) ,default=DeadEndProgramFlow.GENERATE_LABELS_AND_CONTINUE_PROGRAM, type=DeadEndProgramFlow, help=f"{list(DeadEndProgramFlow)}")
        self.add_argument("-s", "--solver", type=str, default="and-star") # choices in {and-star, weighted-and-star, depth-first-and-star, greedy-and-star}
        self.add_argument("-detl", "--dead-end-time-limit-for-state-space-creation", type=int, default=None)
        self.add_argument("-c", "--cache-enable", default=True, action='store_false')

apn = ArgParsingNamespace()
argcomplete.autocomplete(apn)
apn.parse_args()
basic_dir_structure = f'./misc/data/raw_results/{apn.save_folder_name_prefix}/'

threads_semaphore = Semaphore(apn.number_of_threads)
folder_creation_lock = Lock()
process_creation_lock = Lock()
print_lock = Lock()

def limit_virtual_memory(): resource.setrlimit(resource.RLIMIT_AS, (round(apn.memory_limit * 1000 * 1000 * 1000 / 8), round(apn.memory_limit * 1000 * 1000 * 1000 / 8)))
# def limit_cpu_time(): resource.setrlimit(resource.RLIMIT_CPU, (round(apn.time_limit * 60 ), round(apn.time_limit * 60 )))
def apply_limits(): limit_virtual_memory()

@dataclasses.dataclass()
class TaskInfo:
    domain_label: str
    task_label: str
    domain_file_path: str
    task_file_path: str

class ThreadArguments:
    def __init__(self, task_info: TaskInfo, 
        policy_heuristic: str, 
        state_heuristic: str, 
        number_of_samples: str, 
        length: str, 
        percentage_fsm: str, 
        sample_generator: str, 
        sample_treatment_class: str,
        percentage_timer: str,
        percentage_time_limit: str,
        percentage_memory_limit: str,
        walker: str,
        concrete_states_generator: str,
        regressor: str,
        dead_end_detector: str,
        dead_end_labels_program_flow: DeadEndProgramFlow,
        solver: str,
        dead_end_time_limit_for_state_space_creation: int,
        time_limit: float,
        cache_enable: bool = True
        ):
        global base_dir_structure
        self.task_info = task_info
        self.policy_heuristic = policy_heuristic
        self.state_heuristic = state_heuristic
        self.number_of_samples = number_of_samples
        self.length = length
        self.percentage_fsm = percentage_fsm
        self.sample_generator = sample_generator
        self.sample_treatment_class = sample_treatment_class
        self.percentage_timer = percentage_timer
        self.percentage_time_limit = percentage_time_limit
        self.percentage_memory_limit = percentage_memory_limit
        self.walker = walker
        self.concrete_states_generator = concrete_states_generator
        self.regressor = regressor
        self.dead_end_detector = dead_end_detector
        self.dead_end_labels_program_flow = dead_end_labels_program_flow
        self.task = f'{task_info.domain_label}/{task_info.task_label}'
        self.solver = solver
        self.params = f"{solver},{policy_heuristic},{state_heuristic},{number_of_samples},{length},{percentage_fsm},{sample_generator},{sample_treatment_class},{percentage_timer},{percentage_time_limit},{percentage_memory_limit},{walker},{concrete_states_generator},{regressor},{dead_end_detector}"
        self.save_folder_path = f'{basic_dir_structure}/{self.params}/{self.task}/'
        self.cerr = os.path.join(self.save_folder_path, 'log.txt')
        self.cout = os.path.join(self.save_folder_path, 'results.csv')
        if dead_end_time_limit_for_state_space_creation != None:
            self.dead_end_time_limit_for_state_space_creation = dead_end_time_limit_for_state_space_creation
        else:
            self.dead_end_time_limit_for_state_space_creation = "none"
        self.time_limit = round(time_limit * 60 )
        self.cache_enable = cache_enable

    def get_splitted_command(self) -> list[str]:
        return [
            f'./build/and_star',
            f'{self.task_info.domain_file_path}',
            f'{self.task_info.task_file_path}',
            f'{self.policy_heuristic}',
            f'{self.state_heuristic}',
            f'{self.number_of_samples}',
            f'{self.length}',
            f'{self.percentage_fsm}',
            f'{self.sample_generator}',
            f'{self.sample_treatment_class}',
            f'{self.percentage_timer}',
            f'{self.percentage_time_limit}',
            f'{self.percentage_memory_limit}',
            f'{self.walker}',
            f'{self.concrete_states_generator}',
            f'{self.regressor}',
            f'{self.dead_end_detector}',
            f'{self.dead_end_labels_program_flow.value}',
            f'{self.solver}',
            f'{self.dead_end_time_limit_for_state_space_creation}',
            f'{self.time_limit}',
            f'{int(self.cache_enable)}',
            f'{self.save_folder_path}'
        ]
    
    def to_json(self):
        # Convert the instance attributes to a dictionary
        params_dict = {
            "solver": self.solver,
            "time_limit": self.time_limit,
            "task_info": {
                "domain_label": self.task_info.domain_label,
                "task_label": self.task_info.task_label,
                "domain_file_path": self.task_info.domain_file_path,
                "task_file_path": self.task_info.task_file_path
            },
            "policy_heuristic": self.policy_heuristic,
            "state_heuristic": self.state_heuristic,
            "number_of_samples": self.number_of_samples,
            "length": self.length,
            "percentage_fsm": self.percentage_fsm,
            "sample_generator": self.sample_generator,
            "sample_treatment_class": self.sample_treatment_class,
            "percentage_timer": self.percentage_timer,
            "percentage_time_limit": self.percentage_time_limit,
            "percentage_memory_limit": self.percentage_memory_limit,
            "walker": self.walker,
            "concrete_states_generator": self.concrete_states_generator,
            "regressor": self.regressor,
            "dead_end_detector": self.dead_end_detector,
            "dead_end_labels_program_flow": self.dead_end_labels_program_flow.value,
            "dead_end_time_limit_for_state_space_creation": self.dead_end_time_limit_for_state_space_creation,
            "task": self.task,
            "params": self.params,
            "cache_enable": self.cache_enable,
            "save_folder_path": self.save_folder_path,
        }
        # Convert the dictionary to a JSON string
        return json.dumps(params_dict, indent=4)

def run_thread(thread_arguments: ThreadArguments) -> None:
    global apn, threads_semaphore, folder_creation_lock, process_creation_lock, print_lock, basic_dir_structure

    if os.path.exists(thread_arguments.cout) and not apn.run_again_if_done: threads_semaphore.release(); return

    folder_creation_lock.acquire()
    if not os.path.exists(thread_arguments.save_folder_path): os.makedirs(thread_arguments.save_folder_path)
    folder_creation_lock.release()

    process_creation_lock.acquire(); time.sleep(0.1)
    with open('./misc/data/log.txt', 'a') as log_file: log_file.write(f'{datetime.datetime.now(), (thread_arguments.task_info.domain_label, thread_arguments.task_info.task_label, thread_arguments.policy_heuristic, thread_arguments.state_heuristic, apn.save_folder_name_prefix)}\n')

    # for debugging purposes only:
    # print(" ".join(thread_arguments.get_splitted_command()))
    # exit(1)
    process = subprocess.Popen(thread_arguments.get_splitted_command(), stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, preexec_fn=apply_limits, text=True)
    process_creation_lock.release()

    # process._sigint_wait_secs = 0
    try:
        stdout, stderr = process.communicate(timeout=apn.time_limit * 60)
    except subprocess.TimeoutExpired:
        # give some time to terminate procedure
        process.terminate(); time.sleep(0.25)
        # kill the process
        process.kill()
        stdout, stderr = process.communicate()
        stderr += f"\n\nTime limit has been reached. The process has been killed.\n"

    print_lock.acquire(); time.sleep(0.1)
    print(thread_arguments.to_json())
    open(thread_arguments.cout, "w").write(stdout)
    open(thread_arguments.cerr, "w").write(stderr)
    print_lock.release()

    threads_semaphore.release()

def get_is_in_white_list() -> Callable[[str], bool]:
    global apn
    try:
        white_list = set(open(apn.white_list_file_path).read().split('\n'))
        return white_list.__contains__
    except FileNotFoundError:
        return lambda _: True

def get_is_in_black_list() -> Callable[[str], bool]:
    global apn
    try:
        black_list = set(open(apn.black_list_file_path).read().split('\n'))
        return black_list.__contains__
    except FileNotFoundError:
        return lambda _: False

def get_tasks_infos() -> Generator[TaskInfo, None, None]:
    is_in_white_list = get_is_in_white_list()
    is_in_black_list = get_is_in_black_list()

    for domain_label in os.listdir(f'./res/benchmarks'):
        domain_files_paths = {f'./res/benchmarks/{domain_label}/{x}' for x in os.listdir(f'./res/benchmarks/{domain_label}') if re.search(r'^(?:domain|d)[0-9]*.pddl$', x) != None}
        tasks_files_paths = {f'./res/benchmarks/{domain_label}/{x}' for x in os.listdir(f'./res/benchmarks/{domain_label}') if re.search(r'^[a-zA-Z0-9_\-]+.pddl$', x) != None} - domain_files_paths
        assert len(domain_files_paths) == 1 or len(domain_files_paths) == len(tasks_files_paths)

        for task_index, task_file_path in enumerate(sorted(tasks_files_paths)):
            task_label = os.path.basename(task_file_path).removesuffix('.pddl')

            if is_in_white_list(f'{domain_label},{task_label}') and not is_in_black_list(f'{domain_label},{task_label}'):
                yield TaskInfo(domain_label=domain_label, task_label=task_label, domain_file_path=sorted(domain_files_paths)[0 if len(domain_files_paths) == 1 else task_index], task_file_path=task_file_path)




def get_threads_for_task(task_info: TaskInfo) -> Generator[Thread, None, None]:
    for policy_heuristic in apn.policy_heuristic.split(','):
        for state_heuristic in apn.state_heuristic.split(','):
            for number_of_samples in apn.number_of_samples.split(','):
                for length in apn.length.split(','):
                    for percentage_fsm in apn.percentage_fsm.split(','):
                        for sample_generator in apn.sample_generator.split(','):
                            for sample_treatment_class in apn.sample_treatment_class.split(','):
                                for percentage_timer in apn.percentage_timer.split(','):
                                    for percentage_time_limit in apn.percentage_time_limit.split(','):
                                        for percentage_memory_limit in apn.percentage_memory_limit.split(','):
                                            for walker in apn.walker.split(','):
                                                for concrete_states_generator in apn.concrete_states_generator.split(','):
                                                    for regressor in apn.regressor.split(','):
                                                        for dead_end_detector in apn.dead_end_detector.split(','):
                                                            for solver in apn.solver.split(','):
                                                                args = ThreadArguments(task_info, policy_heuristic, state_heuristic, number_of_samples, length, percentage_fsm, sample_generator, sample_treatment_class, percentage_timer, percentage_time_limit, percentage_memory_limit, walker, concrete_states_generator, regressor, dead_end_detector, apn.dead_end_labels_program_flow, solver, apn.dead_end_time_limit_for_state_space_creation, apn.time_limit, apn.cache_enable)
                                                                yield Thread(target=run_thread, args=[args])

                                        
lock_file = open('/tmp/and-star-lab.lock', 'w')
fcntl.lockf(lock_file, fcntl.LOCK_EX | fcntl.LOCK_NB)
logging.info("LOG::experiment_runner::realiazing lock")


threads: list[Thread] = []
for task_info in get_tasks_infos():
    for thread in get_threads_for_task(task_info):
        threads.append(thread)
random.shuffle(threads)

start_datetime = datetime.datetime.now()
logging.info(f"LOG::experiment_runner::start_datetime: {start_datetime}")
total_number_of_tasks = len(threads)
logging.info(f"LOG::experiment_runner::total_number_of_tasks: {total_number_of_tasks}")

for i, thread in enumerate(threads):
    threads_semaphore.acquire()
    thread.start()
    logging.info(f"LOG::experiment_runner::thread {i} started")

    if i >=apn.number_of_threads:
        elapsed_time = datetime.datetime.now() - start_datetime
        expected_end = datetime.datetime.now() + elapsed_time / (i + 1 -apn.number_of_threads) * (total_number_of_tasks - (i + 1 -apn.number_of_threads))
        logging.info(f"LOG::experiment_runner::( {i + 1 -apn.number_of_threads} / {total_number_of_tasks} ) | Expected end: {expected_end}")

for thread in threads:
    thread.join(); logging.info("LOG::experiment_runner::Thread joined")

logging.info("LOG::experiment_runner::releazing lock")
fcntl.lockf(lock_file, fcntl.LOCK_UN)
logging.info("LOG::experiment_runner::end")