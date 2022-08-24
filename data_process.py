from tkinter import OUTSIDE
import pandas as pd
import numpy as np
import os
from requests import head 
from scipy.io import savemat
os.chdir(os.path.dirname(os.path.abspath(__file__)))
matlabFileDir = "ZUPT-aided-INS"
# default column names

columnNames = [u"timestamp",u"Laser distance[m]",u"Laser force[N/kg]",u"Laser power[W/kg]",u"Laser velocity[m/s]",u"Laser velocity raw",u"Left foot angular velocity x[°/s]",u"Left foot angular velocity y[°/s]",u"Left foot angular velocity z[°/s]",u"Left foot tilt x[°]",u"Left foot tilt y[°]",u"Left foot tilt z[°]",u"Left foot euler x[°]",u"Left foot euler y[°]",u"Left foot euler z[°]",u"Left foot acceleration x[m/s2]",u"Left foot acceleration y[m/s2]",u"Left foot acceleration z[m/s2]",u"Left foot vert. acceleration[m/s2]",u"Left foot sum acceleration[m/s2]",u"Right foot angular velocity x[°/s]",u"Right foot angular velocity y[°/s]",u"Right foot angular velocity z[°/s]",u"Right foot tilt x[°]",u"Right foot tilt y[°]",u"Right foot tilt z[°]",u"Right foot euler x[°]",u"Right foot euler y[°]",u"Right foot euler z[°]",u"Right foot acceleration x[m/s2]",u"Right foot acceleration y[m/s2]",u"Right foot acceleration z[m/s2]",u"Right foot vert. acceleration[m/s2]",u"Right foot sum acceleration[m/s2]"]
def mySaveMat(matrixName, dataset, fileName = ""):
    """
    given matrix name save it

    ----
    Param
    ----

    matrixName: The name of the matrix to be saved
    
    dataset : a numpy matrix

    fileName : default the same as the matrix Name
    """
    # unique distance
    meas_all_dict = {}
    meas_all_dict[matrixName] = dataset
    # just in case, replace all spaces to _
    matrixName = matrixName.replace(" ", "_")
    if fileName == "":
        fileName = matrixName
    savemat(os.path.join(matlabFileDir, fileName + ".mat"), meas_all_dict)
    print("{0} mat saved at {1} under {2}".format(matrixName, matlabFileDir, fileName))

