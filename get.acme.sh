＃！/ usr / bin / env sh 

#https：//github.com/Neilpang/get.acme.sh 

_exists（）{ 
  cmd =“$ 1” 
  if [-z“$ cmd”]; 然后
    回显“用法：_exists cmd” 
    返回1 
  fi 
  如果类型命令> / dev / null 2>＆1; 然后
    命令-v $ cmd> / dev / null 2>＆1 
  else 
    键入$ cmd> / dev / null 2>＆1 
  fi 
  ret =“$？” 
  返回$ ret 
} 

如果_exists curl && [“$ {ACME_USE_WGET：-0}”=“0”]; 然后
  卷曲https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh | INSTALLONLINE = 1 sh 
elif _exists wget; 然后
  wget -O  -  https：//raw.githubusercontent。com / Neilpang / acme.sh / master / acme.sh | 
INSTALLONLINE = 1 sh else
  echo“抱歉，你必须先安装curl或wget。” 
  echo“请安装其中任何一个并重试。” 
科幻
