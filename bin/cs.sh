#!/bin/bash

export cscope_list=./cscope.list
export cscope_files=./cscope.files

add_cscope_search_path() {
    # if [ -n "$1" ]; then
    #     echo $(cd "$1"; /bin/pwd) >> $cscope_list
    #     cat $cscope_list | sort | uniq > $cscope_list.tmp
    #     mv $cscope_list.tmp $cscope_list
    #     echo -e "Current cscope search path:\n`cat $cscope_list`"
    # else
    #     echo "Add current path to cscope search path"
    #     pwd > $cscope_list
    # fi
    shift 1
    for param in "$@"; do 
        if [ "$param" != "" ]; then 
            echo $(cd "$param"; /bin/pwd) >> $cscope_list
            cat $cscope_list | sort | uniq > $cscope_list.tmp
            mv $cscope_list.tmp $cscope_list
        fi
    done
    if [ ! -f "$cscope_list" ]; then
        echo `pwd` > $cscope_list;
    fi
    echo -e "Current cscope search path:\n`cat $cscope_list`"
}

print_cscope_list() {
    echo "Cscope search path:"
    test -f $cscope_list && cat $cscope_list
}

remove_cscope_files() {
    rm -rf cscope.*
}

clear_cscope_list() {
    remove_cscope_files
}

size_of_file() {
    du -h $1| awk '{print $1}'
}

generate_cscope_files() {
    local here=`pwd`
    if [ -f $cscope_list ]; then
        cd /
        echo -n "Generating cscope.file (from $cscope_list)..."
        find `cat $here/$cscope_list` -type f -name "*.c" -o -name "*.h" -o -name "*.S" -o -name "*.cpp" -o -name "*.equ" | grep -v svn > $here/$cscope_files 2> /dev/null
        echo "Done (`size_of_file $here/$cscope_files`)"
        cd - > /dev/null
    fi
}

generate_cscope_out() {
    echo -n "Generating cscope.out ("
    if [ -f $cscope_files ]; then
        echo -n "cscope -b -k)..." && cscope -b -k 
    else
        echo -n "cscope -R -b -k)..." && cscope -R -b -k
    fi
    echo "Done (`size_of_file ./cscope.out`)"
}

usage() {
    echo "Usage:"
    echo "  `basename $0` add <dir>     add dir to cscope search path"
    echo "  `basename $0` update        update cscope db"
    echo "  `basename $0` list          list cscope search path"
    echo "  `basename $0` clean         clean cscope files"
    echo "  `basename $0` help          show this help"
}

control_c() {
    echo -e "\nControl-C captured\n"
    remove_cscope_files
    exit;
}

trap control_c SIGINT SIGTERM

case "$1" in
    add) 
        add_cscope_search_path $@
        generate_cscope_files
        generate_cscope_out
        ;;
    up)
        generate_cscope_files
        generate_cscope_out
        ;;
    update)
        generate_cscope_files
        generate_cscope_out
        ;;
    list) 
        print_cscope_list
        ;;
    clean) 
        clear_cscope_list       
        ;;
    -h|--help|help) 
        usage
        ;;
    *) 
        add_cscope_search_path $@
        generate_cscope_files
        generate_cscope_out
        ;;
esac

