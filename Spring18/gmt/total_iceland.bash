#!/bin/bash
# Makes a GMT figure of the total integrated change over
# iceland

# Set I/O
# output:
output1=../figures/maps/total_iceland.ps
# input:
intermediaryoutput=../figures/maps/figdata/total_iceland.grd
input1a=../figures/maps/figdata/border_1.0_iceland.dat
input2a=../figures/maps/figdata/border_0.5_greenland.dat
input1b=../figures/maps/figdata/iceland_total_mass_change.dat
# Set defaults
gmtdefaults -D > .gmtdefaults4
gmtset FONT_LABEL 10 FONT_ANNOT_PRIMARY 10 MAP_LABEL_OFFSET 0.2 PS_PAGE_ORIENTATION portrait MAP_GRID_PEN_PRIMARY 0.5p COLOR_NAN 255 FORMAT_GEO_MAP +ddd:mm:ss MAP_GRID_PEN_PRIMARY 0.25p,gray
# projection and bounding box
projJ1=-JOa320/60/65/10c
projR1=-R330/60/0/70r
# colors
dashedcolor=black 
coastscolor=125/125/125

# Make color gradient
# Appear to want 2.08871055901 to -4.91767950311 to be white?
# min=$(cat $input1b | awk '{ print $3 }' | sort -n | head -1)
# max=$(cat $input1b | awk '{ print $3 }' | sort -n | tail -1)
# # For some reason this step works in zsh but not in bash
# stepsize=$(($max - $min))
# minabs=$(echo $min | tr -d -)
# maxabs=$(echo $max | tr -d -)
# # https://stackoverflow.com/a/25268449/1586231
# max=$(dc -e "[$minabs]sM $maxabsd $minabs<Mp")
# min=$((0 - $newrange))
# stepsize=$(($max - $min))
# stepsize=$(($stepsize/20))
# makecpt -Ckelicol.cpt -T$min/$max/$stepsize -D -Z -V -M > slepfuncs_iceland.cpt

# Edit so everything from -10 to 10 is white
# Also add ;annotation to z-slices I want to show up in the colorbar

R=`gmtinfo -h2 -I1/1 $input1b`
awk '{print $1, $2, $3}' $input1b | xyz2grd -h2 -G$intermediaryoutput -I1 $R -V
grdimage $intermediaryoutput $projJ1 $projR1 -Cslepfuncs_iceland.cpt -E150 -Bg10a10Norn/a5g5WEsN -K > $output1
pscoast -J -R -A5000 -Dl -W0.5p,$coastscolor -O -K >> $output1
psxy $input1a -J -R -W0.5p,$dashedcolor,-- -O -K >> $output1
psxy $input2a -J -R -W0.5p,$dashedcolor,-- -O -K >> $output1
echo "7 6.5 4/2002 - 11/2016" | pstext -JX3.4c -R0/3.4/0/3.4 -Gwhite -W0.5p -F+f10p+jLB -O -N -K >> $output1
echo "8.9 6 N = 2" | pstext -JX3.4c -R0/3.4/0/3.4 -Gwhite -W0.5p -F+f10p+jLB -O -N -K >> $output1
psscale -Cslepfuncs_iceland.cpt -Dx5c/-0.25c+w10c/0.5c+jTC+h -B20:"surface density change (cm water equivalent)": -O >> $output1
# NOTE: add label saying "surface density change (cm water equivalent)"
# open the result
psconvert $output1 -Au -Tef -V
pdfname="${output1%.*}"".pdf"
open $pdfname