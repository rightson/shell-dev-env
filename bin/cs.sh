#!/bin/bash

export cscope_list=./cscope.list
export cscope_files=./cscope.files

to_abs_path() {
    local relative_path=$1
    echo $(cd "$relative_path"; /bin/pwd) 
}

to_abs_paths() {
    for each in $@; do
        to_abs_path $each
    done
}

add_cscope_search_path() {
    shift 1
    for param in "$@"; do 
        if [ "$param" != "" ]; then 
            to_abs_path "$param" >> $cscope_list
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
        find `cat $here/$cscope_list` -type f -name "*.c" \
                                           -o -name "*.h" \
                                           -o -name "*.S" \
                                           -o -name "*.cpp" \
                                           -o -name "*.equ" \
                                           -o -name "*.py" \
                                           -o -name "*.pl" \
                                           -o -name "*.rb" \
                                           -o -name "*.php" \
                                           -o -name "*.js" \
                                           -o -name "*.html" \
                                           -o -name "*.xml" \
            | grep -v svn > $here/$cscope_files 2> /dev/null        
        echo "Done (`size_of_file $here/$cscope_files`)"
        cd - > /dev/null
    else
        echo "Error: Failed to find $cscope_list"
        exit
    fi
}

generate_cscope_out() {
    if [ -f $cscope_files ]; then
        echo -n "Generating cscope.out ("
        echo -n "cscope -b -k)..." && cscope -b -k 
        echo "Done (`size_of_file ./cscope.out`)"
    else
        echo "Error: Failed to find $cscope_files"
        exit
        #echo -n "cscope -R -b -k)..." && cscope -R -b -k
    fi
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

cs_add() {
    add_cscope_search_path $@
    generate_cscope_files
    generate_cscope_out
}

custom_add() {
    local paths=`cat Makefile | grep BUILD_DEP_MODULE | grep -v '#' | cut -d " " -f 3`
    local abs_paths=
    for each in $paths; do
        abs_paths="$abs_paths ../$each"
    done
    add_cscope_search_path $abs_paths
    generate_cscope_files
    generate_cscope_out
}

trap control_c SIGINT SIGTERM

case "$1" in
    add) 
        cs_add $@
        ;;
    custom)
        custom_add $@
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

