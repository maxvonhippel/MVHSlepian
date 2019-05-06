#!/bin/bash
country="iceland";
src=../figures/maps/figdata/"$country"_slep;
num=$(ls -l "$country"* | wc -l);
width=$(echo "sqrt ( $num )" | bc -l | awk '{print int($1+0.5)}');
height=$((num / width));
# Some borders
iceland10=../figures/maps/figdata/border_1.0_iceland.dat;
greenland05=../figures/maps/figdata/border_0.5_greenland.dat;
# Set defaults
dashedcolor=black;
coastscolor=125/125/125;
gmtdefaults -D > .gmtdefaults4;
gmtset FONT_LABEL 12 FONT_ANNOT_PRIMARY 12 MAP_LABEL_OFFSET 0.2 PS_PAGE_ORIENTATION portrait MAP_GRID_PEN_PRIMARY 0.5p COLOR_NAN 255 FORMAT_GEO_MAP +ddd:mm:ss MAP_GRID_PEN_PRIMARY 0.25p,gray;
# projection and bounding box
projJ1=-JOa320/60/65/10c;
projR1=-R330/60/0/70r;
# make postscript files
for i in $(seq 1 $num);
	do echo $i;
	# Make subplot
	datafile=$src/$country"_slep_"$i".dat";
	intermediary=$src/$country"_slep_"$i".grd";
	output=$src/$country"_slep_"$i".ps"
	R=`gmtinfo -h2 -I1/1 $datafile`;
	awk '{print $1, $2, $3}' $datafile | xyz2grd -h2 -G$intermediary -I1 $R -V;
	grdimage $intermediary $projJ1 $projR1 -Cslepfuncs_iceland.cpt -E150 -Bg10/a10g10Wesn -K > $output
	pscoast -J -R -A5000 -Dl -W0.5p,$coastscolor -O -K >> $output
	psxy $iceland10 -J -R -W0.5p,$dashedcolor,-- -O -K >> $output
	psxy $greenland05 -J -R -W0.5p,$dashedcolor,-- -O -K >> $output
	label="8.9 6 @~\141@~ = "$i;
	echo $label | pstext -JX3.4c -R0/3.4/0/3.4 -Gwhite -W0.5p -F+f12 -O -N >> $output
done;