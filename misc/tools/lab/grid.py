import os
from PIL import Image
import numpy
from math import ceil

def get_array_from_image(image):
    return numpy.array(image)

domains = [
    'acrobatics',
    'beam-walk',
    'blocksworld-advanced',
    'blocksworld-original',
    'chain-of-rooms',
    'doors',
    'earth-observation',
    'faults',
    'first-responders',
    'islands',
    'tireworld-triangle',
    'tireworld-truck',
]

input_path = "./misc/data/metrics/"
output_path = "./misc/data/metrics/grid/"
folders = [basename for basename in sorted(os.listdir(input_path)) if os.path.isdir(f'{input_path}/{basename}') and basename != 'grid']
if not os.path.exists(output_path): os.makedirs(output_path)

for domain in domains:
    images = [Image.open(f'{input_path}/{folder}/{domain}.png') for folder in folders]

    above_images = numpy.concatenate([get_array_from_image(images[i]) for i in range(ceil(len(folders)/2))], axis=1)
    below_images = numpy.concatenate([get_array_from_image(images[i]) for i in range(ceil(len(folders)/2), len(folders))], axis=1)

    final_image = numpy.concatenate([above_images, below_images], axis=0)

    Image.fromarray(final_image).save(f'{output_path}/{domain}.png')
