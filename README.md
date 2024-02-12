# Raoultella terrigena stain RT01-5M1 hybrid assembly method
Code used to assemble and analyze Raoultella terrigena strain RT01-5M1 genome

## Description
To perform an hybrid assembly, nanopore reads were basecalled with Guppy v6.5.7 in super accuracy mode, adapters trimmed with Porechop v0.2.4 and low quality reads filtered out with Filtlong v0.2.1. Filtered reads were assembled with Trycycler v0.5.4 (12) to generate a consensus long read assembly from Raven v1.8.1 (13), Shasta v0.8.0 (14) and Flye v2.9 (15), with eight subsamples per assembler. Short reads were trimmed with fastp v0.23.4 (16) and NextPolish v1.4.1 (17), ntEdit v1.3.5 (18) and Polypolish v.0.5.0 (19) were used to polish the consensus assembly.

Genome assembly completion was assessed with CheckM v1.2.2 (20). Species identification was assessed using 1) 16S rRNA similarity with ??? vXXX (REF); 2) average nucleotide identity with FastANI (23); 3) mashID (https://github.com/duceppemo/mashID) combined with proGenomes v3 (24); and 4) by Genome-to-Genome Distance (25) compared to the *R. terrigena* type strain NBRC 14941 (Accession number GCA_006539725)

## References
12.Wick RR, Judd LM, Cerdeira LT, Hawkey J, Méric G, Vezina B, Wyres KL, Holt KE. 2021. Trycycler: consensus long-read assemblies for bacterial genomes. Genome Biol 22:266.
13. Vaser R, Šikić M. 2021. Time- and memory-efficient genome assembly with Raven. Nat Comput Sci 1:332–336.
14. Shafin K, Pesout T, Lorig-Roach R, Haukness M, Olsen HE, Bosworth C, Armstrong J, Tigyi K, Maurer N, Koren S, Sedlazeck FJ, Marschall T, Mayes S, Costa V, Zook JM, Liu KJ, Kilburn D, Sorensen M, Munson KM, Vollger MR, Monlong J, Garrison E, Eichler EE, Salama S, Haussler D, Green RE, Akeson M, Phillippy A, Miga KH, Carnevali P, Jain M, Paten B. 2020. Nanopore sequencing and the Shasta toolkit enable efficient de novo assembly of eleven human genomes. Nat Biotechnol 38:1044–1053.
15. Kolmogorov M, Yuan J, Lin Y, Pevzner PA. 2019. Assembly of long, error-prone reads using repeat graphs. Nat Biotechnol 37:540–546.
16. Chen S, Zhou Y, Chen Y, Gu J. 2018. fastp: an ultra-fast all-in-one FASTQ preprocessor. Bioinformatics 34:i884–i890.
17. Hu J, Fan J, Sun Z, Liu S. 2020. NextPolish: a fast and efficient genome polishing tool for long-read assembly. Bioinformatics 36:2253–2255.
18. Warren RL, Coombe L, Mohamadi H, Zhang J, Jaquish B, Isabel N, Jones SJM, Bousquet J, Bohlmann J, Birol I. 2019. ntEdit: scalable genome sequence polishing. Bioinformatics 35:4430–4432.
19. Wick RR, Holt KE. 2022. Polypolish: Short-read polishing of long-read bacterial genome assemblies. PLOS Comput Biol 18:e1009802.
20. Parks, D.H., Imelfort, M., Skennerton, C.T., Hugenholtz, P., Tyson, G.W. (2015) CheckM: assessing the quality of microbial genomes recovered from isolates, single cells, and metagenomes. Genome Res. 25, 1043–1055.
22. Bortolaia V, Kaas RS, Ruppe E, Roberts MC, Schwarz S, Cattoir V, Philippon A, Allesoe RL, Rebelo AR, Florensa AF, Fagelhauer L, Chakraborty T, Neumann B, Werner G, Bender JK, Stingl K, Nguyen M, Coppens J, Xavier BB, Malhotra-Kumar S, Westh H, Pinholt M, Anjum MF, Duggett NA, Kempf I, Nykäsenoja S, Olkkola S, Wieczorek K, Amaro A, Clemente L, Mossong J, Losch S, Ragimbeau C, Lund O, Aarestrup FM. 2020. ResFinder 4.0 for predictions of phenotypes from genotypes. J Antimicrob Chemother 75:3491–3500
23. Jain, C., Rodriguez-R, L.M., Phillippy, A.M. et al. High throughput ANI analysis of 90K prokaryotic genomes reveals clear species boundaries. Nat Commun 9, 5114 (2018). https://doi.org/10.1038/s41467-018-07641-9
24. Anthony Fullam, Ivica Letunic, Thomas S B Schmidt, Quinten R Ducarmon, Nicolai Karcher, Supriya Khedkar, Michael Kuhn, Martin Larralde, Oleksandr M Maistrenko, Lukas Malfertheiner, Alessio Milanese, Joao Frederico Matias Rodrigues, Claudia Sanchis-López, Christian Schudoma, Damian Szklarczyk, Shinichi Sunagawa, Georg Zeller, Jaime Huerta-Cepas, Christian von Mering, Peer Bork, Daniel R Mende, proGenomes3: approaching one million accurately and consistently annotated high-quality prokaryotic genomes, Nucleic Acids Research, Volume 51, Issue D1, 6 January 2023, Pages D760–D766, https://doi.org/10.1093/nar/gkac1078
25. Meier-Kolthoff, J.P., Sardà Carbasse, J., Peinado-Olarte, R.L., Göker, M. TYGS and LPSN: a database tandem for fast and reliable genome-based classification and nomenclature of prokaryotes. Nucleic Acid Res 50:D801–D807, 2022


