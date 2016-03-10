#!/bin/bash

sudo wget -O /usr/local/bin/scope https://git.io/scope
sudo chmod a+x /usr/local/bin/scope
sudo scope launch

echo "Now open http://127.0.0.1:4040 in your web browser, to see the Weave Scope map."
