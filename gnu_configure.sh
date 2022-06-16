#!/bin/sh
count=1
gnuplot << EOF
set terminal png
#set term png enhanced size 1280,1024
#set term png enhanced
set output "$1.png"
#set terminal postscript eps color enhanced
#set output "$1.eps"
set xlabel "$2"
x_min=10
x_max=80
x_delta=10
set ylabel "$3"
#set title "Sinulation Time vs pdr"
x_minimum=(x_min-x_delta)
x_maximum=(x_max+x_delta)
set xrange [ x_minimum : x_maximum ]
#set yrange [0.0203 : 0.02050]
#set format y "%.5f"
#set mxtics 10
#set mytics 5
set xtics (10,20,30,40,50)
#set ytics 0.00002
#set style data histograms
#set style fill solid
#set style histogram cluster gap 2
#set style fill solid border -1
#set boxwidth 1
#set key inside right top vertical Right noreverse noenhanced autotitle nobox
count=1
j_value_start=1
j_value_diff=1
plot for [j = j_value_start : count :j_value_diff] '$6'.j using $4 title '$7'.j with linespoints,for [j = j_value_start : count :j_value_diff]'$6'.j using $5 notitle with yerrorbars;
EOF
