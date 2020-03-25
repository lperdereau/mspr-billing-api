mkdir docs
counter=1

echo "var versionNodes = [" > docs/docs_config.js
for v in $(git tag -l | xargs); do
    git reset --hard $v;
    mix docs
    if [ $counter -eq "1" ]; then
      echo "{version: "$v", url: "https://billing.louisperdereau.fr/doc//%22%7D," >> docs/docs_config.js;
      mv doc/* docs/
    else
      echo "{version: "$v", url: "https://billing.louisperdereau.fr/doc/$v//%22%7D," >> docs/docs_config.js;
      mv doc/ docs/$v
    fi
    counter=$((counter +1))
done
echo "]" >> docs/docs_config.js
mv ./docs ./doc
for d in $(find ./doc -type d -name "v*"); do
  cp doc/docs_config.js $d/
done