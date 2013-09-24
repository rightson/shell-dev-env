#!/bin/bash

export CSCOPE_LIST=./cscope.list
export CSCOPE_FILES=./cscope.files
export USE_ABS=n

to_abs_path() {
    local relative_path=$1
    if [  $USE_ABS = "y" ]; then
        echo $(cd "$relative_path"; /bin/pwd) 
    else
        echo $1
    fi
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
            to_abs_path "$param" >> $CSCOPE_LIST
            cat $CSCOPE_LIST | sort | uniq > $CSCOPE_LIST.tmp
            mv $CSCOPE_LIST.tmp $CSCOPE_LIST
        fi
    done
    if [ ! -f "$CSCOPE_LIST" ]; then
        if [  $USE_ABS = "y" ]; then
            echo -n "Search absolute path: "
            echo `pwd` > $CSCOPE_LIST;
        else
            echo -n "Search relative path: "
            echo "./" > $CSCOPE_LIST;
        fi
    fi
    echo "`cat $CSCOPE_LIST`"
}

print_cscope_list() {
    echo "Cscope search path:"
    test -f $CSCOPE_LIST && cat $CSCOPE_LIST
}

remove_CSCOPE_FILES() {
    rm -rf cscope.*
}

clear_cscope_list() {
    remove_CSCOPE_FILES
}

size_of_file() {
    du -h $1| awk '{print $1}'
}

append_to_CSCOPE_FILES() {
    local file=$1
    local here=`pwd`
    if [ -f $CSCOPE_LIST ]; then
        find `cat $here/$CSCOPE_LIST` -type f -name "$file" | grep -v svn >> $here/$CSCOPE_FILES 2> /dev/null
    else
        echo "Error: Failed to find $CSCOPE_LIST"
        exit
    fi
}

generate_cscope_files() {
    local here=`pwd`
    if [ -f $CSCOPE_LIST ]; then
        echo -n "Generating cscope.file (from $CSCOPE_LIST)..."
        rm -f $here/$CSCOPE_FILES
        append_to_CSCOPE_FILES "Makefile"
        append_to_CSCOPE_FILES "*.h"
        append_to_CSCOPE_FILES "*.hpp"
        append_to_CSCOPE_FILES "*.c"
        append_to_CSCOPE_FILES "*.cpp"
        append_to_CSCOPE_FILES "*.cc"
        append_to_CSCOPE_FILES "*.sh"
        append_to_CSCOPE_FILES "*.S"
        append_to_CSCOPE_FILES "*.equ"
        append_to_CSCOPE_FILES "*.py"
        append_to_CSCOPE_FILES "*.pl"
        append_to_CSCOPE_FILES "*.rb"
        append_to_CSCOPE_FILES "*.php"
        append_to_CSCOPE_FILES "*.java"
        append_to_CSCOPE_FILES "*.js"
        append_to_CSCOPE_FILES "*.html"
        append_to_CSCOPE_FILES "*.xml"
        echo "Done (`size_of_file $here/$CSCOPE_FILES`)"
    else
        echo "Error: Failed to find $CSCOPE_LIST"
        exit
    fi
}

generate_cscope_out() {
    if [ -f $CSCOPE_FILES ]; then
        echo -n "Generating cscope.out ("
        echo -n "cscope -b -k)..." && cscope -b -k 
        echo "Done (`size_of_file ./cscope.out`)"
    else
        echo "Error: Failed to find $CSCOPE_FILES"
        exit
        #echo -n "cscope -R -b -k)..." && cscope -R -b -k
    fi
}

usage() {
    echo "Cscope Index File (cscope.out) Generator"
    echo ""
    echo "Usage:"
    echo "  `basename $0` add [dir]     generate cscope.out (relative search path)"
    echo "  `basename $0` abs [dir]     generate cscope.out (absolute search path)"
    echo "  `basename $0` update        update cscope.out"
    echo "  `basename $0` list          list added cscope search path"
    echo "  `basename $0` clean         clean all cscope related index files"
    echo "  `basename $0` help          show this help"
}

control_c() {
    echo -e "\nControl-C captured\n"
    remove_CSCOPE_FILES
    exit;
}

cs_add() {
    add_cscope_search_path $@
    generate_cscope_files
    generate_cscope_out
}

trap control_c SIGINT SIGTERM

case "$1" in
    add) 
        cs_add $@
        ;;
    abs) 
        USE_ABS=y
        cs_add $@
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
    *)
        usage
        ;;
esac

