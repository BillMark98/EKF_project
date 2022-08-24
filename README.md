
# General Information

The work is based on [Open-Shoe program](https://github.com/hcarlsso/ZUPT-aided-INS)
new created are either located in the folder `newMethod` and `customFunc` or have a `my` prefix or similar notation.

# General Structure

The structure consists of two stages.

1. The first stage is data processing, which is done by python script

The `data_process.py` read data which is in `csv` file format

In the example code, the data is located at a directory `newdata`

2. The second stage is EKF method. To have a feeling, go to 
`myTester.m` and follow the instructions

# Methods used for Prediction

Currently there are four methods to use, the general information can be found in [methodList.md](methodList.md)