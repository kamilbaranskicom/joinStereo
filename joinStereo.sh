#!/bin/bash

A=0;
SIZE=0;

while read L; do
	D=`dirname "$L"`;
	B=`basename "$L" .L.wav`;
	L="$B.L.wav";
	R="$B.R.wav";
	O="$B.wav";
	if [ -e "$D/$R" ]; then		# czy istnieje też plik .R.wav?
		if [ $A -eq 0 ]; then
			echo "-----------------------------------------------------------";
			echo "Połączę następujące pliki:";
			echo "-----------------------------------------------------------";
		fi
		let A=A+1;

		S1=`stat -f %z "$D/$L"`;
		S2=`stat -f %z "$D/$R"`;
		
		let SIZE=SIZE+S1+S2;

		echo "$A. *** $D/";
		echo "\"$L\" ($S1) i \"$R\" ($S2) do \"$O\"";
	fi
done < <(find . -name "*.L.wav")

if [ $A -eq 0 ]; then
	echo "-----------------------------------------------------------";
	echo "Brak plików *.L.wav i odpowiadających im *.R.wav.";
	echo "-----------------------------------------------------------";
	exit;
fi

SIZEMB=`echo "scale=2; $SIZE/1048576" | bc`;

echo "-----------------------------------------------------------";
echo "Zostanie stworzonych $A. plików o objętości ok. $SIZEMB MB.";
echo "Wolne miejsce na dysku to:";
df -l -m
echo "-----------------------------------------------------------";
echo "Na pewno?";
echo "-----------------------------------------------------------";
read napewno;

napewno="`echo $napewno|tr '[a-z]' '[A-Z]'`";

if [ $napewno = "OK" ] || [ $napewno = "Y" ] || [ $napewno = "T" ] || [ $napewno = "YES" ] || [ $napewno = "TAK" ]; then
	find . -name "*.L.wav" | while read L; do
		D=`dirname "$L"`;
		B=`basename "$L" .L.wav`;
		L="$B.L.wav";
		R="$B.R.wav";
		O="$B.wav";
		if [ -e "$D/$R" ]; then		# czy istnieje też plik .R.wav?
			echo "Dodaję \"$L\" do \"$R\" i tworzę \"$O\"";
			./sox-14.4.0/sox -M "$D/$L" "$D/$R" "$D/$O";
		fi
	done
fi
