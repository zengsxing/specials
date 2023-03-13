while :
do
	R=$(od -A n -t d -N 4 /dev/urandom)
	echo $R
        echo "_G.RANDOMSEED = $R" > random.lua
	read -p "" -t 0.1 > /dev/null
done
