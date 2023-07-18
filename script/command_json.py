from hashlib import md5
import json
import os
import random
import shutil
import time

import questionary
import requests
from rich.console import Console
import urllib.error
import urllib.parse
import urllib.request

console = Console()

LANGUAGE_MAP_ARRAY = [{
    "title": "中文-简体",
    "language": "zh-CN",
    "baidu": "zh",
    "niu": "zh"
}]

BAIDU_API_ID = ""
BAIDU_API_KEY = ""
NIU_API_KEY = ""


def buildLanguageChoices():
    choices = []
    for language_map in LANGUAGE_MAP_ARRAY:
        choices.append(questionary.Choice(
            title=f'{language_map["title"]}({language_map["language"]})', value=language_map["language"]))
    return choices


def getTranslatorLanguage(language, translator):
    for language_map in LANGUAGE_MAP_ARRAY:
        if language_map["language"] == language:
            return language_map[translator]


class BaiduTranslator:

    # Generate salt and sign
    @staticmethod
    def make_md5(s, encoding='utf-8'):
        return md5(s.encode(encoding)).hexdigest()

    @staticmethod
    def translate(text, target, source="en"):
        console.rule("百度翻译API")

        # Set your own appid/appkey.
        appid = BAIDU_API_ID
        appkey = BAIDU_API_KEY

        endpoint = 'http://api.fanyi.baidu.com'
        path = '/api/trans/vip/translate'
        url = endpoint + path

        # For list of language codes, please refer to `https://api.fanyi.baidu.com/doc/21`
        from_lang = source
        to_lang = target
        query = text

        salt = random.randint(32768, 65536)
        sign = BaiduTranslator.make_md5(appid + query + str(salt) + appkey)

        # Build request
        headers = {'Content-Type': 'application/x-www-form-urlencoded'}
        payload = {'appid': appid, 'q': query, 'from': from_lang,
                   'to': to_lang, 'salt': salt, 'sign': sign}

        console.print("请求参数", style="yellow")
        console.print(json.dumps(payload, indent=4,
                      ensure_ascii=False), style='green')

        # Send request
        r = requests.post(url, params=payload, headers=headers)
        data = r.json()

        console.print("响应报文", style="yellow")
        console.print(json.dumps(data, indent=4,
                      ensure_ascii=False), style='green')

        dst_list = [result['dst'] for result in data['trans_result']]
        dst_str = '\n'.join(dst_list)

        return dst_str


class NiuTranslator:
    @staticmethod
    def translate(text, target, source="en"):
        console.rule("小牛翻译API")

        apikey = NIU_API_KEY

        url = 'http://api.niutrans.com/NiuTransServer/translation?'
        data = {"from": source, "to": target,
                "apikey": apikey, "src_text": text}

        console.print("请求参数", style="yellow")
        console.print(json.dumps(data, indent=4,
                      ensure_ascii=False), style='green')

        data_en = urllib.parse.urlencode(data)
        req = url + "&" + data_en
        res = urllib.request.urlopen(req)
        res = res.read()

        console.print("响应报文", style="yellow")
        console.print(json.dumps(
            res, indent=4, ensure_ascii=False), style='green')

        res_dict = json.loads(res)
        if "tgt_text" in res_dict:
            result = res_dict['tgt_text']
        else:
            result = res

        return result


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


def translate_text(translator, text, target, src='auto'):
    if translator == 'baidu':
        try:
            return BaiduTranslator.translate(text, target, src)
        except:
            time.sleep(1)
            return translate_text(translator, text, target, src)
    elif translator == 'niutrans':
        try:
            return NiuTranslator.translate(text, target, src)
        except:
            time.sleep(1)
            return NiuTranslator.translate(text, target, src)
    else:
        return text


def translate_json(translator, source, language):
    json_data = read_json_file(source)
    target = getTranslatorLanguage(language, translator)
    for key, value in json_data.items():
        trans_text = translate_text(translator, value, target, "en")
        json_data[key] = trans_text
    return json_data


def main():
    enable_translate_question = questionary.confirm("是否启用翻译？").ask()

    if enable_translate_question:
        translator = questionary.select(
            "请选择翻译器（需手动配置key）?",
            choices=[
                questionary.Choice(title="百度翻译(1次/秒)", value="baidu"),
                questionary.Choice(title="小牛翻译(50次/秒)", value="niutrans"),
            ],
        ).ask()

        if translator == "baidu" and (len(BAIDU_API_KEY) <= 0 or len(BAIDU_API_ID) <= 0):
            console.print("百度翻译还没有配置 appId、appKey", style="bold red")
            return
        if translator == "niutrans" and len(NIU_API_KEY) <= 0:
            console.print("小牛翻译还没有配置 appKey", style="bold red")
            return

        target_languages = questionary.checkbox(
            "请选择目标语言",
            qmark="😃",
            choices=buildLanguageChoices(),
            validate=lambda x: (
                True if len(x) > 0 else "请至少选择一项目标语言"
            )
        ).ask()

    root_path = os.path.dirname('../')
    folders = get_all_folders(root_path)
    folders = [x for x in folders if 'java-tab-completion' in x]
    for folder in folders:
        name = folder.replace('.', '').replace('\\', '').replace('/', '')
        source = f'../{name}/{name}.json'
        default_json = f'../{name}/json/en_US.json'
        move_file(source, default_json)

        # 启用翻译
        if enable_translate_question:
            for language in target_languages:
                translate_content = translate_json(
                    translator, default_json, language)
                translate_content_text = json.dumps(
                    translate_content, indent=4, ensure_ascii=False)
                write_file(f'../{name}/json/{language}.json',
                           translate_content_text)


if __name__ == "__main__":
    main()
