
build()
{
  LD_LIBRARY_PATH=./../libs
  export LD_LIBRARY_PATH
  make -f .makefile
}
clean()
{
  make clean -f .makefile
}
run()
{
  for param in $@
  do
    case $param in
      "build")
        build
        ;;
      "clean")
        clean
        ;;
      *)
      cmdhelp $0
      ;;
    esac
  done
}

cmdhelp()
{ 
  echo "Usage:"
  echo ". build.sh build"
  echo ". build.sh clean"
}

if [ $# -eq "0" ];then
  cmdhelp $0
elif [ $# -eq "1" ];then
  run $1
else
  cmdhelp $0
fi
