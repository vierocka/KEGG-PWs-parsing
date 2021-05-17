# lynx https://www.kegg.jp/kegg-bin/search_pathway_text?map=eco
# select: PATHWAY
# P - print into file (save to a local file)
# output: KEGG_pathways_eco.txt
# check if ok

# all files will go into "Ecol_KEGG_PWs" folder:
mkdir Ecol_KEGG_PWs/
mv KEGG_pathways_eco.txt Ecol_KEGG_PWs/
cd Ecol_KEGG_PWs/
# only modules (Ecoli, KEGG DB) contain info about genes:
count=$(grep -P "\s[[:digit:]]{5}\sM" KEGG_pathways_eco.txt | awk ' { print $1 } ' | sort | uniq | wc -l | cut -d" " -f1) 
# check the variable 'count':
echo $count
# 122 found pathways
# get only module IDs:
grep -P "\s[[:digit:]]{5}\sM" KEGG_pathways_eco.txt | awk ' { print $1 } ' | sort | uniq > Ecoli_KEGG_moduleIDs.list
# check the number of lines (the number of KEGG modules with known genes): 
wc -l  Ecoli_KEGG_moduleIDs.list
# get a gene list for every KEGG's module:
for ((i=1; i<$(($count+1)); i++))
do
ID=$(sed -n ''$i'p' Ecoli_KEGG_moduleIDs.list | cut -d" " -f1)
lynx --dump https://www.genome.jp/dbget-bin/www_bget?pathway:eco$ID | grep -P "b[[:digit:]]{4}\s" | cut -d"]" -f2- | sed s/\ \ \ /\\t/ | sed s/\;\ /\\t/ > "Eco_KEGG_pathway_eco"$ID.tsv 
done
cd ..
chmod a+x Ecol_KEGG_PWs/*

