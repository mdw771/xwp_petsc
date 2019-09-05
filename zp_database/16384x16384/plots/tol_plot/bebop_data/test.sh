for i in {1..100}
do
	j=$(python3 -c "print(10**(-$i/10))")
	echo $j
done

