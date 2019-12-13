import argparse
import subprocess
from typing import List, Callable, Any, Union
import shutil
import sys
import os
import pathlib
import platform
import urllib.request


# utilities
def run_cmd(cmd_list: Union[List[str], str]) -> None:
    if isinstance(cmd_list, str):
        print(cmd_list)
        subprocess.run(cmd_list).check_returncode()
    else:
        for cmd in cmd_list:
            print(cmd)
            subprocess.run(cmd).check_returncode()


def no_venv(func: Callable[..., Any]) -> Callable[..., Any]:
    if 'VIRTUAL_ENV' in os.environ:
        raise Exception(
            'Cannot run {} inside python virtual environment, run "deactivate" to break out of it'
            .format(func.__name__))
    return func


# main stuff
def go_parser() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--clean',
        '-c',
        action='store_true',
    )
    parser.add_argument('command', choices=['install', 'check_environ'])

    parsed = parser.parse_args()

    commanded_function = getattr(sys.modules[__name__], parsed.command)
    commanded_function(parsed.clean)


@no_venv
def install(clean: bool) -> None:
    if clean and pathlib.Path('venv').is_dir():
        print('deleting virtual environment, venv')
        shutil.rmtree('venv')
    print('creating venv')
    cmds = [
        'python -m venv venv',
        'venv/Scripts/pip install -r requirements.txt',
        'venv/Scripts/pip install -r requirements-dev.txt',
    ]
    run_cmd(cmds)

    # getting one of the kivy nightlies since it had trio
    print('downloading kivy wheel')
    if not platform.architecture()[1].startswith('Windows'):
        raise Exception('I only know how to install kivy on Windows')
    kivy_32_bit = 'https://kivy.org/downloads/appveyor/kivy/Kivy-2.0.0.dev0.20191205.18aa4389e-cp37-cp37m-win32.whl'
    kivy_64_bit = 'https://kivy.org/downloads/appveyor/kivy/Kivy-2.0.0.dev0.20191205.18aa4389e-cp37-cp37m-win_amd64.whl'
    if platform.architecture()[0] == '64bit':
        download_url = kivy_64_bit
    else:
        download_url = kivy_32_bit

    download_location = pathlib.Path('venv', download_url.split('/')[-1])
    urllib.request.urlretrieve(download_url, download_location)

    run_cmd('venv/Scripts/pip install ' + str(download_location))


@no_venv
def check_environ(clean: bool) -> None:
    # check python version
    print('checking python version')
    REQUIRED_PYTHON_MAJOR_VERSION = 3
    REQUIRED_PYTHON_MINOR_VERSION = 7
    if sys.version_info[0] != REQUIRED_PYTHON_MAJOR_VERSION or sys.version_info[
            1] != REQUIRED_PYTHON_MINOR_VERSION:
        raise Exception('Python 3.7.* required, found {}.{}.*'.format(
            sys.version_info[0], sys.version_info[1]))
    print('found version 3.7.* good')


if __name__ == '__main__':
    go_parser()