open(input, "<DNA-ex.txt") or die("cannot open file");
open(out, ">result.txt") or die("cannot open file");

seek input,66,0;
$i=0;
$counter=1; #to count three nucleotide for every aminoacid
@triplet=(); #created an empty arrat to put RNA triplets
while(!eof(input)){ #scan file until the end of the file 
	$tmp=getc(input); 
	if($tmp eq 'A' or $tmp eq 'T' or $tmp eq 'G' or $tmp eq 'C'){ #check if it is a nucleotide or space 
		#if tmp variable is not A,T,G or C; do not process that char 
		if($tmp eq 'A'){ #finding RNA equivalent of DNA nucleotide
			$tmp='U';
		}elsif($tmp eq 'T'){
			$tmp='A';
		}elsif($tmp eq 'G'){
			$tmp='C';	
		}elsif($tmp eq 'C'){
			$tmp='G';
		}
		#####################
		#combine RNA nucleotides as triplets
		if($counter==1){
			$store=$tmp;
			$counter=2;
		}elsif($counter==2){
			#$store=$triplet[i];
			$store=$store.$tmp;
			$counter=3;
		}elsif($counter==3){
			#$store=$triplet[i];
			$store=$store.$tmp;
			push(@triplet,$store);
			$counter=1;
			$i=$i+1;
			
		}
		###########################

	}
}

print "@triplet\n\n";#printing all triplets

#aminoacid hash table
%aminoacids= ('UUU'=> 'F','UUC'=> 'F','UUA'=> 'L','UUG'=> 'L',
				'UCU'=> 'S','UCC'=> 'S','UCA'=> 'S','UCG'=> 'S',
				'UAU'=> 'Y','UAC'=> 'Y','UAA'=> '-STOP-','UAG'=> '-STOP-',
				'UGU'=> 'C','UGC'=> 'C','UGA'=> '-STOP-','UGG'=> 'W',
				'CUU'=> 'L','CUC'=> 'L','CUA'=> 'L','CUG'=> 'L',
				'CCU'=> 'P','CCC'=> 'P','CCA'=> 'P','CCG'=> 'P',
				'CAU'=> 'H','CAC'=> 'H','CAA'=> 'Q','CAG'=> 'Q',
				'CGU'=> 'R','CGC'=> 'R','CGA'=> 'R','CGG'=> 'R',
				'AUU'=> 'I','AUC'=> 'I','AUA'=> 'I','AUG'=> 'M',
				'ACU'=> 'T','ACC'=> 'T','ACA'=> 'T','ACG'=> 'T',
				'AAU'=> 'N','AAC'=> 'N','AAA'=> 'K','AAG'=> 'K',
				'AGU'=> 'S','AGC'=> 'S','AGA'=> 'R','AGG'=> 'R',
				'GUU'=> 'V','GUC'=> 'V','GUA'=> 'V','GUG'=> 'V',
				'GCU'=> 'A','GCC'=> 'A','GCA'=> 'A','GCG'=> 'A',
				'GAU'=> 'D','GAC'=> 'D','GAA'=> 'E','GAG'=> 'E',
				'GGU'=> 'G','GGC'=> 'G','GGA'=> 'G','GGG'=> 'G');



print out "Aminoacids: ";

#print all aminoacids to file
foreach $tri (@triplet){
	print out "$aminoacids{$tri} ";
}

$status=0; #when start codon occurs, status=1 ; after stop codon seen, status=0 
$counter=1; #increases at every start codon after stop codon

print out "\n\nProteins: \n";
foreach $tri (@triplet){
	print "$aminoacids{$tri} ";
	if($aminoacids{$tri} eq 'M'){ #check start codon
		print out "protein #$counter\n";
		$status=1;
		print out $aminoacids{$tri};
	}elsif($aminoacids{$tri} eq '-STOP-'){ #check stop codon
		$status=0;
		print out "\n";
		$counter=$counter+1;
	}elsif($status==1){ #print when the aminoacid between start and stop codon
		print out $aminoacids{$tri};
	}
}


close(input);
close(out);
