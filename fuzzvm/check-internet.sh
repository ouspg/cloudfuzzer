#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

if nc -zw1 www.google.com 80; then
  echo -e "${RED}WARNING:${NC} Internet connection is available! Fuzzvm machines are not supposed to be connected to Internet! Please check your instance settings."
else
    echo -e "${GREEN}Good:${NC} No Internet connection detected."
fi
