ls text > temp.txt
grep '.txt' temp.txt | sed -e 's/.txt//' > filename.txt
rm temp.txt

echo "" > request.sh

IFS=$'\n'
while read -r line
do
  name="$line"
  value=$(<text/$name.txt)
  echo "{" > json/$name.json
  echo "  \"document\":{" >> json/$name.json
  echo "    \"type\":\"PLAIN_TEXT\"," >> json/$name.json
  echo "    \"content\":\"$value\"" >> json/$name.json
  echo "  }," >> json/$name.json
  echo "  \"encodingType\":\"UTF8\"" >> json/$name.json
  echo "}" >> json/$name.json
  echo "curl -s -k -H \"Content-Type: application/json\" -H \"Authorization: Bearer {Access Token}\" https://language.googleapis.com/v1/documents:analyzeEntities -d @json/$name.json > result/result_$name.txt" >>  request.sh
done < "filename.txt"

bash request.sh
