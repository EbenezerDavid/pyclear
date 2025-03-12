#!/bin/bash

# 记录初始目录
initial_dir=$(pwd)

# 自动安装 pyclear
echo "安装 build 工具..."
pip3 install build || { echo "安装 build 失败"; exit 1; }
echo "构建 pyclear 包..."
python3 -m build || { echo "构建失败"; exit 1; }
cd dist || { echo "进入 dist 目录失败"; exit 1; }
whl=$(ls *.whl | head -n 1)  # 取第一个 .whl 文件
if [ -n "$whl" ]; then
    echo "安装 $whl..."
    pip3 install "$whl" || { echo "安装 $whl 失败"; exit 1; }
else
    echo "未找到 .whl 文件"
    exit 1
fi
cd "$initial_dir"  # 返回初始目录

# 将变量部署到 Python 虚拟环境中
echo "请输入你的 Python 虚拟环境路径（格式如 /home/name/venvname/bin/）："
read user_path
if [ -f "$user_path/activate" ]; then
    # 创建配置文件
    cd "$user_path" || { echo "进入 $user_path 失败"; exit 1; }
    touch venv_start.py
    echo "from pyclear import clear" > venv_start.py
    echo "__builtins__.clear = clear" >> venv_start.py
    export PYTHONSTARTUP=$(pwd)/venv_start.py
    echo "export PYTHONSTARTUP=$(pwd)/venv_start.py" >> "$user_path/activate"
    echo "配置完成！激活虚拟环境后可以使用 pyclear 的 clear 函数。"
else
    echo "错误：$user_path/activate 文件不存在"
    exit 1
fi