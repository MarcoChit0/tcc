

import pandas as pd
import re
import os
import matplotlib.pyplot as plt
from pandas.plotting import table
from PIL import Image, ImageChops

def parse_domain_file(domain_file):
    def parse_params(params):
        params_str = ""
        count = 0
        for params_with_type, params, type in re.findall(r'(([\?(\w)+\s]+) - ([\w]+))', params.strip()):
            if count > 0:
                params_str += "; "
            splitted_params = params.split()
            for i in range(len(splitted_params)-1):
                params_str += f"{splitted_params[i].replace('?', '')}, "
            params_str += f"{splitted_params[-1].replace('?', '')} : {type}"
            count += 1
        return params_str.strip()

    data = []

    # Extract domain name
    domain_name_match = re.search(r'\(define \(domain ([^\)]+)\)', domain_file)
    if domain_name_match:
        data.append(['name', domain_name_match.group(1)])

    # Extract types
    types_matches = re.findall(r'\(:types\s+([^\)]+)\)', domain_file)
    for types in types_matches:
        for type_ in types.split():
            data.append(['type', type_])

    # Extract predicates
    # (:predicates
    #     (vehicle-at ?loc - location)
    #     (tire-at ?loc - location)
    #     (normal-road ?from - location ?to - location)
    #     (spiky-road ?from - location ?to - location)
    #     (flat-tire)
    #     (has-many-spares ?count - number)
    #     (next ?n - number ?m - number)
    # )
    # Regular expression pattern
    predicates = re.findall('(\([\w\?\s-]*\))', re.search(r'\(:predicates((\s|\n)|(\([\w\?\s-]*\)))*\)', domain_file).group(0), re.DOTALL)

    for predicate in predicates:
        predicate = predicate.strip('()')
        if predicate:
            parts = predicate.split()
            predicate_name = parts[0]
            predicate_params = " ".join(parts[1:])
            formatted_predicate = f"{predicate_name} ({parse_params(predicate_params)})"
            data.append(['predicate', formatted_predicate])

    # Extract actions
    actions_matches = re.findall(r'\(:action ([^\s]+)\s+:parameters\s+\(([^\)]+)\)', domain_file, re.DOTALL)
    for action, params in actions_matches:
        action_str = f"{action} ({parse_params(params)})"
        data.append(['action', action_str])

    # Create DataFrame
    df = pd.DataFrame(data, columns=['key', 'value'])
    return df

def dataframe_to_image(df, output_path):
    # Create a plot
    fig, ax = plt.subplots(figsize=(12, len(df) * 0.5))  # Adjust the height based on the number of rows
    ax.axis('tight')
    ax.axis('off')
    tbl = table(ax, df, loc='center', cellLoc='center', colWidths=[0.15, 0.85])

    # Remove the header and index
    tbl.auto_set_font_size(False)
    tbl.set_fontsize(10)
    tbl.scale(1.2, 1.2)
    tbl.auto_set_column_width([0, 1])
    for (i, j), cell in tbl.get_celld().items():
        cell.set_text_props(fontsize=10)
        if i == 0:  # Header
            cell.set_visible(False)
        if j == -1:  # Index
            cell.set_visible(False)

    # Customize table appearance
    for key, cell in tbl.get_celld().items():
        cell.set_fontsize(10)
        if key[0] % 2 == 0:
            cell.set_facecolor('#f1f1f2')
        else:
            cell.set_facecolor('#eaeaf2')
        cell.set_edgecolor('#ffffff')

    # Save the plot as an image, tightly around the table
    plt.savefig(output_path, bbox_inches='tight', pad_inches=0.0, dpi=300)
    plt.close()
def prepare_dataframe(df):
    # Initialize new lists for the transformed DataFrame
    new_keys = []
    new_values = []

    # Iterate over the unique keys
    for key in df['key'].unique():
        # Get the sub-DataFrame for each key
        sub_df = df[df['key'] == key]
        for i, value in enumerate(sub_df['value']):
            if i == 0:
                new_keys.append(key)
            else:
                new_keys.append('')  # Empty string for repeated keys
            new_values.append(value)

    return pd.DataFrame({'key': new_keys, 'value': new_values})

def trim_image(image_path, output_path):
    # Open the image
    image = Image.open(image_path)

    # Convert the image to grayscale
    image = image.convert('L')

    # Trim the image
    bg = Image.new(image.mode, image.size, image.getpixel((0, 0)))
    diff = ImageChops.difference(image, bg)
    diff = ImageChops.add(diff, diff, 2.0, -100)
    bbox = diff.getbbox()
    if bbox:
        image = image.crop(bbox)

    # Save the trimmed image
    image.save(output_path)

def png_to_pdf(image_path, pdf_path):
    # Open the image
    image = Image.open(image_path)

    # Save the image as a PDF
    image.save(pdf_path, 'PDF', resolution=100.0)

def add_small_white_border(image_path, output_path):
    # Open the image
    image = Image.open(image_path)

    # Add a small white border
    border_size = 10
    new_size = (image.size[0] + border_size * 2, image.size[1] + border_size * 2)
    new_image = Image.new('RGB', new_size, 'white')
    new_image.paste(image, (border_size, border_size))

    # Save the image with a white border
    new_image.save(output_path)


path = "res/benchmarks"
# domains = ["tireworld-spiky-2", "sokoban", "travelling-salesman", "kitchen", "rescue"]
domains = ["tireworld-spiky-2"]
for domain in domains:
    domain_file = os.path.join(path, domain, "domain.pddl")
    print(f"Processing {domain_file}")
    output_path = domain_file.replace(".pddl", ".png")
    input_str = open(domain_file, "r").read()
    df = parse_domain_file(input_str)
    df = prepare_dataframe(df)
    dataframe_to_image(df, output_path)
    trim_image(output_path, output_path)
    add_small_white_border(output_path, output_path)


# not_to_be_included_on_table = {
#     "kitchen" : {
#         "predicate" : ["next", "can-use-chef-island", "properly-added", "not-on-recipe", "finished", "num-recipes-to-refuse"],
#         "action" : ["select-chef-island", "on-recipe-add-to-recipe", "offer", "from-stock-to-chef-island", "from-chef-island-to-stock"]
#     }
# }
#
# to_be_included_on_table = {
#     "kitchen" : {
#     }
# }
