CERNLIB=/home/oozdal/LIBS/cern/2006b/x86_64-slc5-gcc43-opt/lib

source params.sh

#module load openmpi/1.8.3-gcc

echo $projname
echo $numofjobs
i=1

homefolder=/gs/scratch/oozdal/$MAINPROJDIR/$projname

 while [ $i -le $numofjobs ]

 do 

 dir=`expr f$i`
 run=`expr $projname\f$i`
 
 execname=`expr $dir/$run\.x`
 flname=`expr $run\.DAT`
 flrname=`expr $run\.REJ`
 seed=`date +%N`
 scriptname=`expr $run\.pbs`

 echo $i
 echo $seed
 echo $scriptname

 runthisfile=`expr $run\.x`
 jobname=`expr $run`


if [ $1 == 'compile' ]; then

 mkdir $dir

 sed -e "s/NANOSEED/$seed/" \
     -e "s/SUBFILENAME/$flname/" \
     -e "s/REJECT/$flrname/" \
     -e "s/Master_input/$MODEL/"\
     < mBLR_SP.f90 > SPrun.f90

#     -e "s/SPHENOUMSSM/$SPHENOHOME/" \
#     -e "s/MICROUMSSM/$MICROHOME/" \

gfortran -O -fno-automatic \
         -o $execname SPrun.f90 \
         -L$CERNLIB -lpdflib804 -lmathlib -lpacklib -lkernlib


 sed -e "s/qname/$quename/"\
     -e "s/runfile/$runthisfile/"\
     -e "s/JOB/$jobname/"\
     -e "s/worktime/$RUNTIME/"\
     -e "s/mainpro/$MAINPROJDIR/"\
     -e "s/nameofpro/$projname/"\
     -e "s/directory/$dir/"\
     < /home/oozdal/bin/runscript.pbs > $dir/$scriptname

 echo 'Created the script' $dir/$scriptname
 echo '    '

mkdir $dir/micromegas

fi

if [ $1 == 'sub' ]; then

 echo 'Submitting the run' $execname
 cd $dir
 qsub $scriptname
 cd ..
 fi
i=$[$i+1]
done