def my_csv2mat(fileName, matNamePrefix, dataMenu = ["left_standard", "right_standard","yMethod1"], sep = ";"):
    """
    convert csv 2 mat

    ----
    Param
    ---
    fileName : the file name of the csv file
    matNamePrefix  the name for the mat
    sep:  the separator of the file, default ;
    """
    # first read columns
    cols = pd.read_csv(fileName,sep=";", nrows=1).columns
    # measurements = pd.read_csv(fileName,sep=";", usecols=cols)[cols]
    # ignore the parse error lines,
    measurements = pd.read_csv(fileName,sep=";", error_bad_lines=False)[columnNames]
    # drop na lines, and reset index
    measurements.dropna(inplace=True)
    measurements.reset_index(drop=True, inplace=True)
    # use the standard column
    # measurements = pd.read_csv(fileName,sep=";", usecols=cols)[columnNames]
    header_names = measurements.columns.values.tolist()
    
    # unique distance
    measurements_unique_dist = measurements.groupby("Laser distance[m]", as_index=False).mean()
    # swap the 1st and 2nd columns
    header_columns = list(measurements_unique_dist)
    # get the index of time and distance
    time_index = measurements_unique_dist.columns.get_loc("timestamp")
    dist_index = measurements_unique_dist.columns.get_loc("Laser distance[m]")
    # swap the two
    header_columns[dist_index], header_columns[time_index] = header_columns[time_index], header_columns[dist_index]
    # swap the columns
    measurements_unique_dist = measurements_unique_dist.loc[:,header_columns]
    meas_all_arr = measurements_unique_dist.to_numpy()
    meas_all_arr = np.transpose(meas_all_arr)
    
    # # unique distance
    meas_all_dict = {}
    dist_unique_name = matNamePrefix + "_dist_unique"
    # meas_all_dict[dist_unique_name] = meas_all_arr
    # savemat(os.path.join(matlabFileDir, dist_unique_name + ".mat"), meas_all_dict)
    mySaveMat(dist_unique_name, meas_all_arr)
    # plain data
    dist_plain_name = matNamePrefix + "_plain"
    meas_plain_arr = measurements.to_numpy()
    meas_plain_arr = np.transpose(meas_plain_arr)
    mySaveMat(dist_plain_name, meas_plain_arr)

    # standard data set for ZUPT, left foot default
    # data menu
    for dataDish in dataMenu:
        if dataDish == "left_standard":
            # pruned_sets = measurements_unique_dist.loc[:, ["Left foot acceleration x[m/s2]", "Left foot acceleration y[m/s2]","Left foot acceleration z[m/s2]", "Left foot angular velocity x[°/s]","Left foot angular velocity y[°/s]","Left foot angular velocity z[°/s]"]]
            pruned_sets = measurements.loc[:, ["Left foot acceleration x[m/s2]", "Left foot acceleration y[m/s2]","Left foot acceleration z[m/s2]", "Left foot angular velocity x[°/s]","Left foot angular velocity y[°/s]","Left foot angular velocity z[°/s]"]]
            # the unique distance one
            pruned_unique_dist_sets = measurements_unique_dist.loc[:, ["Left foot acceleration x[m/s2]", "Left foot acceleration y[m/s2]","Left foot acceleration z[m/s2]", "Left foot angular velocity x[°/s]","Left foot angular velocity y[°/s]","Left foot angular velocity z[°/s]"]]
            matrixName = "u"
        elif dataDish == "right_standard":
            pruned_sets = measurements.loc[:, ["Right foot acceleration x[m/s2]", "Right foot acceleration y[m/s2]","Right foot acceleration z[m/s2]", "Right foot angular velocity x[°/s]","Right foot angular velocity y[°/s]","Right foot angular velocity z[°/s]"]]
            # unique dist
            pruned_unique_dist_sets = measurements_unique_dist.loc[:, ["Right foot acceleration x[m/s2]", "Right foot acceleration y[m/s2]","Right foot acceleration z[m/s2]", "Right foot angular velocity x[°/s]","Right foot angular velocity y[°/s]","Right foot angular velocity z[°/s]"]]
            matrixName = "u"
        elif dataDish == "yMethod1":
            pruned_sets = measurements.loc[:,["Laser distance[m]","Laser velocity[m/s]"]]
            pruned_unique_dist_sets = measurements_unique_dist.loc[:, ["Laser distance[m]","Laser velocity[m/s]"]]
            matrixName = "y"

        nameMat = matNamePrefix + "_" + dataDish + "_plain"
        pruned_arr = pruned_sets.to_numpy()
        pruned_arr = np.transpose(pruned_arr)
        mySaveMat(matrixName, pruned_arr, nameMat)

        nameMat_unique_dist = matNamePrefix + "_" + dataDish + "_unique_dist"
        pruned_arr_unique_dist = pruned_unique_dist_sets.to_numpy()
        pruned_arr_unique_dist = np.transpose(pruned_arr_unique_dist)
        mySaveMat(matrixName, pruned_arr_unique_dist, nameMat_unique_dist)


if __name__ == "__main__":

    # my_csv2mat(os.path.join("newdata", "200hz LaserSprint + IMU_Groth Joel_05-05-2022_16-55-28.csv"), "groth_200")
    my_csv2mat(os.path.join("newdata", "200hz Steganalys Laser och IMU_Larsson Henrik_02-05-2022_16-50-55.csv"), "henrik_200")
