#!/bin/bash

MDFILE=$1
echo Converting $MDFILE...

TMPHTML=$(echo $MDFILE | sed -e 's#md$#tmp.html#')
HTML=$(echo $MDFILE | sed -e 's#md$#html#')
echo ... to $HTML

pandoc $MDFILE -o html/$TMPHTML --metadata title="GPT climate policy analysis" --css https://raw.githubusercontent.com/xpatiate/nlp-climate-outputs/main/style.css -s

STYLE_LINE_NUM=$(grep -n '<link rel="stylesheet' html/$TMPHTML | cut -d':' -f 1)

echo "style is on line $STYLE_LINE_NUM"

FROMLINE=$(($STYLE_LINE_NUM-1))
TOLINE=$(($STYLE_LINE_NUM+1))
head -n $FROMLINE html/$TMPHTML > html/$HTML
echo '<style>' >> html/$HTML
cat style.css   >> html/$HTML
echo '</style>' >> html/$HTML
tail -n +$TOLINE html/$TMPHTML >> html/$HTML


PDF=$(echo $MDFILE | sed -e 's#md$#pdf#')
echo ... then $PDF

#pandoc html/$HTML -o pdf/$PDF -t html
wkhtmltopdf html/$HTML pdf/$PDF

