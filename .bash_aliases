alias sudo='sudo '
alias nn='nano -ASlw'
alias rm='rm -i'
alias yinf='function _yinf(){
    for arg in "$@"
        do
            yaourt -Qi "$arg";
            yaourt -Ssi "$arg";
            yaourt -Fs --color always "$arg";
            read -n 1 -p "--Press any key--";
            echo -e "\r\033[K";
        done
    };
    _yinf'
alias cd='function _cd(){
                        builtin cd "$*" && ll;
                        };
                        _cd'
# The following function will extract a wide range of compressed file types. and use it with the syntax extract <file1> <file2>...
alias extract='function _extract(){
                                  if [ -f $1 ] ; then
                                  case $1 in
                                    *.tar.bz2)   tar xjf $1     ;;
                                    *.tar.gz)    tar xzf $1     ;;
                                    *.bz2)       bunzip2 $1     ;;
                                    *.rar)       unrar e $1     ;;
                                    *.gz)        gunzip $1      ;;
                                    *.tar)       tar xf $1      ;;
                                    *.tbz2)      tar xjf $1     ;;
                                    *.tgz)       tar xzf $1     ;;
                                    *.zip)       unzip $1       ;;
                                    *.Z)         uncompress $1  ;;
                                    *.7z)        7z x $1        ;;
                                    *)           echo "$1 cannot be extracted via extract()" ;;
                                  esac
                                  else
                                    echo "$1 is not a valid file";
                                  fi
                                  };
                                  _extract'
alias mkcd='function _mkcd(){
                            if [ ! -n "$1" ]; then
                              echo "Enter directory name";
                            elif [ -d $1 ]; then
                              echo "\$1 already exists";
                            else
                              mkdir $1 && cd $1;
                            fi
                            };
                            _mkcd'
alias b='function _b(){
                      str="";
                      count=0;
                      while [ "$count" -lt "$1" ];
                      do
                        str="$str../";
                        let count=count+1;
                      done
                      cd $str;
                      };
                      _b'
alias ll='function _ll(){
                        ls -lLhAX --color=always --group-directories-first $1 | while read DATA
                        do
                          case "${DATA:0:1}" in
                            "-"|"d"|"p"|"s")
                            PERM=$( echo "${DATA:1:9}" | sed "s/-/0/g;s/r/4/g;s/w/2/g;s/x/1/g" )
                            P_US=$((${PERM:0:1}+${PERM:1:1}+${PERM:2:1}))
                            P_GR=$((${PERM:3:1}+${PERM:4:1}+${PERM:5:1}))
                            P_OT=$((${PERM:6:1}+${PERM:7:1}+${PERM:8:1}))
                            DATA=$( echo "$DATA" | sed "s/${DATA:0:10}/${P_US}${P_GR}${P_OT}/" )
                            echo "$DATA"
                          ;;
                          *)
                            continue
                          ;;
                          esac
                        done
                        };
                        _ll'
alias ft='function _ft(){
                          find . -name "$2" -exec grep -il "$1" {} \;
                        };
                        _ft'
alias ploo='ps -feww | grep '
