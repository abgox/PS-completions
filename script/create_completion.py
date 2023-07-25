import os
from jinja2 import Environment, FileSystemLoader
import questionary
import uuid
from rich.console import Console
from datetime import datetime

console = Console()

LICENSE_URI = 'https://github.com/abgox/PS-completions/blob/main/LICENSE'
PROJECT_URI = 'https://github.com/abgox/PS-completions'

# 获取当前日期并格式化为字符串：年-月-日
current_date_str = datetime.now().strftime('%Y-%m-%d')

JSON_ZH_CN_DEMO = '''
{
    "demo1": "这是命令补全的第一个demo",
    "demo1 sub1": "这是子命令补全的第一个demo",
    "demo1 sub2": "这是子命令补全的第二个demo",
    "demo2": "这是命令补全的第二个demo",
    "demo2 sub1": "这是子命令补全的第一个demo",
    "demo2 sub2": "这是子命令补全的第二个demo"
}
'''

JSON_EN_US_DEMO = '''
{
    "demo1": "This is first demo command for tab completion.",
    "demo1 sub1": "This is first demo subCommand for tab completion.",
    "demo1 sub2": "This is second demo subCommand for tab completion.",
    "demo2": "This is second demo command for tab completion.",
    "demo2 sub1": "This is first demo subCommand for tab completion.",
    "demo2 sub2": "This is second demo subCommand for tab completion."
}
'''

def write_file(file_path, content):
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    sql_open_permission_file = open(file_path, "w", encoding="utf-8")
    sql_open_permission_file.write(content)
    sql_open_permission_file.close()

def main():
    # 第一组问题
    group_one_questions = [
        {
            "type": "text",
            "name": "commandName",
            "message": "请输入命令名称，例如：pnpm（自动添加-tab-completion）",
            "validate": lambda x: (
                True if len(x) > 0 else "请输入命令名称"
            ),
        },
        {
            "type": "text",
            "name": "author",
            "message": "请输入发布者名称",
            "default": "abgo"
        }
    ]
    group_one_answers = questionary.prompt(group_one_questions)
    command_name = group_one_answers['commandName'].strip()
    author = group_one_answers['author'].strip()

    # 第二组问题
    default_copyright = f'(c) { author }. All rights reserved.'
    default_description = f'{ command_name } tab completion.The data of completion comes from json,and you can modify the json file to change the completion as required. For more information, please visit the project: { PROJECT_URI }'
    group_two_questions = [
        {
            "type": "text",
            "name": "copyright",
            "message": "请输入版权信息",
            "default": default_copyright
        },
        {
            "type": "text",
            "name": "description",
            "message": "请输入描述信息",
            "default": default_description
        },
    ]
    group_two_answers = questionary.prompt(group_two_questions)
    copyright = group_two_answers['copyright'].strip()
    description = group_two_answers['description'].strip()

    project_name = f'{ command_name }-tab-completion'
    # 生成项目guid
    guid = str(uuid.uuid4())

    tags = [command_name, 'tab', 'completion', 'tab-completion']
    tags_str = ', '.join(f"'{tag}'" for tag in tags)

    template_data = {
      "project_uri": PROJECT_URI,
      "license_uri": LICENSE_URI,
      "project_name": project_name,
      "author": author,
      "copyright": copyright,
      "description": description,
      "tags_str": tags_str,
      "guid": guid,
      "current_date_str": current_date_str,
      "command_name": command_name

    }

    console.print(template_data, style='blue')

    template_env = Environment(loader=FileSystemLoader('templates'))
    psd_file_template = template_env.get_template('tab-completion.psd1')
    psm_file_template = template_env.get_template('tab-completion.psm1')

    psd_content = psd_file_template.render(template_data)
    psm_content = psm_file_template.render(template_data)

    project_path = f'../{project_name}'
    psd_file_path = f'{project_path}/{project_name}.psd1'
    write_file(psd_file_path, psd_content)

    psm_file_path = f'{project_path}/{project_name}.psm1'
    write_file(psm_file_path, psm_content)

    write_file(f'{project_path}/json/en-US.json', JSON_EN_US_DEMO)
    write_file(f'{project_path}/json/zh-CN.json', JSON_ZH_CN_DEMO)


if __name__ == "__main__":
    main()
