!# /bin/zsh

freqRanges=(0 1000 2000 3000 4000 5000 6000 7000 8000 9000)
echo " Traditional|Simplified|Pinyin|Meaning" >words.txt

# Get words from each frequency range
for lowerIndex in ${freqRanges[@]}; do
    rangeName=$((lowerIndex + 1))-$((lowerIndex + 1000))
    wget -O $rangeName.buffer.txt "https://en.wiktionary.org/w/api.php?action=query&prop=revisions&titles=Appendix:Mandarin_Frequency_lists/${rangeName}&rvslots=*&rvprop=content&formatversion=2&format=json" && cat $rangeName.buffer.txt |
    jq -r '.query.pages[0].revisions[0].slots.main.content' |
    sed '$d' |
    tail -n +2 |
    tee $rangeName.txt >>words.txt

    rm $rangeName.buffer.txt
done

# Remove potential {{...}} from the end of words -- these contain embedded links to audio files accessible on Wiktionary
sed 's/{{.*}}$//' words.txt | cut -c2- >cleaned_words.txt

# Replace | with tab character so Observable can parse it
cat cleaned_words.txt | tr '|' '\t' >cleaned_words.tsv
