# Converts all .webp files in a directory to .png using magick

function fish-png
    for webp_file in *.webp
        set png_file (string replace -r '\.webp$' '.png' $webp_file)
        magick $webp_file $png_file
        and rm $webp_file
    end
end
