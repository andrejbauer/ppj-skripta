#!/bin/bash
export BASE_URL="/zapiski/ISRM-PPJ-2026/book/"
jupyter-book build --html --pdf && \
rsync -l -e ssh -r --delete -v _build/html/ andrej@lisa.andrej.com:/var/www/andrej.com/zapiski/ISRM-PPJ-2026/book/
