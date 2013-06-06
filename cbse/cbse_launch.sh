#!/bin/bash

for i in {1..100}
do
   time ./cbse.rb $i &
done

exit 0
