function strip_pdf_annotations() {
    local original=$1
    local name=${original%%.*}
    local ext=${original#*.}
    local uncompressed=`mktemp`.pdf
    local stripped=`mktemp`.pdf
    local output=$name-strpped.$ext 
    echo "Uncompressing $original ..."
    pdftk $original output $uncompressed uncompress
    echo "Striping $original ..."
    LANG=C sed -n '/^\/Annots/!p' $uncompressed > $stripped
    echo "Saving strpped $original as $output ..."
    pdftk $stripped output $output compress
}
