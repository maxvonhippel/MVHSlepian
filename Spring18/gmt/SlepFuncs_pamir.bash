#!/bin/bash

output1=SlepFuncs_pamir.ps

input1a=figdata/SlepEigfuncs_pamirg0.560.dat 
input1b=figdata/REGION-pamirg-10-0.5.dat

gmt set FONT_LABEL 10p,Helvetica,black FONT_ANNOT_PRIMARY 10p,Helvetica,black MAP_LABEL_OFFSET 1p PS_PAGE_ORIENTATION portrait MAP_GRID_PEN_PRIMARY 0.25p,gray COLOR_NAN 255 FORMAT_GEO_MAP +ddd:mm:ss MAP_FRAME_TYPE plain

# Region size for gridding
R=`gmtinfo -h2 -I1/1 $input1a`

# Projection info and region
projJ1=-JM4.4c
projR1=-R50/130/0/50

dashedcolor=black 
coastscolor=125/125/125 

# Use the header to get the data for the title
head -n1 $input1a > temp.info
head -n2 $input1a | tail -n1 > temp2.info
lambda1a=`awk '{print $1}' temp2.info`
lambda1b=`awk '{print $2}' temp2.info`
lambda1c=`awk '{print $3}' temp2.info`
lambda1d=`awk '{print $4}' temp2.info`
lambda1e=`awk '{print $5}' temp2.info`
lambda1f=`awk '{print $6}' temp2.info`


#makecpt -Ckelicol.cpt -T-1/1/0.05 -D -Z -V -M > slepfuncs2.cpt
# Use this once and then edit the cpt file to have white in the middle

# Row 1
awk '{print $1, $2, $3}' $input1a | xyz2grd -h2 -Gfigdata/func1.grd -I1 $R -V
gmt grdimage figdata/func1.grd $projJ1 $projR1 -Cslepfuncs.cpt -Bg10/a10g10Wesn -Y16c -E150 -K > $output1
gmt pscoast -J -R -A5000 -Dl -W0.5p,$coastscolor -O -K >> $output1
gmt psxy $input1b -J -R -W0.5p,$dashedcolor,-- -O -K >> $output1
echo "0.07 0.07 @~a@~=1" | gmt pstext -JX3.4c -R0/3.4/0/3.4 -Gwhite -W0.5p -F+f10p+jLB -O -N -K >> $output1
echo "4.33 0.07 @~l@~=$lambda1a" | gmt pstext -J -R -Gwhite -W0.5p -F+f10p+jRB -O -N -K >> $output1

awk '{print $1, $2, $4}' $input1a | gmt xyz2grd -h2 -Gfigdata/func1.grd -I1 $R -V
gmt grdimage figdata/func1.grd $projJ1 $projR1 -Cslepfuncs.cpt -Bg10/g10wesn -X4.75c -E150 -O -K >> $output1
gmt pscoast -J -R -A5000 -Dl -W0.5p,$coastscolor -O -K >> $output1
gmt psxy $input1b -J -R -W0.5p,$dashedcolor,-- -O -K >> $output1
echo "0.07 0.07 @~a@~=2" | gmt pstext -JX3.4c -R0/3.4/0/3.4 -W0.5p -Gwhite -F+f10p+jLB -O -N -K >> $output1
echo "4.33 0.07 @~l@~=$lambda1b" | gmt pstext -J -R -W0.5p -Gwhite -F+f10p+jRB -O -N -K >> $output1

awk '{print $1, $2, $5}' $input1a | gmt xyz2grd -h2 -Gfigdata/func1.grd -I1 $R -V
gmt grdimage figdata/func1.grd $projJ1 $projR1 -Cslepfuncs.cpt -Bg10/g10wesn -X4.75c -E150 -O -K >> $output1
gmt pscoast -J -R -A5000 -Dl -W0.5p,$coastscolor -O -K >> $output1
gmt psxy $input1b -J -R -W0.5p,$dashedcolor,-- -O -K >> $output1
echo "0.07 0.07 @~a@~=3" | gmt pstext -JX3.4c -R0/3.4/0/3.4 -Gwhite -W0.5p -F+f10p+jLB -O -N -K >> $output1
echo "4.33 0.07 @~l@~=$lambda1c" | gmt pstext -J -R -W0.5p -Gwhite -F+f10p+jRB -O -N -K >> $output1


# Row 2
awk '{print $1, $2, $6}' $input1a | gmt xyz2grd -h2 -Gfigdata/func1.grd -I1 $R -V
gmt grdimage figdata/func1.grd $projJ1 $projR1 -Cslepfuncs.cpt -Bg10/a10g10Wesn -Y-3.75c -X-9.5c -E150 -O -K >> $output1
gmt pscoast -J -R -A5000 -Dl -W0.5p,$coastscolor -Ba20g10/g10weSn -O -K >> $output1
gmt psxy $input1b -J -R -W0.5p,$dashedcolor,-- -O -K >> $output1
echo "0.07 0.07 @~a@~=4" | gmt pstext -JX3.4c -R0/3.4/0/3.4 -Gwhite -W0.5p -F+f10p+jLB -O -N -K >> $output1
echo "4.33 0.07 @~l@~=$lambda1d" | gmt pstext -J -R -W0.5p -Gwhite -F+f10p+jRB -O -N -K >> $output1

awk '{print $1, $2, $7}' $input1a | gmt xyz2grd -h2 -Gfigdata/func1.grd -I1 $R -V
gmt grdimage figdata/func1.grd $projJ1 $projR1 -Cslepfuncs.cpt -Bg10/g10wesn -X4.75c -E150 -O -K >> $output1
gmt pscoast -J -R -A5000 -Dl -W0.5p,$coastscolor -O -K >> $output1
gmt psxy $input1b -J -R -W0.5p,$dashedcolor,-- -O -K >> $output1
gmt psscale -D2.22c/-.8c/5c/.3ch -Cslepfuncs.cpt -B0.5:'magnitude': -O -K >> $output1
echo "0.07 0.07 @~a@~=5" | gmt pstext -JX3.4c -R0/3.4/0/3.4 -W0.5p -Gwhite -F+f10p+jLB -O -N -K >> $output1
echo "4.33 0.07 @~l@~=$lambda1e" | gmt pstext -J -R -W0.5p -Gwhite -F+f10p+jRB -O -N -K >> $output1

awk '{print $1, $2, $8}' $input1a | gmt xyz2grd -h2 -Gfigdata/func1.grd -I1 $R -V
gmt grdimage figdata/func1.grd $projJ1 $projR1 -Cslepfuncs.cpt -Bg20/g10wesn -X4.75c -E150 -O -K >> $output1
gmt pscoast -J -R -A5000 -Dl -W0.5p,$coastscolor -O -K -Ba20g10/g10weSn  >> $output1
gmt psxy $input1b -J -R -W0.5p,$dashedcolor,-- -O -K >> $output1
echo "0.07 0.07 @~a@~=6" | gmt pstext -JX3.4c -R0/3.4/0/3.4 -Gwhite -W0.5p -F+f10p+jLB -O -K -N >> $output1
echo "4.33 0.07 @~l@~=$lambda1f" | gmt pstext -J -R -Gwhite -W0.5p -O -N -F+f10p+jRB >> $output1



# Make it an eps and reset defaults
gmt psconvert $output1 -Au -Tef -V

