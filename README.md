## CSPRC: Efficient Estimator of Phase Response Curve via Compressive Sensing
CSPRC is a MATLAB toolbox for estimating the infinitesimal phase response curve (PRC) by using Compressive Sensing (CS) algorithms. For more information about the methodology, please check out our paper in Reference. This software is licensed under GPL 3.0 License.


### Dependencies
Currently the main part of this toolbox relies on the implementations of CS algorithms written by other great people, which are

1. [l1-MAGIC](http://users.ece.gatech.edu/~justin/l1magic/) (by Justin Romberg)
2. [L1 Homotopy](http://users.ece.gatech.edu/~sasif/homotopy/) (by Salman Asif)

In particulary, you need to have two MATLAB functions working, `l1eq_pd` and `DS_homotopy_function`.


### Installation
1. Download [l1-MAGIC](http://users.ece.gatech.edu/~justin/l1magic/) and [L1 Homotopy](http://users.ece.gatech.edu/~sasif/homotopy/), and add them in your MATLAB path.
2. Add CSPRC toolbox directory in your MATLAB path.
3. Profit!


### How to use
The basic workflow is 

1. Create the estimation data from the single cell recording data (`make_PRC_data`).
2. Create an estimator object (`csprc`).
3. Run a cross-validation test to find the best estimation parameter (`xvalidate`).
4. Estimatie the PRC with the found parameter (`csprc.evaluate`).

Take a look at the example, `demo_estimation_HH.m`, which shows the workflow in more detail.



### Reference
Hong S, Robberechts Q, De Schutter E (2012) Efficient Estimation of Phase Response Curves via Compressive Sensing. J Neurophys, in revision.
