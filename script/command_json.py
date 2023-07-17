import json
import os
import shutil
from googletrans import Translator
from rich.console import Console

console = Console()

def get_all_folders(path):
    folders = []
    for item in os.listdir(path):
        item_path = os.path.join(path, item)
        if os.path.isdir(item_path):
            folders.append(item_path)
    return folders


def read_json_file(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
    return data

def write_file(file_path, content):
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    sql_open_permission_file = open(file_path, "w", encoding="utf-8")
    sql_open_permission_file.write(content)
    sql_open_permission_file.close()
    
def move_file(source, destination):
    os.makedirs(os.path.dirname(destination), exist_ok=True)
    shutil.move(source, destination)
    
def translate_text(text, dest, src='auto'):
    translator = Translator(service_urls=['translate.google.com'])
    translation = translator.translate(text, dest=dest, src=src)
    return translation.text

def translate_json(source, language):
    json_data = read_json_file(source)
    for key, value in json_data.items():
      translate_text = translate_text(value, language, "en")
      console.print(f'value = {value}, translate_text = { translate_text }')
      json_data[key] = translate_text
    return json_data
    
  
def main():
  root_path = os.path.dirname('../')
  folders = get_all_folders(root_path)
  folders = [x for x in folders if 'java-tab-completion' in x]
  for folder in folders:
    name = folder.replace('.', '').replace('\\', '').replace('/', '')
    source = f'../{name}/{name}.json'
    default_json = f'../{name}/json/en_US.json'
    move_file(source, default_json)
    translate_content = translate_json(default_json, 'zh-cn')
    write_file(f'../{name}/json/zh-CN.json', translate_content)

if __name__ == "__main__":
    main()