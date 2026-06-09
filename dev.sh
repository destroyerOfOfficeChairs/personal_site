#!/bin/bash

# Check if either process is currently running
if pgrep -x "zola" > /dev/null || pgrep -f "tailwind_cli.*--watch" > /dev/null; then
    echo "Stopping development servers..."
    
    # Kill the processes
    pkill -x zola
    pkill -f "tailwind_cli.*--watch"
    
    echo "Servers stopped."
else
    echo "Starting development servers in the background..."
    
    # Start Tailwind in the background. 
    # The > /dev/null 2>&1 hides its text output so it doesn't spam your terminal.
    ./tailwind_cli -i ./sass/tailwind.css -o ./static/css/style.css --watch > /tmp/tailwind.log 2>&1 &

    # Start Zola in the background.
    zola serve > /dev/null 2>&1 &
    
    echo "Servers are running! You can now use this terminal to develop."
    echo "(Run ./dev.sh again to shut them down)"
fi
