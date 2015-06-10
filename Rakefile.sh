#!/bin/bash
for file in tests/*.rb; do ruby $file -p; done
