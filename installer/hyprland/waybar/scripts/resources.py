#!/usr/bin/env python3
"""Stream combined CPU and memory statistics to Waybar without dependencies."""

import html
import json
import os
from pathlib import Path
import time


def cpu_times():
    # guest and guest_nice are already included in user and nice.
    values = list(map(int, Path('/proc/stat').read_text().splitlines()[0].split()[1:9]))
    return sum(values), values[3] + values[4]


def memory_stats():
    return {
        key: int(value.split()[0])
        for key, value in (
            line.split(':', 1)
            for line in Path('/proc/meminfo').read_text().splitlines()
        )
    }


def gib(kib):
    return f'{kib / 1024 / 1024:.2f} GiB'


def main():
    model = next(
        (line.split(':', 1)[1].strip()
         for line in Path('/proc/cpuinfo').read_text().splitlines()
         if line.startswith('model name')),
        'CPU',
    )
    previous_total, previous_idle = cpu_times()
    while True:
        time.sleep(2)
        total, idle = cpu_times()
        elapsed = total - previous_total
        usage = max(0, min(100, 100 * (1 - (idle - previous_idle) / elapsed))) if elapsed else 0
        previous_total, previous_idle = total, idle
        memory = memory_stats()
        used = memory['MemTotal'] - memory['MemAvailable']
        percent = 100 * used / memory['MemTotal']
        swap_used = memory['SwapTotal'] - memory['SwapFree']
        load = ' / '.join(f'{value:.2f}' for value in os.getloadavg())
        tooltip = (
            f'<b>CPU</b>  {html.escape(model)}\n'
            f'使用率：{usage:.0f}%  |  逻辑核心：{os.cpu_count()}\n'
            f'平均负载（1 / 5 / 15 分钟）：{load}\n\n'
            f'<b>内存</b>  {percent:.0f}%\n'
            f'已用 / 总量：{gib(used)} / {gib(memory["MemTotal"])}\n'
            f'可用：{gib(memory["MemAvailable"])}\n'
            f'Swap 已用 / 总量：{gib(swap_used)} / {gib(memory["SwapTotal"])}'
        )
        print(json.dumps({
            'text': '󰍛',
            'tooltip': tooltip,
        }, ensure_ascii=False), flush=True)


if __name__ == '__main__':
    try:
        main()
    except BrokenPipeError:
        pass
