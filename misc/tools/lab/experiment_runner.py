import os
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
from typing import Generator, Callable
from threading import Thread, Lock, Semaphore

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

    

    def configure(self) -> None:
        self.add_argument("-n", "--number-of-threads", type=int, default=7)
        self.add_argument("-t", "--time-limit", help="(in minutes)", type=float, default=5)
        self.add_argument("-m", "--memory-limit", help="(in Gb)", type=float, default=64)
        self.add_argument("--run-again-if-done", default=False, action='store_true')
        self.add_argument("-wl", "--white-list-file-path", type=str, default='./white-list.txt')
        self.add_argument("-bl", "--black-list-file-path", type=str, default='./black-list.txt')
        self.add_argument("-p", "--save-folder-name-prefix", type=str, default=f'test,v{datetime.date.today().isoformat()}')
        self.add_argument("-sh", "--state-heuristic", type=str, default='trie-star')
        self.add_argument("-ph", "--policy-heuristic", type=str, default='max-lookup-delta-nearest')
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

apn = ArgParsingNamespace()
argcomplete.autocomplete(apn)

apn.parse_args()

threads_semaphore = Semaphore(apn.number_of_threads)
folder_creation_lock = Lock()
process_creation_lock = Lock()
print_lock = Lock()

def limit_virtual_memory(): resource.setrlimit(resource.RLIMIT_AS, (round(apn.memory_limit * 1000 * 1000 * 1000 / 8), round(apn.memory_limit * 1000 * 1000 * 1000 / 8)))
def limit_cpu_time(): resource.setrlimit(resource.RLIMIT_CPU, (round(apn.time_limit * 60), round(apn.time_limit * 60)))
def apply_limits(): limit_virtual_memory(); limit_cpu_time()

@dataclasses.dataclass()
class TaskInfo:
    domain_label: str
    task_label: str
    domain_file_path: str
    task_file_path: str

def get_splitted_command(
        task_info: TaskInfo, 
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
        samples_file_path: str,
        ) -> list[str]:
    return [
        f'./and_star',
        f'{task_info.domain_file_path}',
        f'{task_info.task_file_path}',
        f'{policy_heuristic}',
        f'{state_heuristic}',
        f'{number_of_samples}',
        f'{length}',
        f'{percentage_fsm}',
        f'{sample_generator}',
        f'{sample_treatment_class}',
        f'{percentage_timer}',
        f'{percentage_time_limit}',
        f'{percentage_memory_limit}',
        f'{walker}',
        f'{concrete_states_generator}',
        f'{regressor}',
        f'{samples_file_path}',
    ]

def run_thread(task_info: TaskInfo, policy_heuristic: str, state_heuristic: str, number_of_samples:str, length:str, percentage_fsm: str, sample_generator: str, sample_treatment_class: str, percentage_timer: str, percentage_time_limit: str, percentage_memory_limit: str, walker: str, concrete_states_generator: str, regressor: str) -> None:
    global apn, threads_semaphore, folder_creation_lock, process_creation_lock, print_lock

    basic_dir_structure = f'./misc/data/raw_results/{apn.save_folder_name_prefix}/'
    params = f"{policy_heuristic},{state_heuristic},{number_of_samples},{length},{percentage_fsm},{sample_generator},{sample_treatment_class},{percentage_timer},{percentage_time_limit},{percentage_memory_limit},{walker},{concrete_states_generator},{regressor}"
    task = f'{task_info.domain_label}/{task_info.task_label}'
    save_folder_path = f'{basic_dir_structure}/{params}/{task}'
    save_file_name = f'results.csv'
    samples_file_path = f"{save_folder_path}/samples.csv"

    if os.path.exists(f'{save_folder_path}/{save_file_name}') and not apn.run_again_if_done: threads_semaphore.release(); return

    folder_creation_lock.acquire()
    if not os.path.exists(f'{save_folder_path}'): os.makedirs(f'{save_folder_path}')
    folder_creation_lock.release()

    process_creation_lock.acquire(); time.sleep(0.1)
    with open('./misc/data/log.txt', 'a') as log_file: log_file.write(f'{datetime.datetime.now(), (task_info.domain_label, task_info.task_label, policy_heuristic, state_heuristic, apn.save_folder_name_prefix)}\n')
    process = subprocess.Popen(get_splitted_command(task_info, policy_heuristic, state_heuristic, number_of_samples, length, percentage_fsm, sample_generator, sample_treatment_class, percentage_timer, percentage_time_limit, percentage_memory_limit, walker, concrete_states_generator, regressor, samples_file_path), stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, preexec_fn=apply_limits, text=True)
    process_creation_lock.release()

    # process._sigint_wait_secs = 0
    stdout, stderr = process.communicate()
    result = stdout + stderr

    print_lock.acquire(); time.sleep(0.1)
    print(f'domain: {task_info.domain_label}, task: {task_info.task_label}, policyh: {policy_heuristic}, stateh: {state_heuristic}, nsamples: {number_of_samples}, length: {length}, %fsm: {percentage_fsm}, generator: {sample_generator}, treatment: {sample_treatment_class}, %timer: {percentage_timer}, %tlimit: {percentage_time_limit}, %mlimit: {percentage_memory_limit}, walker: {walker}, concrete states gen: {concrete_states_generator}, regressor: {regressor}')
    open(f'{save_folder_path}/{save_file_name}', 'w').write(result)
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
                                                        yield Thread(target=run_thread, args=(task_info, policy_heuristic, state_heuristic, number_of_samples, length, percentage_fsm, sample_generator, sample_treatment_class, percentage_timer, percentage_time_limit, percentage_memory_limit, walker, concrete_states_generator, regressor))

lock_file = open('/tmp/and-star-lab.lock', 'w')
fcntl.lockf(lock_file, fcntl.LOCK_EX | fcntl.LOCK_NB)

threads: list[Thread] = []
for task_info in get_tasks_infos():
    for thread in get_threads_for_task(task_info):
        threads.append(thread)
random.shuffle(threads)

start_datetime = datetime.datetime.now()
total_number_of_tasks = len(threads)

for i, thread in enumerate(threads):
    threads_semaphore.acquire()
    thread.start()

    if i >= apn.number_of_threads:
        elapsed_time = datetime.datetime.now() - start_datetime
        expected_end = datetime.datetime.now() + elapsed_time / (i + 1 - apn.number_of_threads) * (total_number_of_tasks - (i + 1 - apn.number_of_threads))
        print()
        print(f'{TerminalColor.BOLD}( {i + 1 - apn.number_of_threads} / {total_number_of_tasks} ){TerminalColor.ENDC} | Expected end: {TerminalColor.BOLD}{expected_end}{TerminalColor.ENDC}')
        print()

for thread in threads:
    thread.join()

fcntl.lockf(lock_file, fcntl.LOCK_UN)
