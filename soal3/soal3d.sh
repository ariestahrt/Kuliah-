#!/bin/bash
FORMAT="%m%d%Y"
DATE=$(date +"$FORMAT")
zip -r Koleksi.zip . -i \* -P $DATE