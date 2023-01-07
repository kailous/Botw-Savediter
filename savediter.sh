#!/bin/bash

# 一些固定变量
str="-"
ScreenLen=$(stty size | awk '{print $2}')
CEMU_DIR="${HOME}/Library/Application Support/Cemu"

# 游戏地区ID
JPN=101c9300
USA=101c9400
EUR=101c9500

# 标题
yes ${str} | sed ''''${ScreenLen}'''q' | tr -d "\n" && echo # 分割线
echo "Sevediter 存档修改辅助工具 v1.0"
echo -e "这个不是存档编辑器，仅仅是一个帮助你替换修改过的存档的工具。\n编辑存档请访问：\nhttps://www.marcrobledo.com/savegame-editors/zelda-botw/\n注意适度修改，避免失去游戏乐趣。"
yes ${str} | sed ''''${ScreenLen}'''q' | tr -d "\n" && echo # 分割线

# 初始化 判断是否已经配置过 savediter.config 文件
# 输出 变量 CONFIG 为
# true：开启配置流程 false：跳过配置流程
# 提供删除 配置文件 savediter.config 和 清理存档备份的功能
if [ -f "${CEMU_DIR}/savediter.config" ]; then
  echo "已经配置过了，是否要重新配置？"
  choices=('不用了' '更新配置' '删除配置文件' '清理存档备份（会清理所有的存档备份慎重！！！）')
  select choice in "${choices[@]}"; do
    [[ -n $choice ]] || {
      echo "选择错误，请重新选择。" >&2
      continue
    }
    case $choice in
    '不用了')
      echo "好的，将继续之前的设置。"
      CONFIG=f
      ;;
    '更新配置')
      echo "好的，开始新的配置。"
      CONFIG=t
      ;;
    '删除配置文件')
      rm -rf "${CEMU_DIR}/savediter.config"
      echo "已删除配置文件。"
      CONFIG=f
      ;;
    '清理存档备份（会清理所有的存档备份慎重！！！）')
      find "${CEMU_DIR}/mlc01/usr/save/00050000/" -name "*.backup" | xargs rm -f
      echo "存档备份已全部清理。"
      CONFIG=f
      ;;
    esac
    break
  done
else
  echo "需要花一分钟填写一些基本信息："
  CONFIG=t
fi

# 配置 savediter.config 文件
# 先判断是否需要配置
if [ ${CONFIG} = t ]; then
  # 开始配置流程
  # 输入用户ID
  echo ${CONFIG}
  read -p "请输入用户ID: " USER_ID
  echo USER_ID=${USER_ID}
  yes ${str} | sed ''''${ScreenLen}'''q' | tr -d "\n" && echo

  # 选择游戏地区
  echo "选择游戏地区"
  choices=('JPN / 日版' 'USA / 美版' 'EUR / 欧版')
  select choice in "${choices[@]}"; do
    [[ -n $choice ]] || {
      echo "选择错误，请重新选择。" >&2
      continue
    }
    case $choice in
    'JPN / 日版')
      echo "玩家ID：${USER_ID}｜游戏地区：日本"
      RENION=$JPN
      ;;
    'USA / 美版')
      echo "玩家ID：${USER_ID}｜游戏地区：美国"
      RENION=$USA
      ;;
    'EUR / 欧版')
      echo "玩家ID：${USER_ID}｜游戏地区：欧洲"
      RENION=$EUR
      ;;
    esac
    break
  done
  yes ${str} | sed ''''${ScreenLen}'''q' | tr -d "\n" && echo
  # 选择存档位置
  echo "目标存档"
  echo "选择需要修改的存档位置，有时候存档文件夹的编号与游戏内顺序不符，建议手动修改为项目的文件夹编号使用更方便。"
  echo "选择前确认好存档数量和编号正确。"
  choices=('0号存档' '1号存档' '2号存档' '3号存档' '4号存档' '5号存档')
  select choice in "${choices[@]}"; do
    [[ -n $choice ]] || {
      echo "没有那么多存档啦，不要瞎选哦～" >&2
      continue
    }
    case $choice in
    '0号存档')
      TARGET=0
      ;;
    '1号存档')
      TARGET=1
      ;;
    '2号存档')
      TARGET=2
      ;;
    '3号存档')
      TARGET=3
      ;;
    '4号存档')
      TARGET=4
      ;;
    '5号存档')
      TARGET=5
      ;;
    esac
    break
  done
  echo "目标存档位置：${TARGET}"
  # 配置交互-结束

  # 目录变量
yes ${str} | sed ''''${ScreenLen}'''q' | tr -d "\n" && echo # 分割线
  echo "生成配置文件"
yes ${str} | sed ''''${ScreenLen}'''q' | tr -d "\n" && echo # 分割线
  echo -n -e "[CEMU 用户ID]\nUSER_ID=${USER_ID}\n[游戏地区 JPN、USA、EUR]\nRENION=${JPN}\n[目标存档位置]\nTARGET=${TARGET}" >"${CEMU_DIR}/savediter.config"

else
  # 加载变量
  yes ${str} | sed ''''${ScreenLen}'''q' | tr -d "\n" && echo # 分割线
fi
# 读取配置文件
for line in "${CEMU_DIR}/savediter.config";
do
	USER_ID=$(cat "${line}" | grep "USER_ID=" | sed "s/^.*=//" )
	RENION=$(cat "${line}" | grep "RENION=" | sed "s/^.*=//" )
	TARGET=$(cat "${line}" | grep "TARGET=" | sed "s/^.*=//" )
done
# 增加变量
SAVE_DIR="${CEMU_DIR}/mlc01/usr/save/00050000/${RENION}/user/${USER_ID}"
TARGET_DIR="${SAVE_DIR}/${TARGET}/"
NOW=$(date +'%Y-%m-%d-%H%M%S')
# 进入目录
cd "${TARGET_DIR}"
cp "${TARGET_DIR}/game_data.sav" "${TARGET_DIR}/game_data.sav.${NOW}.backup"
open "${TARGET_DIR}"
echo "${TARGET_DIR}/game_data.sav"
open "https://kailous.github.io/Botw-Savediter/zelda-botw/"