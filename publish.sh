#!/bin/bash
jupyter-book build . && \
rsync -l -e ssh -r --delete -v _build/html/ andrej@lisa.andrej.com:/var/www/andrej.com/zapiski/ISRM-PPJ-2025/book/
