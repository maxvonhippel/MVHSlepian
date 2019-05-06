#!/bin/zsh
# Makes a GMT figure of Iceland and Greenland
# Check out: http://orbit.dtu.dk/files/9577519/7282-26519-1-PB.pdf
# Set I/O
output1=../figures/maps/iceland_and_greenland.ps
input1a=../figures/maps/figdata/border_1.0_iceland.dat
input2a=../figures/maps/figdata/border_0.5_greenland.dat
# Set defaults
gmtdefaults -D > .gmtdefaults4
gmtset FONT_LABEL 15 FONT_ANNOT_PRIMARY 15 MAP_LABEL_OFFSET 0.1 PS_PAGE_ORIENTATION portrait MAP_GRID_PEN_PRIMARY 0.5p COLOR_NAN 255 FORMAT_GEO_MAP +ddd:mm:ss MAP_GRID_PEN_PRIMARY 0.25p,gray
# projection and bounding box
projJ1=-JOa295/70/90/8.1i
projR1=-R275/59/19/65r
# colors
dashedcolor=black 
lightgrey=213/213/213
R=`gmtinfo -h2 -I1/1 $input1a`
psxy --PS_MEDIA=1500x800 $input1a $projJ1 $projR1 -G$lightgrey -K -t0 > $output1
psxy $input2a -J -R -G$lightgrey -O -K >> $output1
pscoast -J -R -B20WeSn -A5000 -Dl -W0.5p,$dashedcolor -O -K >> $output1
echo "11.5 12.5 Greenland" | pstext -JX3.4c -R0/3.4/0/3.4 -F+f15p+jLB -O -N -K >> $output1
echo "11.5 12 (b = 0.5)" | pstext -JX3.4c -R0/3.4/0/3.4 -F+f15p+jLB -O -N -K >> $output1
echo "16.9 8.7 Iceland" | pstext -JX3.4c -R0/3.4/0/3.4 -F+f15p+jLB -O -N -K >> $output1
echo "16.9 8.2 (b = 1.0)" | pstext -JX3.4c -R0/3.4/0/3.4 -F+f15p+jLB -O -N >> $output1
# open the result
psconvert $output1 -A+s12cm/8cm -Tef -V
pdfname="${output1%.*}"".pdf"
open $pdfname