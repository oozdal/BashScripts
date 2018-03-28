### export PATH ###

export out_files=/gs/scratch/oozdal/mBLRISS/universal/out_files
((x = 75684))

for j in {1..80} # Number of f1 directiory (in general 50 jobs)
do
cd f$j
echo $j


FILE=00001.out

if [ ! -f "$FILE" ]
then
    echo "File $FILE does not exist"
fi


if [ -f "$FILE" ]
then

for j in $find *.out
do
mv $j stem.$x && mv stem.$x $out_files
echo stem.$x
(( x +=1 ))
done

fi
cd ../
done

