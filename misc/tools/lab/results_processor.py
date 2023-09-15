import os
import re
import natsort

unsolvable = {
    ('first-responders', 'fr-p_2_1'),
    ('first-responders', 'fr-p_2_5'),
    ('first-responders', 'fr-p_2_6'),
    ('first-responders', 'fr-p_2_9'),
    ('first-responders', 'fr-p_2_10'),
    ('first-responders', 'fr-p_3_3'),
    ('first-responders', 'fr-p_3_4'),
    ('first-responders', 'fr-p_3_5'),
    ('first-responders', 'fr-p_3_6'),
    ('first-responders', 'fr-p_3_9'),
    ('first-responders', 'fr-p_3_10'),
    ('first-responders', 'fr-p_4_5'),
    ('first-responders', 'fr-p_4_10'),
    ('first-responders', 'fr-p_5_6'),
    ('first-responders', 'fr-p_5_7'),
    ('first-responders', 'fr-p_6_6'),
    ('first-responders', 'fr-p_6_7'),
    ('first-responders', 'fr-p_7_9'),
    ('first-responders', 'fr-p_8_3'),
    ('first-responders', 'fr-p_9_4'),
    ('first-responders', 'fr-p_9_5'),
    ('first-responders', 'fr-p_9_9'),
    ('first-responders', 'fr-p_9_10'),
    ('first-responders', 'fr-p_10_6'),
    ('first-responders', 'fr-p_10_9'),
}

if not os.path.exists('./misc/data/processed_results/'):
    os.makedirs('./misc/data/processed_results/')

def process_results(label_pattern: str) -> set[str]:
    resulting_files_paths = set()
    for label in os.listdir('./misc/data/raw_results/'):
        if re.search(label_pattern, label) == None: continue
        print(label)
        new_results = []
        instances: list[str] = natsort.natsorted(os.listdir(f'./misc/data/raw_results/{label}'))
        for instance in instances:
            if instance.endswith('.policy'): continue
            if tuple(instance[:-4].split(',')) in unsolvable: continue
            file_data = open(f'./misc/data/raw_results/{label}/{instance}').read()
            new_result = [instance[:-4]]
            if 'bad_alloc' in file_data or '95%' in file_data or 'Out of memory' in file_data:
                new_result.append('M')
            elif 'Termination: Unsolvable' in file_data or 'Unsolvable Task' in file_data:
                new_result.append('U')
            elif 'Termination' not in file_data:
                new_result.append('T')
            else:
                assert 'Termination: Solved' in file_data
                new_result.append('S')
                file_data = file_data.split('Compress')[0]
                for line in file_data.split('\n'):
                    if line == '': continue
                    if line[0] == '[': continue
                    if line[0] == 'C': continue
                    if line[0:2] == 'Te': continue
                    if line[0:2] == 'Ti': continue
                    if ': ' not in line: continue
                    new_result.append(line.split(': ')[-1])
            new_results.append(','.join(new_result))
        open(f'./misc/data/processed_results/{label}.csv', 'w').write('\n'.join(new_results))
        resulting_files_paths.add(f'./misc/data/processed_results/{label}.csv')
    return resulting_files_paths

if __name__ == '__main__':
    input_label_pattern = input('Label Pattern: ')
    process_results(input_label_pattern)
