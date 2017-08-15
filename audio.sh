echo "" > ../GoogleSpeechAPI_test/script.sh
echo "" > ../IBMWatson_test/script.sh

cd mp3
ls > filename.txt
grep '.mp3' filename.txt | sed -e 's/.mp3//' > ../filename.txt
rm filename.txt
cd ..

echo "mkdir temp" > convertion.sh

IFS=$'\n'
while read -r line
do
  name="$line"
  echo "sox mp3/$name.mp3 temp/$name.wav rate 16k" >> convertion.sh
  echo "sox mp3/$name.mp3 temp/$name.flac rate 16k" >> convertion.sh
  echo "ffmpeg -i temp/$name.wav -ac 1 wav/$name.wav" >> convertion.sh
  echo "ffmpeg -i temp/$name.flac -ac 1 flac/$name.flac" >> convertion.sh  
  echo "rm temp/$name.wav" >> convertion.sh
  echo "rm temp/$name.flac" >> convertion.sh
  echo "python transcribe_async.py gs://gcs-bucket-judy/$name.flac > transcripts/$name.log" >> ../GoogleSpeechAPI_test/script.sh
  echo "curl -X POST -u {Access Token} --header \"Content-Type: audio/wav\" --header \"Transfer-Encoding: chunked\" --data-binary @../audioFiles/wav/$name.wav \"https://stream.watsonplatform.net/speech-to-text/api/v1/recognize\" > transcripts/$name.log" >> ../IBMWatson_test/script.sh 
done < "filename.txt"

echo "rm -r temp" >> convertion.sh

bash convertion.sh
cp filename.txt ../MicrosoftBingSpeechAPI_test/ServiceLibrary_test
cp filename.txt ../IBMWatson_test
cp filename.txt ../GoogleSpeechAPI_test
rm filename.txt
rm convertion.sh

