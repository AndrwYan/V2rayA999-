＃！/斌/庆典

＃此文件可通过https://install.direct/go.sh访问
＃原始资源位于github.com/v2ray/v2ray-core/release/install-release.sh

＃如果没有指定，返回值的默认含义：
＃0：成功
＃1：系统错误
＃2：应用程序错误
＃3：网络错误

CUR_VER = “”
NEW_VER = “”
ARCH = “”
VDIS = “64”
zip文件= “/ TMP / v2ray / v2ray.zip”
V2RAY_RUNNING = 0
VSRC_ROOT = “/ TMP / v2ray”
EXTRACT_ONLY = 0
ERROR_IF_UPTODATE = 0

CMD_INSTALL = “”
CMD_UPDATE = “”
SOFTWARE_UPDATED = 0

SYSTEMCTL_CMD = $（命令-v systemctl 2> / dev / null）
SERVICE_CMD = $（命令-v service 2> / dev / null）

CHECK = “”
FORCE = “”
HELP = “”

＃＃＃＃＃＃＃色标＃＃＃＃＃＃＃＃
RED =“31m”＃错误信息
GREEN =“32m”＃成功消息
YELLOW =“33m”＃警告信息
BLUE =“36m”#Info消息


#########################
而[[$＃> 0]];做
    关键= “$ 1”
    case $ key in
        -p | --proxy）
        PROXY =“ -  x $ {2}”
        转移过去的论点
        ;;
        -h | --help）
        HELP = “1”
        ;;
        -f | --force）
        FORCE = “1”
        ;;
        -c | --check）
        CHECK = “1”
        ;;
        - 去掉）
        REMOVE = “1”
        ;;
        - 版）
        VERSION = “$ 2”
        转移
        ;;
        - 提取）
        VSRC_ROOT = “$ 2”
        转移
        ;;
        --extractonly）
        EXTRACT_ONLY = “1”
        ;;
        -l | --local）
        LOCAL = “$ 2”
        LOCAL_INSTALL = “1”
        转移
        ;;
        --errifuptodate）
        ERROR_IF_UPTODATE = “1”
        ;;
        *）
                ＃未知选项
        ;;
    ESAC
    转移＃过去的论点或价值
DONE

