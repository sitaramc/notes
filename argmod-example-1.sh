#!/bin/bash

source `which argmod`
# sourcing this gets you a function "_argmod"

# _argmod, when called, munges "$@" according to the rules described and
# places the final result in the "args" array
_argmod "$@" <<'EOF'
    yturl (.*).part                         =>  yturl %1
    yturl (.*)\.f\d+\.(.*)                  =>  yturl %1.%2
    yturl .*-([^.]{10}.*)\.\w+$             =>  echo https://www.youtube.com/watch?v=%1
EOF

# then you execute the args array!
"${args[@]}"