###############################
colorEcho（）{
    COLOR = $ 1
    echo -e“\ 033 [$ {COLOR} $ {@：2} \ 033 [0m”
}

sysArch（）{
    ARCH = $（uname -m）
    if [[“$ ARCH”==“i686”]] || [[“$ ARCH”==“i386”]]; 然后
        VDIS = “32”
    elif [[“$ ARCH”== *“armv7”*]] || [[“$ ARCH”==“armv6l”]]; 然后
        VDIS = “臂”
    elif [[“$ ARCH”== *“armv8”*]] || [[“$ ARCH”==“aarch64”]]; 然后
        VDIS = “arm64”
    elif [[“$ ARCH”== *“mips64le”*]]; 然后
        VDIS = “mips64le”
    elif [[“$ ARCH”== *“mips64”*]]; 然后
        VDIS = “MIPS64”
    elif [[“$ ARCH”== *“mipsle”*]]; 然后
        VDIS = “mipsle”
    elif [[“$ ARCH”== *“mips”*]]; 然后
        VDIS = “MIPS”
    elif [[“$ ARCH”== *“s390x”*]]; 然后
        VDIS = “s390x”
    elif [[“$ ARCH”==“ppc64le”]]; 然后
        VDIS = “ppc64le”
    elif [[“$ ARCH”==“ppc64”]]; 然后
        VDIS = “PPC64”
    科幻
    返回0
}

downloadV2Ray（）{
    rm -rf / tmp / v2ray
    mkdir -p / tmp / v2ray
    colorEcho $ {BLUE}“正在下载V2Ray。”
    DOWNLOAD_LINK = “https://github.com/v2ray/v2ray-core/releases/download/${NEW_VER}/v2ray-linux-${VDIS}.zip”
    curl $ {PROXY} -L -H“Cache-Control：no-cache”-o $ {ZIPFILE} $ {DOWNLOAD_LINK}
    如果[$？！= 0];然后
        colorEcho $ {RED}“无法下载！请检查您的网络或重试。”
        返回3
    科幻
    返回0
}

安装软件（）{
    COMPONENT = $ 1
    if [[-n`command -v $ COMPONENT`]]; 然后
        返回0
    科幻

    getPMT
    如果[[$？-eq 1]]; 然后
        colorEcho $ {RED}“系统包管理器工具不是APT或YUM，请手动安装$ {COMPONENT}。”
        返回1 
    科幻
    if [[$ SOFTWARE_UPDATED -eq 0]]; 然后
        colorEcho $ {BLUE}“正在更新软件仓库”
        $ CMD_UPDATE      
        SOFTWARE_UPDATED = 1
    科幻

    colorEcho $ {BLUE}“正在安装$ {COMPONENT}”
    $ CMD_INSTALL $ COMPONENT
    如果[[$？-ne 0]]; 然后
        colorEcho $ {RED}“无法安装$ {COMPONENT}。请手动安装。”
        返回1
    科幻
    返回0
}

#return 1：not apt，yum或zypper
getPMT（）{
    if [[-n`command -v apt-get`]];然后
        CMD_INSTALL =“apt-get -y -qq install”
        CMD_UPDATE =“apt-get -qq update”
    elif [[-n`command -v yum`]]; 然后
        CMD_INSTALL =“yum -y -q install”
        CMD_UPDATE =“yum -q makecache”
    elif [[-n`command -v zypper`]]; 然后
        CMD_INSTALL =“zypper -y install”
        CMD_UPDATE =“zypper ref”
    其他
        返回1
    科幻
    返回0
}

提取（）{
    colorEcho $ {BLUE}“将V2Ray包解压缩到/ tmp / v2ray。”
    mkdir -p / tmp / v2ray
    解压$ 1 -d $ {VSRC_ROOT}
    如果[[$？-ne 0]]; 然后
        colorEcho $ {RED}“无法提取V2Ray。”
        返回2
    科幻
    if [[-d“/ tmp / v2ray / v2ray  -  $ {NEW_VER} -linux  -  $ {VDIS}”]]; 然后
      VSRC_ROOT = “/ tmp目录/ v2ray / v2ray  -  $ {} NEW_VER -linux  -  $ {} VDIS”
    科幻
    返回0
}


＃1：新的V2Ray。0：没有。2：没有安装。3：检查失败。4：不检查。
getVersion（）{
    if [[-n“$ VERSION”]]; 然后
        NEW_VER = “$ VERSION”
        如果[[$ {NEW_VER}！= v *]]; 然后
          NEW_VER = V $ {} NEW_VER
        科幻
        返回4
    其他
        VER =`/ usr / bin / v2ray / v2ray -version 2> / dev / null`
        RETVAL = “$？”
        CUR_VER =`echo $ VER | 头-n 1 | cut -d“” -  f2`
        如果[[$ {CUR_VER}！= v *]]; 然后
            CUR_VER = V $ {} CUR_VER
        科幻
        TAG_URL = “https://api.github.com/repos/v2ray/v2ray-core/releases/latest”
        NEW_VER =`curl $ {PROXY} -s $ {TAG_URL} --connect-timeout 10 | grep'tag_name'| 切-d \“ -  f4`
        如果[[$ {NEW_VER}！= v *]]; 然后
          NEW_VER = V $ {} NEW_VER
        科幻
        如果[[$？-ne 0]] || [[$ NEW_VER ==“”]]; 然后
            colorEcho $ {RED}“无法获取发布信息。请检查您的网络或重试。”
            返回3
        elif [[$ RETVAL -ne 0]];然后
            返回2
        elif [[`echo $ NEW_VER | 切-d。-f-2`！=`echo $ CUR_VER | 切-d。-f-2`]];然后
            返回1
        科幻
        返回0
    科幻
}

stopV2ray（）{
    colorEcho $ {BLUE}“关闭V2Ray服务。”
    if [[-n“$ {SYSTEMCTL_CMD}”]] || [[-f“/lib/systemd/system/v2ray.service”]] || [[-f“/etc/systemd/system/v2ray.service”]]; 然后
        $ {SYSTEMCTL_CMD}停止v2ray
    elif [[-n“$ {SERVICE_CMD}”]] || [[-f“/etc/init.d/v2ray”]]; 然后
        $ {SERVICE_CMD} v2ray停止
    科幻
    如果[[$？-ne 0]]; 然后
        colorEcho $ {YELLOW}“无法关闭V2Ray服务。”
        返回2
    科幻
    返回0
}

startV2ray（）{
    if [-n“$ {SYSTEMCTL_CMD}”] && [-f“/lib/systemd/system/v2ray.service”]; 然后
        $ {SYSTEMCTL_CMD}启动v2ray
    elif [-n“$ {SYSTEMCTL_CMD}”] && [-f“/etc/systemd/system/v2ray.service”]; 然后
        $ {SYSTEMCTL_CMD}启动v2ray
    elif [-n“$ {SERVICE_CMD}”] && [-f“/etc/init.d/v2ray”]; 然后
        $ {SERVICE_CMD} v2ray开始
    科幻
    如果[[$？-ne 0]]; 然后
        colorEcho $ {YELLOW}“无法启动V2Ray服务。”
        返回2
    科幻
    返回0
}

拷贝文件（） {
    NAME = $ 1
    ERROR =`cp“$ {VSRC_ROOT} / $ {NAME}”“/ usr / bin / v2ray / $ {NAME}”2>＆1`
    如果[[$？-ne 0]]; 然后
        colorEcho $ {YELLOW}“$ {ERROR}”
        返回1
    科幻
    返回0
}

makeExecutable（）{
    chmod + x“/ usr / bin / v2ray / $ 1”
}

installV2Ray（）{
    ＃将V2Ray二进制文件安装到/ usr / bin / v2ray
    mkdir -p / usr / bin / v2ray
    copyFile v2ray
    如果[[$？-ne 0]]; 然后
        colorEcho $ {RED}“无法复制V2Ray二进制文件和资源。”
        返回1
    科幻
    makeExecutable v2ray
    copyFile v2ctl && makeExecutable v2ctl
    copyFile geoip.dat
    copyFile geosite.dat

    ＃将V2Ray服务器配置安装到/ etc / v2ray
    如果[[！-f“/etc/v2ray/config.json”]]; 然后
        mkdir -p / etc / v2ray
        mkdir -p / var / log / v2ray
        cp“$ {VSRC_ROOT} /vpoint_vmess_freedom.json”“/ etc / v2ray / config.json”
        如果[[$？-ne 0]]; 然后
            colorEcho $ {YELLOW}“无法创建V2Ray配置文件。请手动创建。”
            返回1
        科幻
        让PORT = $ RANDOM + 10000
        UUID = $（cat / proc / sys / kernel / random / uuid）

        sed -i“s / 10086 / $ {PORT} / g”“/ etc / v2ray / config.json”
        sed -i“s / 23ad6b10-8d1a-40f7-8ad0-e3e35cd38297 / $ {UUID} / g”“/ etc / v2ray / config.json”

        colorEcho $ {BLUE}“PORT：$ {PORT}”
        colorEcho $ {BLUE}“UUID：$ {UUID}”
    科幻
    返回0
}


installInitScript（）{
    if [[-n“$ {SYSTEMCTL_CMD}”]];然后
        如果[[！-f“/etc/systemd/system/v2ray.service”]]; 然后
            如果[[！-f“/lib/systemd/system/v2ray.service”]]; 然后
                cp“$ {VSRC_ROOT} /systemd/v2ray.service”“/ etc / systemd / system /”
                systemctl enable v2ray.service
            科幻
        科幻
        返回
    elif [[-n“$ {SERVICE_CMD}”]] && [[！-f“/etc/init.d/v2ray”]]; 然后
        installSoftware“守护进程”|| 返回$？
        cp“$ {VSRC_ROOT} / systemv / v2ray”“/ etc / init.d / v2ray”
        chmod + x“/etc/init.d/v2ray”
        update-rc.d v2ray默认值
    科幻
    返回
}

救命（）{
    echo“./install-release.sh [-h] [-c] [ -  remove] [-p proxy] [-f] [--version vx.yz] [-l file]”
    echo“-h， -  help显示帮助”
    echo“-p， -  proxy要通过代理服务器下载，请使用-p socks5：//127.0.0.1：1080或-p http://127.0.0.1:3128等”
    echo“-f， -  force Force install”
    echo“--version安装特定版本，使用--version v3.15”
    echo“-l， -  local从本地文件安装”
    echo“ - 删除已安装的V2Ray”
    echo“-c， -  check检查更新”
    返回0
}

去掉（）{
    if [[-n“$ {SYSTEMCTL_CMD}”]] && [[-f“/etc/systemd/system/v2ray.service”]];然后
        如果pgrep“v2ray”> / dev / null; 然后
            stopV2ray
        科幻
        systemctl禁用v2ray.service
        rm -rf“/ usr / bin / v2ray”“/ etc / systemd / system / v2ray.service”
        如果[[$？-ne 0]]; 然后
            colorEcho $ {RED}“无法移除V2Ray。”
            返回0
        其他
            colorEcho $ {GREEN}“已成功删除V2Ray。”
            colorEcho $ {BLUE}“如有必要，请手动删除配置文件和日志文件。”
            返回0
        科幻
    elif [[-n“$ {SYSTEMCTL_CMD}”]] && [[-f“/lib/systemd/system/v2ray.service”]];然后
        如果pgrep“v2ray”> / dev / null; 然后
            stopV2ray
        科幻
        systemctl禁用v2ray.service
        rm -rf“/ usr / bin / v2ray”“/ lib / systemd / system / v2ray.service”
        如果[[$？-ne 0]]; 然后
            colorEcho $ {RED}“无法移除V2Ray。”
            返回0
        其他
            colorEcho $ {GREEN}“已成功删除V2Ray。”
            colorEcho $ {BLUE}“如有必要，请手动删除配置文件和日志文件。”
            返回0
        科幻
    elif [[-n“$ {SERVICE_CMD}”]] && [[-f“/etc/init.d/v2ray”]]; 然后
        如果pgrep“v2ray”> / dev / null; 然后
            stopV2ray
        科幻
        rm -rf“/ usr / bin / v2ray”“/ etc / init.d / v2ray”
        如果[[$？-ne 0]]; 然后
            colorEcho $ {RED}“无法移除V2Ray。”
            返回0
        其他
            colorEcho $ {GREEN}“已成功删除V2Ray。”
            colorEcho $ {BLUE}“如有必要，请手动删除配置文件和日志文件。”
            返回0
        科幻       
    其他
        colorEcho $ {YELLOW}“未找到V2Ray。”
        返回0
    科幻
}

检查更新（）{
    echo“正在检查更新”。
    VERSION = “”
    getVersion
    RETVAL = “$？”
    if [[$ RETVAL -eq 1]]; 然后
        colorEcho $ {BLUE}“为V2Ray找到了新版本$ {NEW_VER}。（当前版本：$ CUR_VER）”
    elif [[$ RETVAL -eq 0]]; 然后
        colorEcho $ {BLUE}“没有新版本。当前版本为$ {NEW_VER}。”
    elif [[$ RETVAL -eq 2]]; 然后
        colorEcho $ {YELLOW}“没有安装V2Ray。”
        colorEcho $ {BLUE}“V2Ray的最新版本是$ {NEW_VER}。”
    科幻
    返回0
}

主要（）{
    #helping信息
    [[“$ HELP”==“1”]] &&帮助&&返回
    [[“$ CHECK”==“1”]] && checkUpdate && return
    [[“$ REMOVE”==“1”]] &&删除&&返回
    
    sysArch
    ＃extract本地文件
    if [[$ LOCAL_INSTALL -eq 1]]; 然后
        colorEcho $ {YELLOW}“通过本地文件安装V2Ray。请确保该文件是有效的V2Ray包，因为我们无法确定。”
        NEW_VER =本地
        installSoftware unzip || 返回$？
        rm -rf / tmp / v2ray
        提取$ LOCAL || 返回$？
        #FILEVDIS =`ls / tmp / v2ray | grep v2ray-v | cut -d“ - ” -  f4`
        ＃SYSTEM =`ls / tmp / v2ray | grep v2ray-v | cut -d“ - ” -  f3`
        #if [[$ {SYSTEM}！=“linux”]]; 然后
        #colorEcho $ {RED}“无法在linux中安装本地V2Ray。”
        #return 1
        #elif [[$ {FILEVDIS}！= $ {VDIS}]]; 然后
        #colorEcho $ {RED}“本地V2Ray无法安装在$ {ARCH}系统中。”
        #return 1
        ＃其他
        ＃NEW_VER =`ls / tmp / v2ray | grep v2ray-v | cut -d“ - ” -  f2`
        #fi
    其他
        ＃通过网络下载并解压缩
        installSoftware“curl”|| 返回$？
        getVersion
        RETVAL = “$？”
        if [[$ RETVAL == 0]] && [[“$ FORCE”！=“1”]]; 然后
            colorEcho $ {BLUE}“已安装最新版本$ {NEW_VER}。”
            if [[“$ {ERROR_IF_UPTODATE}”==“1”]]; 然后
              返回10
            科幻
            返回
        elif [[$ RETVAL == 3]]; 然后
            返回3
        其他
            colorEcho $ {BLUE}“在$ {ARCH}上安装V2Ray $ {NEW_VER}”
            下载V2Ray || 返回$？
            installSoftware unzip || 返回$？
            提取$ {ZIPFILE} || 返回$？
        科幻
    科幻 
    
    如果[[“$ {EXTRACT_ONLY}”==“1”]]; 然后
        colorEcho $ {GREEN}“V2Ray提取到$ {VSRC_ROOT}，并退出......”
        返回0
    科幻

    如果pgrep“v2ray”> / dev / null; 然后
        V2RAY_RUNNING = 1
        stopV2ray
    科幻
    installV2Ray || 返回$？
    installInitScript || 返回$？
    if [[$ {V2RAY_RUNNING} -eq 1]];然后
        colorEcho $ {BLUE}“重启V2Ray服务。”
        startV2ray
    科幻
    colorEcho $ {GREEN}“V2Ray $ {NEW_VER}已安装。”
    rm -rf / tmp / v2ray
    返回0
}

主要
